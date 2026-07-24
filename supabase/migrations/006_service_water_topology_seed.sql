-- First traceable Service Water topology extracted from approved P&IDs
-- B224-79-41-332-1114-1 Rev 7 and B224-79-41-332-1114-2 Rev 7.
-- Connections are intentionally marked 'extracted' until engineering verification.

DO $$
DECLARE
  v_system uuid;
BEGIN
  SELECT id INTO v_system FROM public.piping_systems WHERE code='SERVICE-WATER';
  IF v_system IS NULL THEN
    RAISE EXCEPTION 'SERVICE-WATER system not found. Run migration 004 first.';
  END IF;

  -- Core source, headers, continuation points and consumers.
  INSERT INTO public.network_nodes
    (system_id,node_key,node_type,tag,name,unit_name,pid_document,pid_sheet,x,y,attributes)
  VALUES
    (v_system,'SW-SOURCE-PUMP-HOUSE','source','501-P-0105A/B/C/D','Service Water Pump House','Raw Water Treatment Plant','B224-79-41-332-1114-1 Rev 7','1',20,88,
      jsonb_build_object('source_basis','P&ID + approved pump vendor documents','verification_status','extracted')),
    (v_system,'SW-HDR-1401','tee',null,'12 inch Service Water Main Header','OSBL','B224-79-41-332-1114-1 Rev 7','1',30,84,
      jsonb_build_object('line_number','12"-WS-332-1401-A1A','verification_status','extracted')),
    (v_system,'SW-HDR-1402','tee',null,'10 inch Northern Distribution Header','OSBL','B224-79-41-332-1114-1 Rev 7','1',35,25,
      jsonb_build_object('line_number','10"-WS-332-1402-A1A','verification_status','extracted')),
    (v_system,'SW-HDR-1409','tee',null,'10 inch Central Distribution Header','OSBL','B224-79-41-332-1114-1 Rev 7','1',36,52,
      jsonb_build_object('line_number','10"-WS-332-1409-A1A','verification_status','extracted')),
    (v_system,'SW-HDR-1412','tee',null,'6 inch Southern Distribution Header','OSBL','B224-79-41-332-1114-1 Rev 7','1',58,83,
      jsonb_build_object('line_number','6"-WS-332-1412-A1A','verification_status','extracted')),
    (v_system,'SW-HDR-1414','tee',null,'6 inch Eastern Distribution Header','OSBL','B224-79-41-332-1114-1 Rev 7','1',68,23,
      jsonb_build_object('line_number','6"-WS-332-1414-A1A','verification_status','extracted')),
    (v_system,'SW-CONT-1114-2-N','continuation','332-1114-2','Continuation to Sheet 2 - North','OSBL','B224-79-41-332-1114-1 Rev 7','1',94,25,
      jsonb_build_object('destination_document','B224-79-41-332-1114-2 Rev 7','verification_status','verified')),
    (v_system,'SW-CONT-1114-2-S','continuation','332-1114-2','Continuation to Sheet 2 - South','OSBL','B224-79-41-332-1114-1 Rev 7','1',94,54,
      jsonb_build_object('destination_document','B224-79-41-332-1114-2 Rev 7','verification_status','verified')),

    (v_system,'SW-CONS-ADMIN','consumer',null,'Administration Building','Administration','B224-79-41-332-1114-1 Rev 7','1',5,10,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-GAS-TERMINAL','consumer',null,'Gas Terminal','Gas Terminal','B224-79-41-332-1114-1 Rev 7','1',13,10,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-POMS','consumer',null,'POMS','POMS','B224-79-41-332-1114-1 Rev 7','1',20,10,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CRUDE-BLENDING','consumer',null,'Crude Blending and Crude Pump Station','Crude Blending','B224-79-41-332-1114-1 Rev 7','1',29,10,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-MCR','consumer',null,'Main Control Room','MCR','B224-79-41-332-1114-1 Rev 7','1',40,37,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CT1','consumer',null,'Cooling Tower 1','CT-1 Refinery','B224-79-41-332-1114-1 Rev 7','1',53,37,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CDU-VDU','consumer',null,'CDU / VDU','CDU/VDU','B224-79-41-332-1114-1 Rev 7','1',64,31,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-DCU','consumer',null,'DCU and Unsaturated LPG Treating','DCU','B224-79-41-332-1114-1 Rev 7','1',69,39,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-PFCC','consumer',null,'PFCC and PRU Block','PFCC','B224-79-41-332-1114-1 Rev 7','1',51,50,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-HGU','consumer',null,'Hydrogen Generation Unit','HGU','B224-79-41-332-1114-1 Rev 7','1',41,50,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-SRU','consumer',null,'SRU / ARU / SWS / TGTU','SRU/ARU/SWS/TGTU','B224-79-41-332-1114-1 Rev 7','1',47,80,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-RODM','consumer',null,'RO-DM and CPU','RO-DM/CPU','B224-79-41-332-1114-1 Rev 7','1',37,95,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-ETP','consumer',null,'Effluent Treatment Plant','ETP','B224-79-41-332-1114-1 Rev 7','1',52,95,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-PPU','consumer',null,'PPU Train 1 and 2','PPU','B224-79-41-332-1114-1 Rev 7','1',69,62,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-LLDPE-HDPE','consumer',null,'LLDPE / HDPE Trains','LLDPE/HDPE','B224-79-41-332-1114-1 Rev 7','1',63,65,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-WAREHOUSE','consumer',null,'PPU / LLDPE Product Warehouse','Warehouse','B224-79-41-332-1114-1 Rev 7','1',75,86,'{"verification_status":"extracted"}'),

    (v_system,'SW-S2-HDR-1414','tee',null,'Sheet 2 Northern Header','OSBL','B224-79-41-332-1114-2 Rev 7','2',17,15,
      jsonb_build_object('line_number','6"-WS-332-1414-A1A','verification_status','extracted')),
    (v_system,'SW-S2-HDR-1412','tee',null,'Sheet 2 Southern Header','OSBL','B224-79-41-332-1114-2 Rev 7','2',18,79,
      jsonb_build_object('line_number','6"-WS-332-1412-A1A','verification_status','extracted')),
    (v_system,'SW-CONS-LCR-CHP','consumer',null,'LCR / CHP','LCR/CHP','B224-79-41-332-1114-2 Rev 7','2',19,30,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-MS-BLENDING','consumer',null,'MS Blending Station','MS Blending','B224-79-41-332-1114-2 Rev 7','2',49,22,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CBD7','consumer',null,'CBD-7','CBD-7','B224-79-41-332-1114-2 Rev 7','2',49,31,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-C4','consumer',null,'C4 and C4 Offspec Pump Station','C4 Offspec PS','B224-79-41-332-1114-2 Rev 7','2',52,47,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-BUTADIENE','consumer',null,'Butadiene Pump Station','Butadiene PS','B224-79-41-332-1114-2 Rev 7','2',61,47,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-MARKETING-AREA','consumer',null,'Marketing Area Product BL and Butadiene Gantry','Marketing Area','B224-79-41-332-1114-2 Rev 7','2',70,47,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-PROD-PS1','consumer',null,'Product PS-1 / MFA / Dosing Packages','Product PS-1','B224-79-41-332-1114-2 Rev 7','2',26,48,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CT4','consumer',null,'Cooling Tower 4','CT-4','B224-79-41-332-1114-2 Rev 7','2',26,58,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-CBD8','consumer',null,'CBD-8','CBD-8','B224-79-41-332-1114-2 Rev 7','2',39,72,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-ABD2','consumer',null,'ABD-2','ABD-2','B224-79-41-332-1114-2 Rev 7','2',43,72,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-INST-PS4','consumer',null,'Instrument Pump Station 4','INST PS-4','B224-79-41-332-1114-2 Rev 7','2',48,72,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-PRODUCT-PS2','consumer',null,'Product Pump Station 2','Product PS-2','B224-79-41-332-1114-2 Rev 7','2',53,72,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-MARKETING-TERMINAL','consumer',null,'Marketing Terminal','Marketing Terminal','B224-79-41-332-1114-2 Rev 7','2',59,92,'{"verification_status":"extracted"}'),
    (v_system,'SW-CONS-UNLOADING-PS','consumer',null,'Unloading Pump Station','Unloading PS','B224-79-41-332-1114-2 Rev 7','2',78,77,'{"verification_status":"extracted"}')
  ON CONFLICT (system_id,node_key) DO UPDATE SET
    node_type=excluded.node_type,tag=excluded.tag,name=excluded.name,unit_name=excluded.unit_name,
    pid_document=excluded.pid_document,pid_sheet=excluded.pid_sheet,x=excluded.x,y=excluded.y,
    attributes=excluded.attributes;

  -- Core header connectivity. Segment keys are stable identifiers for the graph.
  INSERT INTO public.network_segments
    (system_id,segment_key,line_number,from_node_id,to_node_id,flow_direction,nominal_size_in,piping_class_code,source_pid_document,source_pid_sheet,verification_status,attributes)
  SELECT v_system, x.segment_key, x.line_number, fn.id, tn.id, 'forward', x.size_in, 'A1A', x.pid_doc, x.pid_sheet, x.status,
         jsonb_build_object('confidence',x.confidence,'topology_basis','visual extraction from approved P&ID')
  FROM (VALUES
    ('SEG-1401-SOURCE','12"-WS-332-1401-A1A','SW-SOURCE-PUMP-HOUSE','SW-HDR-1401',12::numeric,'B224-79-41-332-1114-1 Rev 7','1','extracted','high'),
    ('SEG-1402-FEED','10"-WS-332-1402-A1A','SW-HDR-1401','SW-HDR-1402',10,'B224-79-41-332-1114-1 Rev 7','1','extracted','medium'),
    ('SEG-1409-FEED','10"-WS-332-1409-A1A','SW-HDR-1401','SW-HDR-1409',10,'B224-79-41-332-1114-1 Rev 7','1','extracted','medium'),
    ('SEG-1412-FEED','6"-WS-332-1412-A1A','SW-HDR-1401','SW-HDR-1412',6,'B224-79-41-332-1114-1 Rev 7','1','extracted','medium'),
    ('SEG-1414-FEED','6"-WS-332-1414-A1A','SW-HDR-1402','SW-HDR-1414',6,'B224-79-41-332-1114-1 Rev 7','1','extracted','medium'),
    ('SEG-1414-CONT','6"-WS-332-1414-A1A','SW-HDR-1414','SW-CONT-1114-2-N',6,'B224-79-41-332-1114-1 Rev 7','1','verified','high'),
    ('SEG-1412-CONT','6"-WS-332-1412-A1A','SW-HDR-1412','SW-CONT-1114-2-S',6,'B224-79-41-332-1114-1 Rev 7','1','verified','high'),
    ('SEG-S2-1414','6"-WS-332-1414-A1A','SW-CONT-1114-2-N','SW-S2-HDR-1414',6,'B224-79-41-332-1114-2 Rev 7','2','verified','high'),
    ('SEG-S2-1412','6"-WS-332-1412-A1A','SW-CONT-1114-2-S','SW-S2-HDR-1412',6,'B224-79-41-332-1114-2 Rev 7','2','verified','high')
  ) AS x(segment_key,line_number,from_key,to_key,size_in,pid_doc,pid_sheet,status,confidence)
  JOIN public.network_nodes fn ON fn.system_id=v_system AND fn.node_key=x.from_key
  JOIN public.network_nodes tn ON tn.system_id=v_system AND tn.node_key=x.to_key
  ON CONFLICT (system_id,segment_key) DO UPDATE SET
    line_number=excluded.line_number,from_node_id=excluded.from_node_id,to_node_id=excluded.to_node_id,
    nominal_size_in=excluded.nominal_size_in,piping_class_code=excluded.piping_class_code,
    source_pid_document=excluded.source_pid_document,source_pid_sheet=excluded.source_pid_sheet,
    verification_status=excluded.verification_status,attributes=excluded.attributes;

  -- Branches that are clearly associated with named consumers on the drawings.
  INSERT INTO public.network_segments
    (system_id,segment_key,line_number,from_node_id,to_node_id,flow_direction,nominal_size_in,piping_class_code,source_pid_document,source_pid_sheet,verification_status,attributes)
  SELECT v_system, x.segment_key, x.line_number, fn.id, tn.id, 'forward', x.size_in, 'A1A', x.pid_doc, x.pid_sheet, 'extracted',
         jsonb_build_object('confidence',x.confidence,'requires_field_verification',true)
  FROM (VALUES
    ('BR-ADMIN','2"-WS-332-1401-1-A1A','SW-HDR-1402','SW-CONS-ADMIN',2::numeric,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-GAS-TERMINAL','2"-WS-332-1401-2-A1A','SW-HDR-1402','SW-CONS-GAS-TERMINAL',2,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-POMS','2"-WS-332-1401-5-A1A','SW-HDR-1402','SW-CONS-POMS',2,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-CRUDE-BLENDING','3"-WS-332-1403-A1A','SW-HDR-1402','SW-CONS-CRUDE-BLENDING',3,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-MCR','4"-WS-332-1410-A1A','SW-HDR-1409','SW-CONS-MCR',4,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-CT1','2"-WS-332-1410-2-A1A','SW-HDR-1409','SW-CONS-CT1',2,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-CDU-VDU','3"-WS-332-1413-6-A1A','SW-HDR-1409','SW-CONS-CDU-VDU',3,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-DCU','4"-WS-332-1413-3-A1A','SW-HDR-1409','SW-CONS-DCU',4,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-PFCC','4"-WS-332-1412-9-A1A','SW-HDR-1412','SW-CONS-PFCC',4,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-HGU','2"-WS-332-1411-A1A','SW-HDR-1409','SW-CONS-HGU',2,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-SRU','4"-WS-332-1418-A1A','SW-HDR-1412','SW-CONS-SRU',4,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-RODM','3"-WS-332-1419-A1A','SW-HDR-1412','SW-CONS-RODM',3,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-ETP','2"-WS-332-1413-7-A1A','SW-HDR-1412','SW-CONS-ETP',2,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-PPU','3"-WS-332-1417-A1A','SW-HDR-1412','SW-CONS-PPU',3,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-LLDPE-HDPE','4"-WS-332-1422-2-A1A','SW-HDR-1412','SW-CONS-LLDPE-HDPE',4,'B224-79-41-332-1114-1 Rev 7','1','medium'),
    ('BR-WAREHOUSE','2"-WS-332-1484-1-A1A','SW-HDR-1412','SW-CONS-WAREHOUSE',2,'B224-79-41-332-1114-1 Rev 7','1','low'),

    ('BR-LCR-CHP','2"-WS-332-1414-7-A1A','SW-S2-HDR-1414','SW-CONS-LCR-CHP',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-MS-BLENDING','2"-WS-332-1416-2-A1A','SW-S2-HDR-1414','SW-CONS-MS-BLENDING',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-CBD7','2"-WS-332-1416-5-A1A','SW-S2-HDR-1414','SW-CONS-CBD7',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-C4','2"-WS-332-1416-1-A1A','SW-S2-HDR-1414','SW-CONS-C4',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-BUTADIENE','2"-WS-332-1416-6-A1A','SW-S2-HDR-1414','SW-CONS-BUTADIENE',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-MARKETING-AREA','2"-WS-332-1416-7-A1A','SW-S2-HDR-1414','SW-CONS-MARKETING-AREA',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-PROD-PS1','2"-WS-332-1415-4-A1A','SW-S2-HDR-1412','SW-CONS-PROD-PS1',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-CT4','2"-WS-332-1415-1-A1A','SW-S2-HDR-1412','SW-CONS-CT4',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-CBD8','2"-WS-332-1420-1-A1A','SW-S2-HDR-1412','SW-CONS-CBD8',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-ABD2','2"-WS-332-1420-2-A1A','SW-S2-HDR-1412','SW-CONS-ABD2',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-INST-PS4','2"-WS-332-1420-3-A1A','SW-S2-HDR-1412','SW-CONS-INST-PS4',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-PRODUCT-PS2','2"-WS-332-1420-4-A1A','SW-S2-HDR-1412','SW-CONS-PRODUCT-PS2',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-MARKETING-TERMINAL','2"-WS-332-1420-5-A1A','SW-S2-HDR-1412','SW-CONS-MARKETING-TERMINAL',2,'B224-79-41-332-1114-2 Rev 7','2','medium'),
    ('BR-UNLOADING-PS','2"-WS-332-1420-6-A1A','SW-S2-HDR-1412','SW-CONS-UNLOADING-PS',2,'B224-79-41-332-1114-2 Rev 7','2','medium')
  ) AS x(segment_key,line_number,from_key,to_key,size_in,pid_doc,pid_sheet,confidence)
  JOIN public.network_nodes fn ON fn.system_id=v_system AND fn.node_key=x.from_key
  JOIN public.network_nodes tn ON tn.system_id=v_system AND tn.node_key=x.to_key
  ON CONFLICT (system_id,segment_key) DO UPDATE SET
    line_number=excluded.line_number,from_node_id=excluded.from_node_id,to_node_id=excluded.to_node_id,
    nominal_size_in=excluded.nominal_size_in,piping_class_code=excluded.piping_class_code,
    source_pid_document=excluded.source_pid_document,source_pid_sheet=excluded.source_pid_sheet,
    verification_status=excluded.verification_status,attributes=excluded.attributes;
END $$;

-- A view suitable for the first Smart P&ID network screen.
create or replace view public.service_water_network_edges as
select
  s.id,
  s.segment_key,
  s.line_number,
  s.nominal_size_in,
  s.piping_class_code,
  s.volume_m3,
  s.verification_status,
  s.source_pid_document,
  s.source_pid_sheet,
  fn.node_key as from_node_key,
  coalesce(fn.tag,fn.name) as from_object,
  fn.node_type as from_type,
  tn.node_key as to_node_key,
  coalesce(tn.tag,tn.name) as to_object,
  tn.node_type as to_type,
  s.attributes
from public.network_segments s
join public.piping_systems ps on ps.id=s.system_id and ps.code='SERVICE-WATER'
join public.network_nodes fn on fn.id=s.from_node_id
join public.network_nodes tn on tn.id=s.to_node_id;

grant select on public.service_water_network_edges to authenticated;

-- Trace by tag, node key or consumer name without first resolving UUIDs in the UI.
create or replace function public.trace_service_water_downstream(p_search text)
returns table(depth integer,node_id uuid,node_key text,node_type text,tag text,path uuid[])
language sql stable security invoker as $$
  select td.*
  from public.piping_systems ps
  join public.network_nodes n on n.system_id=ps.id
  cross join lateral public.trace_downstream(ps.id,n.id) td
  where ps.code='SERVICE-WATER'
    and (n.node_key ilike p_search or coalesce(n.tag,'') ilike p_search or coalesce(n.name,'') ilike p_search)
  order by td.depth,td.node_key;
$$;

create or replace function public.trace_service_water_upstream(p_search text)
returns table(depth integer,node_id uuid,node_key text,node_type text,tag text,path uuid[])
language sql stable security invoker as $$
  select tu.*
  from public.piping_systems ps
  join public.network_nodes n on n.system_id=ps.id
  cross join lateral public.trace_upstream(ps.id,n.id) tu
  where ps.code='SERVICE-WATER'
    and (n.node_key ilike p_search or coalesce(n.tag,'') ilike p_search or coalesce(n.name,'') ilike p_search)
  order by tu.depth,tu.node_key;
$$;

grant execute on function public.trace_service_water_downstream(text) to authenticated;
grant execute on function public.trace_service_water_upstream(text) to authenticated;
