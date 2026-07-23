"use client";

import { useMemo, useState } from "react";
import { Activity, Box, CircleGauge, FileText, Search, Settings2, Wrench } from "lucide-react";
import { engineeringObjects, EngineeringObject } from "@/lib/service-water-data";

const tabs = ["Overview", "Engineering", "Operating", "Construction", "Maintenance", "Documents"] as const;
type Tab = (typeof tabs)[number];

function DataGrid({ data }: { data?: Record<string, string> }) {
  if (!data) return <p className="empty-state">No data available for this object.</p>;
  return (
    <div className="data-grid">
      {Object.entries(data).map(([label, value]) => (
        <div className="data-row" key={label}>
          <span>{label}</span>
          <strong>{value}</strong>
        </div>
      ))}
    </div>
  );
}

function DetailPanel({ object }: { object: EngineeringObject }) {
  const [tab, setTab] = useState<Tab>("Overview");
  return (
    <aside className="detail-panel">
      <div className="object-kicker">{object.type}</div>
      <h2>{object.tag}</h2>
      <p className="object-name">{object.name}</p>
      <div className="tab-strip">
        {tabs.map((item) => (
          <button className={tab === item ? "active" : ""} key={item} onClick={() => setTab(item)}>{item}</button>
        ))}
      </div>
      <div className="detail-scroll">
        {tab === "Overview" && <><section className="info-card"><h3>Object summary</h3><p>{object.summary}</p></section><section className="source-card"><span>Authoritative source</span><strong>{object.source}</strong></section></>}
        {tab === "Engineering" && <section className="info-card"><h3>Design and specification data</h3><DataGrid data={object.designData} /></section>}
        {tab === "Operating" && <section className="info-card"><h3>Operating values</h3><DataGrid data={object.operatingData} /></section>}
        {tab === "Construction" && <section className="info-card"><h3>Construction and materials</h3><DataGrid data={object.construction} /></section>}
        {tab === "Maintenance" && <section className="info-card"><h3>Maintenance essentials</h3><ul className="maintenance-list">{(object.maintenance ?? ["No maintenance checklist mapped yet."]).map((item) => <li key={item}>{item}</li>)}</ul></section>}
        {tab === "Documents" && <section className="info-card"><h3>Linked documents</h3><div className="document-list"><button><FileText size={17}/> Datasheet <span>Pending cloud upload</span></button><button><FileText size={17}/> P&ID source <span>Pending cloud upload</span></button><button><FileText size={17}/> Specification <span>Pending cloud upload</span></button></div></section>}
      </div>
    </aside>
  );
}

export function SmartPidWorkspace() {
  const [selectedId, setSelectedId] = useState(engineeringObjects[0].id);
  const [query, setQuery] = useState("");
  const selected = engineeringObjects.find((item) => item.id === selectedId) ?? engineeringObjects[0];
  const filtered = useMemo(() => engineeringObjects.filter((item) => `${item.tag} ${item.name} ${item.type}`.toLowerCase().includes(query.toLowerCase())), [query]);

  return (
    <div className="application-shell">
      <aside className="navigation-panel">
        <div className="brand-block"><div className="brand-icon">SP</div><div><strong>Smart P&ID</strong><span>Engineering Intelligence</span></div></div>
        <div className="system-card"><span>Plant / Unit</span><strong>HRRL · Raw Water Treatment</strong><small>Service Water Network</small></div>
        <label className="object-search"><Search size={16}/><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search tag or object"/></label>
        <div className="nav-label">Engineering objects</div>
        <div className="object-list">
          {filtered.map((item) => <button key={item.id} onClick={() => setSelectedId(item.id)} className={selectedId === item.id ? "selected" : ""}><span className={`type-dot ${item.type}`}/><div><strong>{item.tag}</strong><small>{item.name}</small></div></button>)}
        </div>
        <div className="nav-footer"><button><Settings2 size={16}/> Administration</button><span>App foundation v0.1</span></div>
      </aside>

      <main className="workspace">
        <header className="workspace-header"><div><span className="eyebrow">Interactive network</span><h1>Service Water Smart P&ID</h1></div><div className="header-actions"><button><Activity size={17}/> Trace flow</button><button><Box size={17}/> Object register</button></div></header>
        <section className="canvas-card">
          <div className="canvas-toolbar"><button>Fit network</button><button>Show labels</button><span>Vector engineering view</span></div>
          <svg viewBox="0 0 1050 610" role="img" aria-label="Service Water vector network">
            <defs><marker id="arrow" markerWidth="9" markerHeight="9" refX="8" refY="4.5" orient="auto"><path d="M0,0 L9,4.5 L0,9 Z" fill="#57718f"/></marker></defs>
            <rect width="1050" height="610" fill="#fbfdff"/>
            <text x="45" y="48" className="svg-title">SERVICE WATER PUMP & DISTRIBUTION — CONNECTED OBJECT VIEW</text>
            <text x="45" y="73" className="svg-subtitle">Source-based engineering data linked to each vector object</text>
            <g className={`svg-object ${selectedId === "header-service-water" ? "active" : ""}`} onClick={() => setSelectedId("header-service-water")}>
              <rect x="45" y="245" width="185" height="86" rx="9"/><text x="137" y="278">SERVICE WATER</text><text x="137" y="302">SUCTION HEADER</text>
            </g>
            <path d="M230 288 H430" className="pipeline" markerEnd="url(#arrow)"/>
            <g className={`valve-symbol svg-object ${selectedId === "valve-hv-p0105-d1" ? "active" : ""}`} onClick={() => setSelectedId("valve-hv-p0105-d1")}><polygon points="305,268 330,288 305,308"/><polygon points="355,268 330,288 355,308"/><line x1="330" y1="268" x2="330" y2="242"/><circle cx="330" cy="231" r="10"/></g>
            <g className={`pump-symbol svg-object ${selectedId === "pump-501-p-0105a" ? "active" : ""}`} onClick={() => setSelectedId("pump-501-p-0105a")}><circle cx="520" cy="288" r="74"/><path d="M472 288 Q520 218 582 288 Q520 358 472 288 Z"/><circle cx="520" cy="288" r="12" className="filled"/><rect x="595" y="248" width="135" height="80" rx="8"/><line x1="582" y1="288" x2="595" y2="288"/><text x="520" y="392">501-P-0105A</text><text x="662" y="282">ABB MOTOR</text><text x="662" y="305" className="small">55 kW · 2965 rpm</text></g>
            <path d="M520 214 V130 H850" className={`pipeline clickable ${selectedId === "line-p0105-discharge" ? "active" : ""}`} markerEnd="url(#arrow)" onClick={() => setSelectedId("line-p0105-discharge")}/>
            <text x="585" y="111" className="line-label">3&quot;-WS-P0105-DISCH-A1A</text>
            <g className={`valve-symbol svg-object ${selectedId === "valve-hv-p0105-d1" ? "active" : ""}`} transform="translate(665 -158)" onClick={() => setSelectedId("valve-hv-p0105-d1")}><polygon points="0,268 25,288 0,308"/><polygon points="50,268 25,288 50,308"/><line x1="25" y1="268" x2="25" y2="242"/><circle cx="25" cy="231" r="10"/></g>
            <g className={`svg-object ${selectedId === "header-service-water" ? "active" : ""}`} onClick={() => setSelectedId("header-service-water")}><rect x="850" y="88" width="160" height="84" rx="9"/><text x="930" y="121">DISTRIBUTION</text><text x="930" y="145">HEADER</text></g>
            <g className="metric-panel"><rect x="78" y="455" width="895" height="105" rx="12"/><text x="105" y="486" className="metric-title">PUMP DESIGN SNAPSHOT</text><text x="105" y="525">100 m³/h</text><text x="255" y="525">87.7 m head</text><text x="430" y="525">73.5% efficiency</text><text x="625" y="525">4.1 m NPSHr</text><text x="790" y="525">55 kW motor</text></g>
          </svg>
        </section>
      </main>
      <DetailPanel object={selected}/>
    </div>
  );
}
