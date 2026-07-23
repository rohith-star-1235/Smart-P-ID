export type ObjectType = "pump" | "valve" | "line" | "header";

export type EngineeringObject = {
  id: string;
  tag: string;
  name: string;
  type: ObjectType;
  summary: string;
  designData: Record<string, string>;
  operatingData?: Record<string, string>;
  construction?: Record<string, string>;
  maintenance?: string[];
  source: string;
};

export const engineeringObjects: EngineeringObject[] = [
  {
    id: "pump-501-p-0105a",
    tag: "501-P-0105A",
    name: "Service Water Pump A",
    type: "pump",
    summary: "Horizontal end-suction, single-stage centrifugal pump for refinery and petrochemical service water.",
    designData: {
      Manufacturer: "Flowmore Limited",
      Model: "5624-100x65",
      Capacity: "100 m³/h",
      Head: "87.7 m",
      Efficiency: "73.5%",
      Speed: "2965 rpm",
      "Pump input": "32.23 kW",
      "Motor rating": "55 kW",
      NPSHr: "4.1 m",
      NPSHa: "7.3 m",
      "Suction pressure": "-0.2 / 0.6 kg/cm²g",
      "Discharge pressure": "8.5 kg/cm²g",
      MAWP: "13 kg/cm²g",
      "Suction nozzle": "100 NB, Class 150 RF",
      "Discharge nozzle": "65 NB, Class 150 RF"
    },
    operatingData: {
      "Actual flow": "Not entered",
      "Actual suction pressure": "Not entered",
      "Actual discharge pressure": "Not entered",
      "Motor current": "Not entered",
      "DE bearing temperature": "Not entered",
      "NDE bearing temperature": "Not entered",
      "DE vibration": "Not entered",
      "NDE vibration": "Not entered",
      "Running hours": "Not entered"
    },
    construction: {
      Casing: "ASTM A216 Gr. WCB",
      Impeller: "IS 318 Gr. LTB-II bronze",
      Shaft: "40C8 carbon steel",
      "Shaft sleeve": "AISI 410 / SS410 hardened",
      Bearings: "6310-C3 antifriction bearings",
      Coupling: "Fleximetallic spacer type",
      Baseplate: "IS 2062 fabricated steel",
      Rotation: "Counter-clockwise from driving end"
    },
    maintenance: [
      "Record suction and discharge pressures",
      "Check vibration, abnormal noise and bearing temperatures",
      "Check gland leakage and lubrication level",
      "Inspect coupling, alignment, foundation bolts and grout",
      "Inspect wear rings, shaft sleeve and impeller during overhaul",
      "Compare operating point with vendor performance curve"
    ],
    source: "Pump Datasheet DS-SALE21075166-40 Rev.00; GA Rev.03; CSD Rev.00"
  },
  {
    id: "valve-hv-p0105-d1",
    tag: "HV-P0105-D1",
    name: "Pump Discharge Isolation Valve",
    type: "valve",
    summary: "Sample A1A Class 150 gate valve connected to the pump discharge branch.",
    designData: {
      "Valve type": "Gate valve",
      Size: "3 in",
      Rating: "Class 150",
      "Piping class": "A1A",
      "VMS tag": "51301",
      Standard: "API 600 / ISO 10434",
      Ends: "Flanged, ASME B16.5 RF / 125 AARH",
      Operator: "Handwheel"
    },
    construction: {
      Body: "ASTM A216 Gr. WCB",
      Stem: "13% Cr steel",
      "Seat / trim": "13% Cr steel with stellited seating",
      Packing: "Flexible graphite",
      Bolting: "ASTM A193 B7 / A194 2H",
      Design: "OS&Y"
    },
    maintenance: [
      "Operate through full travel",
      "Inspect gland packing and stem leakage",
      "Check body-bonnet joint leakage",
      "Inspect handwheel and stem condition",
      "Check passing condition and seat tightness"
    ],
    source: "VMS B229-6-44-0006-8120 Rev.A; A1A PMS valve group"
  },
  {
    id: "line-p0105-discharge",
    tag: "3\"-WS-P0105-DISCH-A1A",
    name: "Pump Discharge Branch",
    type: "line",
    summary: "Illustrative Service Water discharge branch using A1A piping-class data.",
    designData: {
      Service: "Service Water",
      Size: "3 in",
      "Piping class": "A1A",
      Rating: "Class 150",
      "Base material": "Carbon steel",
      "Corrosion allowance": "1.5 mm",
      Pipe: "ASTM A106 Gr.B, STD, ASME B36.10",
      Fittings: "ASTM A234 WPB, BW, ASME B16.9",
      Flanges: "ASTM A105, Class 150 RF, ASME B16.5",
      Gasket: "SS316 + graphite spiral wound, ASME B16.20",
      Bolting: "ASTM A193 B7 / A194 2H"
    },
    maintenance: [
      "Inspect coating and external corrosion",
      "Check supports, vibration and leakage",
      "Inspect flange and gasket joints",
      "Verify drain and vent operability",
      "Review thickness history when available"
    ],
    source: "PMS B229-6-44-0005 Rev.1, Pipe Class A1A"
  },
  {
    id: "header-service-water",
    tag: "SERVICE WATER HEADER",
    name: "Service Water Distribution Header",
    type: "header",
    summary: "Common vector network object for connected Service Water consumers.",
    designData: {
      System: "Service Water",
      PIDs: "B224-79-41-332-1114-1/2 Rev.7",
      Status: "Pilot data model",
      "Connected pump": "501-P-0105A"
    },
    source: "Service Water P&IDs, Rev.7"
  }
];
