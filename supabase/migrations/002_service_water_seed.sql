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
     'source','Vendor pump documents'
   )),
  ('line', 'SW-A1A-DEMO-001', 'Pump A Discharge Line', 'Illustrative line object pending approved line list.', 'draft',
   jsonb_build_object(
     'piping_class','A1A',
     'source','PMS',
     'data_quality','class-based; line tag illustrative'
   )),
  ('valve', 'SW-VLV-DEMO-001', 'Pump A Isolation Valve', 'Illustrative valve object pending approved valve list.', 'draft',
   jsonb_build_object(
     'vms_code','51301',
     'source','VMS',
     'data_quality','specification-based; valve tag illustrative'
   ))
on conflict (tag) do update
set name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    attributes = excluded.attributes,
    updated_at = now();

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select s.id, p.id, 'contains', '{}'::jsonb
from public.engineering_objects s
join public.engineering_objects p on p.tag = '501-P-0105A'
where s.tag = 'SW-SYSTEM'
on conflict do nothing;

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select p.id, l.id, 'discharges_to', jsonb_build_object('verification','pending approved P&ID/line list')
from public.engineering_objects p
join public.engineering_objects l on l.tag = 'SW-A1A-DEMO-001'
where p.tag = '501-P-0105A'
on conflict do nothing;

insert into public.engineering_relationships (source_object_id, target_object_id, relationship_type, metadata)
select l.id, v.id, 'contains', jsonb_build_object('verification','pending approved P&ID/valve list')
from public.engineering_objects l
join public.engineering_objects v on v.tag = 'SW-VLV-DEMO-001'
where l.tag = 'SW-A1A-DEMO-001'
on conflict do nothing;
