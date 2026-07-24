-- Reusable graph model for any piping service network.

create table if not exists public.piping_systems (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  service text not null,
  piping_class_code text references public.piping_classes(code),
  source_pid_documents text[] not null default '{}',
  status text not null default 'draft' check(status in ('draft','verified','approved','superseded')),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.network_nodes (
  id uuid primary key default gen_random_uuid(),
  system_id uuid not null references public.piping_systems(id) on delete cascade,
  node_key text not null,
  node_type text not null check(node_type in ('source','equipment_nozzle','valve','tee','reducer','instrument','battery_limit','tie_in','consumer','drain','vent','continuation','dead_end')),
  tag text,
  name text,
  unit_name text,
  pid_document text,
  pid_sheet text,
  x numeric,
  y numeric,
  attributes jsonb not null default '{}'::jsonb,
  unique(system_id,node_key)
);

create table if not exists public.network_segments (
  id uuid primary key default gen_random_uuid(),
  system_id uuid not null references public.piping_systems(id) on delete cascade,
  segment_key text not null,
  line_number text,
  from_node_id uuid not null references public.network_nodes(id),
  to_node_id uuid not null references public.network_nodes(id),
  flow_direction text not null default 'forward' check(flow_direction in ('forward','reverse','bidirectional','unknown')),
  nominal_size_in numeric,
  piping_class_code text references public.piping_classes(code),
  schedule_or_thickness text,
  material text,
  design_pressure numeric,
  design_temperature numeric,
  operating_pressure numeric,
  operating_temperature numeric,
  length_m numeric,
  internal_diameter_mm numeric,
  volume_m3 numeric generated always as (
    case when length_m is not null and internal_diameter_mm is not null
      then pi() * power(internal_diameter_mm / 1000.0, 2) / 4.0 * length_m
      else null end
  ) stored,
  source_pid_document text,
  source_pid_sheet text,
  verification_status text not null default 'unverified' check(verification_status in ('unverified','extracted','verified','approved')),
  attributes jsonb not null default '{}'::jsonb,
  unique(system_id,segment_key)
);

create table if not exists public.network_valves (
  id uuid primary key default gen_random_uuid(),
  system_id uuid not null references public.piping_systems(id) on delete cascade,
  node_id uuid not null unique references public.network_nodes(id) on delete cascade,
  valve_tag text,
  valve_item_type text not null,
  nominal_size_in numeric not null,
  piping_class_code text not null references public.piping_classes(code),
  vms_sheet text references public.valve_specifications(vms_sheet),
  normal_position text check(normal_position in ('open','closed','locked_open','locked_closed','unknown')),
  actuation text,
  isolation_service boolean not null default true,
  verification_status text not null default 'unverified' check(verification_status in ('unverified','extracted','verified','approved')),
  attributes jsonb not null default '{}'::jsonb
);

alter table public.piping_systems enable row level security;
alter table public.network_nodes enable row level security;
alter table public.network_segments enable row level security;
alter table public.network_valves enable row level security;

create policy "read piping systems" on public.piping_systems for select to authenticated using(true);
create policy "read network nodes" on public.network_nodes for select to authenticated using(true);
create policy "read network segments" on public.network_segments for select to authenticated using(true);
create policy "read network valves" on public.network_valves for select to authenticated using(true);

insert into public.piping_systems(code,name,service,piping_class_code,source_pid_documents,status,metadata)
values(
 'SERVICE-WATER','Service Water Network','Service Water','A1A',
 array['B224-79-41-332-1114-1 Rev 7','B224-79-41-332-1114-2 Rev 7'],
 'draft',
 jsonb_build_object(
   'pilot',true,
   'scope','Complete source-to-consumer network tracing',
   'data_rule','Topology, line numbers and valves only from approved P&ID; specification from A1A PMS and VMS',
   'pump_tags',jsonb_build_array('501-P-0105A','501-P-0105B','501-P-0105C','501-P-0105D')
 )
) on conflict(code) do update set
 name=excluded.name,service=excluded.service,piping_class_code=excluded.piping_class_code,
 source_pid_documents=excluded.source_pid_documents,metadata=excluded.metadata,updated_at=now();

create or replace function public.trace_downstream(p_system uuid,p_start uuid)
returns table(depth integer,node_id uuid,node_key text,node_type text,tag text,path uuid[])
language sql stable security invoker as $$
 with recursive walk as (
   select 0,n.id,n.node_key,n.node_type,n.tag,array[n.id]::uuid[]
   from public.network_nodes n where n.system_id=p_system and n.id=p_start
   union all
   select w.depth+1,n2.id,n2.node_key,n2.node_type,n2.tag,w.path||n2.id
   from walk w
   join public.network_segments s on s.system_id=p_system and s.from_node_id=w.id
   join public.network_nodes n2 on n2.id=s.to_node_id
   where not n2.id=any(w.path)
 )
 select * from walk;
$$;

create or replace function public.trace_upstream(p_system uuid,p_start uuid)
returns table(depth integer,node_id uuid,node_key text,node_type text,tag text,path uuid[])
language sql stable security invoker as $$
 with recursive walk as (
   select 0,n.id,n.node_key,n.node_type,n.tag,array[n.id]::uuid[]
   from public.network_nodes n where n.system_id=p_system and n.id=p_start
   union all
   select w.depth+1,n2.id,n2.node_key,n2.node_type,n2.tag,w.path||n2.id
   from walk w
   join public.network_segments s on s.system_id=p_system and s.to_node_id=w.id
   join public.network_nodes n2 on n2.id=s.from_node_id
   where not n2.id=any(w.path)
 )
 select * from walk;
$$;

grant execute on function public.trace_downstream(uuid,uuid) to authenticated;
grant execute on function public.trace_upstream(uuid,uuid) to authenticated;
