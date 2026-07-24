-- A1A PMS + VMS master-data engine for the Service Water pilot.
-- Sources: PMS B229-6-44-0005 Rev.1 (A1A sheets 1-8) and
-- VMS B229-6-44-0006-8120 Rev.A.

create table if not exists public.piping_classes (
  code text primary key,
  rating_class integer not null,
  base_material text not null,
  corrosion_allowance_mm numeric,
  service_description text,
  source_document text not null,
  source_revision text not null,
  attributes jsonb not null default '{}'::jsonb
);

create table if not exists public.piping_class_items (
  id uuid primary key default gen_random_uuid(),
  piping_class_code text not null references public.piping_classes(code) on delete cascade,
  item_group text not null,
  item_type text not null,
  lower_size_in numeric,
  upper_size_in numeric,
  schedule_or_thickness text,
  dimensional_standard text,
  material text,
  description text,
  commodity_code text,
  vms_sheet text,
  source_sheet integer not null,
  unique(piping_class_code,item_type,lower_size_in,upper_size_in,commodity_code)
);

create table if not exists public.valve_specifications (
  vms_sheet text primary key,
  valve_type text not null,
  rating_class integer not null,
  lower_size_in numeric,
  upper_size_in numeric,
  end_connection text,
  design_standard text,
  body_material text,
  trim_material text,
  seat_material text,
  stem_material text,
  closure_material text,
  packing_material text,
  gasket_material text,
  special_service text,
  hydro_body_psig numeric,
  hydro_seat_psig numeric,
  test_air_psig numeric,
  source_document text not null,
  source_revision text not null,
  source_page integer,
  notes jsonb not null default '[]'::jsonb
);

alter table public.piping_classes enable row level security;
alter table public.piping_class_items enable row level security;
alter table public.valve_specifications enable row level security;

create policy "read piping classes" on public.piping_classes for select to authenticated using (true);
create policy "read piping class items" on public.piping_class_items for select to authenticated using (true);
create policy "read valve specifications" on public.valve_specifications for select to authenticated using (true);

insert into public.piping_classes values (
 'A1A',150,'Carbon Steel',1.5,
 'A1A service assignment including the Service Water network where identified on the approved P&ID.',
 'B229-6-44-0005','1',
 jsonb_build_object(
  'pressure_temperature_kg_cm2g',jsonb_build_object('-29',20.03,'38',20.03,'93',18.28,'149',16.17,'204',14.06,'260',11.95,'316',9.84,'343',8.78,'371',7.73),
  'joint_rule','1.5 inch and below socket-weld coupling; 2 inch and above butt-welded',
  'maintenance_joints','Flanged joints kept to a minimum',
  'status','approved specification master'
 )) on conflict(code) do update set
 rating_class=excluded.rating_class,base_material=excluded.base_material,
 corrosion_allowance_mm=excluded.corrosion_allowance_mm,
 service_description=excluded.service_description,
 source_document=excluded.source_document,source_revision=excluded.source_revision,
 attributes=excluded.attributes;

insert into public.piping_class_items
(piping_class_code,item_group,item_type,lower_size_in,upper_size_in,schedule_or_thickness,dimensional_standard,material,description,commodity_code,vms_sheet,source_sheet)
values
('A1A','pipe','PIPE',0.5,0.75,'S160','ASME B36.10','ASTM A106 Gr.B','Plain-end seamless','PI21977Z0',null,4),
('A1A','pipe','PIPE',1,1.5,'XS','ASME B36.10','ASTM A106 Gr.B','Plain-end seamless','PI21977Z0',null,4),
('A1A','pipe','PIPE',2,2,'XS','ASME B36.10','ASTM A106 Gr.B','Bevel-end seamless','PI21917Z0',null,4),
('A1A','pipe','PIPE',3,14,'STD','ASME B36.10','ASTM A106 Gr.B','Bevel-end seamless','PI21917Z0',null,4),
('A1A','pipe','PIPE',16,36,'STD','ASME B36.10','ASTM A672 Gr.B60 Cl.12','Bevel-end EFSW','PI2A813Z0',null,4),
('A1A','flange','FLNG.WN',0.5,24,null,'ASME B16.5','ASTM A105','Class 150 RF/125 AARH welding-neck','FWC0127Z0',null,4),
('A1A','flange','FLNG.WN',26,52,null,'ASME B16.47 Series B','ASTM A105','Class 150 RF/125 AARH welding-neck','FWB0127Z0',null,4),
('A1A','fitting','ELBOW.90',2,14,null,'ASME B16.9','ASTM A234 Gr.WPB','BW 1.5D','WAG684Z10',null,5),
('A1A','fitting','T.EQUAL',2,14,null,'ASME B16.9','ASTM A234 Gr.WPB','Butt-weld equal tee','WEG684ZZ0',null,5),
('A1A','fitting','T.RED',2,14,null,'ASME B16.9','ASTM A234 Gr.WPB','Butt-weld reducing tee','WRG684ZZ0',null,5),
('A1A','fitting','REDUC.CONC',2,14,null,'ASME B16.9','ASTM A234 Gr.WPB','Butt-weld concentric reducer','WUG684ZZ0',null,5),
('A1A','fitting','REDUC.ECC',2,14,null,'ASME B16.9','ASTM A234 Gr.WPB','Butt-weld eccentric reducer','WVG684ZZ0',null,5),
('A1A','valve','VLV.GATE',0.25,1.5,null,'API 602 / ISO 15761','ASTM A105 body; stellited trim; 13% Cr stem','SW Class 800/3000','51001ZZZ0','51001',6),
('A1A','valve','VLV.GATE',2,42,null,'API 600 / ISO 10434','ASTM A216 Gr.WCB body; 13% Cr trim; stellited seats','Flanged Class 150 RF','51301ZZZ0','51301',6),
('A1A','valve','VLV.GLOBE',0.25,1.5,null,'API 602 / ISO 15761','ASTM A105 body; stellited trim','SW Class 800/3000','52001ZZZ0','52001',7),
('A1A','valve','VLV.GLOBE',2,16,null,'BS 1873','ASTM A216 Gr.WCB body; 13% Cr trim','Flanged Class 150 RF','52301ZZZ0','52301',7),
('A1A','valve','VLV.CHECK',0.25,1.5,null,'API 602 / ISO 15761','ASTM A105 body; stellited trim','SW Class 800/3000','53001ZZZ0','53001',7),
('A1A','valve','VLV.CHECK',2,24,null,'BS 1868','ASTM A216 Gr.WCB body; 13% Cr trim','Flanged Class 150 RF','53301ZZZ0','53301',7),
('A1A','valve','VLV.CHECK',2,24,null,'API 594','ASTM A216 Gr.WCB body; 13% Cr trim','Wafer Class 150','533GAZZZ0','533GA',7),
('A1A','valve','VLV.BALL',0.5,16,null,'BS EN ISO 17292','ASTM A105/A216 Gr.WCB; RPTFE seat','Flanged Class 150 RF','54301ZZZ0','54301',7),
('A1A','valve','VLV.PLUG',0.5,24,null,'BS 5353','ASTM A105/A216 Gr.WCB; hardened plug','Flanged Class 150 RF','55301ZZZ0','55301',7),
('A1A','valve','VLV.BTRFLY',3,24,null,'BS EN 593','ASTM A216 Gr.WCB body; 13% Cr trim','Wafer Class 150','56301ZZZ0','56301',7),
('A1A','gasket','GASKET',0.5,24,null,'ASME B16.20 / B16.5','SS316 + graphite + inner ring','Spiral wound Class 150','GK66272Z0',null,8),
('A1A','strainer','STRNR.PERM',2,14,null,'EIL standard','ASTM A234 Gr.WPB; SS304 internals','BW T-type','SP13344Z0',null,8)
on conflict do nothing;

insert into public.valve_specifications
(vms_sheet,valve_type,rating_class,lower_size_in,upper_size_in,end_connection,design_standard,body_material,trim_material,seat_material,stem_material,closure_material,packing_material,gasket_material,special_service,hydro_body_psig,hydro_seat_psig,test_air_psig,source_document,source_revision,source_page,notes)
values
('51001','Gate',800,0.25,1.5,'Socket-weld ASME B16.11','API 602 / ISO 15761','ASTM A105 forged','Stellited','Stellited','13% Cr steel','Solid wedge','Graphite braided anti-extrusion rings','Spiral wound SS316 graphite','Max 427 C',2975,2175,80,'B229-6-44-0006-8120','A',5,'["OS&Y","Renewable seat and packing"]'),
('51301','Gate',150,2,42,'Flanged RF ASME B16.5','API 600 / ISO 10434','ASTM A216 Gr.WCB','13% Cr steel','Stellited','13% Cr steel','Flexible/solid wedge by size','Graphite braided anti-extrusion rings','Spiral wound SS316 graphite','Max 371 C',450,325,80,'B229-6-44-0006-8120','A',11,'["OS&Y","Gear operator and bypass per technical notes"]'),
('52001','Globe',800,0.25,1.5,'Socket-weld ASME B16.11','API 602 / ISO 15761','ASTM A105 forged','Stellited','Stellited','13% Cr steel','Loose plug disc','Graphite braided anti-extrusion rings','Spiral wound SS316 graphite','Max 427 C',2975,2175,80,'B229-6-44-0006-8120','A',21,'["Rising stem"]'),
('52301','Globe',150,2,16,'Flanged RF ASME B16.5','BS 1873','ASTM A216 Gr.WCB','13% Cr steel','Stellited','13% Cr steel','Plug-type disc','Graphite braided anti-extrusion rings','Spiral wound SS316 graphite','Max 371 C',450,325,80,'B229-6-44-0006-8120','A',27,'[]'),
('53001','Check',800,0.25,1.5,'Socket-weld ASME B16.11','API 602 / ISO 15761','ASTM A105 forged','Stellited','Stellited',null,'Lift check',null,'Spiral wound SS316 graphite','Max 427 C',2975,2175,null,'B229-6-44-0006-8120','A',35,'[]'),
('53301','Check',150,2,24,'Flanged RF ASME B16.5','BS 1868','ASTM A216 Gr.WCB','13% Cr steel','Stellited',null,'Swing check',null,'Spiral wound SS316 graphite','Max 371 C',450,325,null,'B229-6-44-0006-8120','A',41,'[]'),
('533GA','Check',150,2,24,'Wafer ASME B16.5','API 594','ASTM A216 Gr.WCB','13% Cr steel','Flexible alloy overlay','SS316/13% Cr','Dual plate retainerless',null,null,'Water service',450,325,null,'B229-6-44-0006-8120','A',44,'["Spring-loaded plates"]'),
('54301','Ball',150,0.5,16,'Flanged RF ASME B16.5','BS EN ISO 17292','ASTM A105/A216 Gr.WCB','13% Cr/SS316','RPTFE','13% Cr/SS316','Solid ball','Graphite/PTFE V-rings','Graphite/PTFE','Max 204 C',450,325,null,'B229-6-44-0006-8120','A',53,'["Anti-blowout stem","Antistatic","Fire-safe where required"]'),
('55301','Plug',150,0.5,24,'Flanged RF ASME B16.5','BS 5353','ASTM A105/A216 Gr.WCB','Hardened plug',null,null,'Taper plug','Graphite rings','Spiral wound SS316 graphite','Hydrocarbon; max 250 C',450,325,null,'B229-6-44-0006-8120','A',67,'["Lubricated type"]'),
('56301','Butterfly',150,3,24,'Wafer ASME B16.5','BS EN 593','ASTM A216 Gr.WCB','13% Cr steel','NBR/Buna-N/EPDM/Viton by service','17-4PH/13% Cr','Cast disc','Graphite/SS316',null,'Cooling water; max 65 C; max 10.5 kg/cm2g',220,160,null,'B229-6-44-0006-8120','A',75,'["Antistatic shaft","Replaceable seat"]')
on conflict(vms_sheet) do update set
 valve_type=excluded.valve_type,rating_class=excluded.rating_class,
 lower_size_in=excluded.lower_size_in,upper_size_in=excluded.upper_size_in,
 end_connection=excluded.end_connection,design_standard=excluded.design_standard,
 body_material=excluded.body_material,trim_material=excluded.trim_material,
 seat_material=excluded.seat_material,stem_material=excluded.stem_material,
 closure_material=excluded.closure_material,packing_material=excluded.packing_material,
 gasket_material=excluded.gasket_material,special_service=excluded.special_service,
 hydro_body_psig=excluded.hydro_body_psig,hydro_seat_psig=excluded.hydro_seat_psig,
 test_air_psig=excluded.test_air_psig,source_page=excluded.source_page,notes=excluded.notes;

create or replace function public.resolve_valve_spec(p_class text,p_type text,p_size numeric)
returns setof public.valve_specifications
language sql stable security invoker as $$
 select v.* from public.piping_class_items i
 join public.valve_specifications v on v.vms_sheet=i.vms_sheet
 where i.piping_class_code=p_class and i.item_type=p_type
 and p_size between i.lower_size_in and i.upper_size_in
 order by i.lower_size_in desc limit 1;
$$;

grant execute on function public.resolve_valve_spec(text,text,numeric) to authenticated;
