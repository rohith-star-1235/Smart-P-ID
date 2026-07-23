-- Initial Service Water engineering dataset.
-- Source rule: pump values are vendor-document values; piping properties come from PMS;
-- valve properties come from VMS. Illustrative tags must be replaced by approved line/valve lists.

insert into public.engineering_objects (object_type, tag, name, description, status, attributes)
values
  ('system', 'SW-SYSTEM', 'Service Water System', 'Initial Smart P&ID system workspace.', 'active',
   jsonb_build_object('unit','Utilities','service','Service Water')),
  ('equipment', '501-P-0105A', 'Service Water Pump A', 'Horizontal end suction centrifugal pump.', 'active',
   jsonb_build_object(
     'manufacturer','Flowmore Ltd.',
     'type','Horizontal end suction centrifugal',
     'rated_flow_m3_h',100,
     'rated_head_m',87.7,
     'efficiency_percent',73.5,
     'npshr_m',4.1,
     'pump_input_kw',32.23,
     'motor_manufacturer','ABB',
     'motor_power_kw',55,
     'speed_rpm',2965,
     'mawp_kg_cm2g',13,
     'suction_nozzle_nb',100,
     'discharge_nozzle_nb',65,
     'source','Vendor pump documents',
     'verification_status','source-grounded'
   )),
  ('line', 'SW-A1A-DEMO-001', 'Pump A Discharge Line', 'Illustrative line object pending approved line list.', 'inactive',
   jsonb_build_object(
     'piping_class','A1A',
     'source','PMS',
     'verification_status','pending approved line list',
     'illustrative',true
   )),
  ('valve', 'SW-VLV-DEMO-001', 'Pump A Isolation Valve', 'Illustrative valve object pending approved valve list.', 'inactive',
   jsonb_build_object(
     'vms_code','51301',
     'source','VMS',
     'verification_status','pending approved valve list',
     'illustrative',true
   ))
on conflict (object_type, tag) do update
set name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    attributes = excluded.attributes,
    updated_at = now();

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select p.id, s.id, 'part-of', '{}'::jsonb
from public.engineering_objects p
join public.engineering_objects s on s.tag = 'SW-SYSTEM' and s.object_type = 'system'
where p.tag = '501-P-0105A' and p.object_type = 'equipment'
on conflict do nothing;

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select p.id, l.id, 'upstream-of', jsonb_build_object('verification','pending approved P&ID and line list')
from public.engineering_objects p
join public.engineering_objects l on l.tag = 'SW-A1A-DEMO-001' and l.object_type = 'line'
where p.tag = '501-P-0105A' and p.object_type = 'equipment'
on conflict do nothing;

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select v.id, l.id, 'installed-on', jsonb_build_object('verification','pending approved P&ID and valve list')
from public.engineering_objects v
join public.engineering_objects l on l.tag = 'SW-A1A-DEMO-001' and l.object_type = 'line'
where v.tag = 'SW-VLV-DEMO-001' and v.object_type = 'valve'
on conflict do nothing;
