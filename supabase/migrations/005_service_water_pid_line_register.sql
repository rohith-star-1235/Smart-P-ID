-- Imports Service Water line identifiers extracted from approved P&IDs.
create table if not exists public.pid_line_register(
 id uuid primary key default gen_random_uuid(),system_code text not null,line_number text not null,
 nominal_size_in numeric not null,service_code text not null,piping_class text not null,
 source_pid text not null,source_revision text not null,verification_status text not null default 'extracted'
 check(verification_status in('extracted','visually_verified','approved','rejected')),
 extraction_note text,from_node_id uuid,to_node_id uuid,attributes jsonb not null default '{}',
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(system_code,line_number,source_pid));
create index if not exists pid_line_register_system_idx on public.pid_line_register(system_code);
create index if not exists pid_line_register_number_idx on public.pid_line_register(line_number);
alter table public.pid_line_register enable row level security;
drop policy if exists "Authenticated users read P&ID line register" on public.pid_line_register;
create policy "Authenticated users read P&ID line register" on public.pid_line_register for select to authenticated using(true);
drop policy if exists "Engineering editors manage P&ID line register" on public.pid_line_register;
create policy "Engineering editors manage P&ID line register" on public.pid_line_register for all to authenticated
using((select role from public.profiles where id=auth.uid()) in('admin','engineer'))
with check((select role from public.profiles where id=auth.uid()) in('admin','engineer'));

with src(source_pid,source_revision,line_number) as(
 select 'B224-79-41-332-1114-1','7',unnest(array['2"-WS-332-1401-1-A1A','2"-WS-332-1401-2-A1A','2"-WS-332-1401-5-A1A','2"-WS-332-1402-1-A1A','2"-WS-332-1403-1-A1A','2"-WS-332-1403-2-A1A','2"-WS-332-1403-3-A1A','2"-WS-332-1403-4-A1A','2"-WS-332-1403-5-A1A','2"-WS-332-1403-6-A1A','2"-WS-332-1403-7-A1A','2"-WS-332-1403-8-A1A','2"-WS-332-1403-9-A1A','2"-WS-332-1406-1-A1A','2"-WS-332-1406-11-A1A','2"-WS-332-1406-2-A1A','2"-WS-332-1406-3-A1A','2"-WS-332-1406-4-A1A','2"-WS-332-1406-6-A1A','2"-WS-332-1406-7-A1A','2"-WS-332-1406-8-A1A','2"-WS-332-1406-9-A1A','2"-WS-332-1407-2-A1A','2"-WS-332-1407-3-A1A','2"-WS-332-1407-4-A1A','2"-WS-332-1408-10-A1A','2"-WS-332-1408-13-A1A','2"-WS-332-1408-14-A1A','2"-WS-332-1408-4-A1A','2"-WS-332-1408-5-A1A','2"-WS-332-1408-6-A1A','2"-WS-332-1409-2-A1A','2"-WS-332-1409-4-A1A','2"-WS-332-1409-5-A1A','2"-WS-332-1409-6-A1A','2"-WS-332-1409-7-A1A','2"-WS-332-1410-2-A1A','2"-WS-332-1410-3-A1A','2"-WS-332-1410-4-A1A','2"-WS-332-1411-1-A1A','2"-WS-332-1411-A1A','2"-WS-332-1412-11-A1A','2"-WS-332-1412-12-A1A','2"-WS-332-1412-4-A1A','2"-WS-332-1412-5-A1A','2"-WS-332-1412-6-A1A','2"-WS-332-1412-7-A1A','2"-WS-332-1412-8-A1A','2"-WS-332-1413-1-A1A','2"-WS-332-1413-2-A1A','2"-WS-332-1413-4-A1A','2"-WS-332-1413-5-A1A','2"-WS-332-1413-7-A1A','2"-WS-332-1414-1-A1A','2"-WS-332-1414-2-A1A','2"-WS-332-1414-3-A1A','2"-WS-332-1414-4-A1A','2"-WS-332-1414-5-A1A','2"-WS-332-1417-2-A1A','2"-WS-332-1417-3-A1A','2"-WS-332-1418-1-A1A','2"-WS-332-1418-2-A1A','2"-WS-332-1418-A1A','2"-WS-332-1422-1-A1A','2"-WS-332-1425-1-A1A','2"-WS-332-1425-2-A1A','2"-WS-332-1425-3-A1A','2"-WS-332-1484-1-A1A','3"-WS-332-1403-A1A','3"-WS-332-1404-A1A','3"-WS-332-1406-3-A1A','3"-WS-332-1406-A1A','3"-WS-332-1407-A1A','3"-WS-332-1408-1-A1A','3"-WS-332-1409-8-A1A','3"-WS-332-1412-3-A1A','3"-WS-332-1413-6-A1A','3"-WS-332-1417-1-A1A','3"-WS-332-1417-A1A','3"-WS-332-1419-A1A','3"-WS-332-1484-A1A','4"-WS-332-1408-A1A','4"-WS-332-1410-A1A','4"-WS-332-1412-9-A1A','4"-WS-332-1413-3-A1A','4"-WS-332-1414-6-A1A','4"-WS-332-1418-A1A','4"-WS-332-1422-2-A1A','4"-WS-332-1425-A1A','6"-WS-332-1412-10-A1A','6"-WS-332-1414-A1A','8"-WS-332-1402-3-A1A','10"-WS-332-1402-A1A','10"-WS-332-1409-1-A1A','10"-WS-332-1409-A1A','10"-WS-332-1412-A1A','12"-WS-332-1401-A1A'])
 union all
 select 'B224-79-41-332-1114-2','7',unnest(array['2"-WS-332-1412-5-A1A','2"-WS-332-1414-7-A1A','2"-WS-332-1415-1-A1A','2"-WS-332-1415-2-A1A','2"-WS-332-1415-3-A1A','2"-WS-332-1415-4-A1A','2"-WS-332-1415-5-A1A','2"-WS-332-1416-1-A1A','2"-WS-332-1416-2-A1A','2"-WS-332-1416-5-A1A','2"-WS-332-1416-6-A1A','2"-WS-332-1416-7-A1A','2"-WS-332-1420-1-A1A','2"-WS-332-1420-2-A1A','2"-WS-332-1420-3-A1A','2"-WS-332-1420-4-A1A','2"-WS-332-1420-5-A1A','2"-WS-332-1420-6-A1A','3"-WS-332-1416-A1A','3"-WS-332-1420-A1A','4"-WS-332-1415-A1A','6"-WS-332-1412-A1A','6"-WS-332-1414-A1A'])
)
insert into public.pid_line_register(system_code,line_number,nominal_size_in,service_code,piping_class,
source_pid,source_revision,verification_status,extraction_note)
select 'SERVICE-WATER-OSBL',line_number,
replace(split_part(line_number,'-',1),'"','')::numeric,'WS','A1A',source_pid,source_revision,'extracted',
'Detected in P&ID text layer; node, valve and endpoint connectivity requires visual verification'
from src
on conflict(system_code,line_number,source_pid) do update set
nominal_size_in=excluded.nominal_size_in,source_revision=excluded.source_revision,
verification_status=excluded.verification_status,extraction_note=excluded.extraction_note,updated_at=now();

create or replace view public.service_water_line_summary as
select source_pid,source_revision,count(*) line_identifier_count,
count(*) filter(where verification_status='approved') approved_count,
count(*) filter(where verification_status='extracted') pending_visual_verification,
array_agg(distinct nominal_size_in order by nominal_size_in) nominal_sizes_in
from public.pid_line_register where system_code='SERVICE-WATER-OSBL'
group by source_pid,source_revision;