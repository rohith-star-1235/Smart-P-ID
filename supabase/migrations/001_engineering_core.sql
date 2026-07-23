create extension if not exists "pgcrypto";

create type public.app_role as enum ('admin','engineer','maintenance','inspector','viewer');
create type public.object_type as enum ('plant','unit','system','pid','equipment','line','valve','instrument','fitting','support');
create type public.object_status as enum ('active','inactive','standby','removed');
create type public.document_status as enum ('draft','approved','superseded','archived');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role public.app_role not null default 'viewer',
  company text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.engineering_objects (
  id uuid primary key default gen_random_uuid(),
  object_type public.object_type not null,
  tag text not null,
  name text not null,
  description text,
  parent_id uuid references public.engineering_objects(id) on delete set null,
  plant_id uuid references public.engineering_objects(id) on delete set null,
  unit_id uuid references public.engineering_objects(id) on delete set null,
  system_id uuid references public.engineering_objects(id) on delete set null,
  pid_id uuid references public.engineering_objects(id) on delete set null,
  status public.object_status not null default 'active',
  attributes jsonb not null default '{}'::jsonb,
  source_reference text,
  revision text,
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(object_type, tag)
);

create index engineering_objects_tag_idx on public.engineering_objects using gin (to_tsvector('english', tag || ' ' || name));
create index engineering_objects_system_idx on public.engineering_objects(system_id);
create index engineering_objects_attributes_idx on public.engineering_objects using gin(attributes);

create table public.engineering_relationships (
  id uuid primary key default gen_random_uuid(),
  source_object_id uuid not null references public.engineering_objects(id) on delete cascade,
  target_object_id uuid not null references public.engineering_objects(id) on delete cascade,
  relationship_type text not null check (relationship_type in ('connected-to','upstream-of','downstream-of','installed-on','part-of','isolated-by')),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(source_object_id, target_object_id, relationship_type)
);

create table public.documents (
  id uuid primary key default gen_random_uuid(),
  document_number text not null,
  title text not null,
  document_type text not null,
  revision text not null,
  status public.document_status not null default 'draft',
  storage_bucket text not null default 'engineering-documents',
  storage_path text not null,
  mime_type text not null default 'application/pdf',
  page_count integer,
  issued_at date,
  metadata jsonb not null default '{}'::jsonb,
  supersedes_document_id uuid references public.documents(id),
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  unique(document_number, revision)
);

create table public.object_documents (
  object_id uuid not null references public.engineering_objects(id) on delete cascade,
  document_id uuid not null references public.documents(id) on delete cascade,
  relationship text not null check (relationship in ('primary','reference','vendor','inspection','maintenance')),
  page_reference text,
  created_at timestamptz not null default now(),
  primary key(object_id, document_id, relationship)
);

create table public.object_revisions (
  id uuid primary key default gen_random_uuid(),
  object_id uuid not null references public.engineering_objects(id) on delete cascade,
  revision text not null,
  snapshot jsonb not null,
  change_summary text,
  approved_by uuid references auth.users(id),
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  unique(object_id, revision)
);

create table public.maintenance_records (
  id uuid primary key default gen_random_uuid(),
  object_id uuid not null references public.engineering_objects(id) on delete cascade,
  record_type text not null,
  work_order text,
  title text not null,
  description text,
  status text not null default 'open',
  performed_at timestamptz,
  next_due_at timestamptz,
  readings jsonb not null default '{}'::jsonb,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.engineering_objects enable row level security;
alter table public.engineering_relationships enable row level security;
alter table public.documents enable row level security;
alter table public.object_documents enable row level security;
alter table public.object_revisions enable row level security;
alter table public.maintenance_records enable row level security;

create policy "Authenticated users can read profiles" on public.profiles for select to authenticated using (true);
create policy "Users update own profile" on public.profiles for update to authenticated using (auth.uid() = id);
create policy "Authenticated users read engineering objects" on public.engineering_objects for select to authenticated using (true);
create policy "Engineering editors manage objects" on public.engineering_objects for all to authenticated using ((select role from public.profiles where id = auth.uid()) in ('admin','engineer')) with check ((select role from public.profiles where id = auth.uid()) in ('admin','engineer'));
create policy "Authenticated users read relationships" on public.engineering_relationships for select to authenticated using (true);
create policy "Engineering editors manage relationships" on public.engineering_relationships for all to authenticated using ((select role from public.profiles where id = auth.uid()) in ('admin','engineer')) with check ((select role from public.profiles where id = auth.uid()) in ('admin','engineer'));
create policy "Authenticated users read documents" on public.documents for select to authenticated using (true);
create policy "Engineering editors manage documents" on public.documents for all to authenticated using ((select role from public.profiles where id = auth.uid()) in ('admin','engineer')) with check ((select role from public.profiles where id = auth.uid()) in ('admin','engineer'));
create policy "Authenticated users read object documents" on public.object_documents for select to authenticated using (true);
create policy "Engineering editors manage object documents" on public.object_documents for all to authenticated using ((select role from public.profiles where id = auth.uid()) in ('admin','engineer')) with check ((select role from public.profiles where id = auth.uid()) in ('admin','engineer'));
create policy "Authenticated users read revisions" on public.object_revisions for select to authenticated using (true);
create policy "Authenticated users read maintenance" on public.maintenance_records for select to authenticated using (true);
create policy "Maintenance roles manage records" on public.maintenance_records for all to authenticated using ((select role from public.profiles where id = auth.uid()) in ('admin','engineer','maintenance','inspector')) with check ((select role from public.profiles where id = auth.uid()) in ('admin','engineer','maintenance','inspector'));

insert into storage.buckets (id, name, public)
values ('engineering-documents', 'engineering-documents', false)
on conflict (id) do nothing;
