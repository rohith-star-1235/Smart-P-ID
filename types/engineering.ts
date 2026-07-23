export type EngineeringObjectType =
  | "plant"
  | "unit"
  | "system"
  | "pid"
  | "equipment"
  | "line"
  | "valve"
  | "instrument"
  | "fitting"
  | "support";

export type DocumentType =
  | "pid"
  | "datasheet"
  | "general-arrangement"
  | "cross-section"
  | "performance-curve"
  | "pms"
  | "vms"
  | "manual"
  | "inspection-report"
  | "photograph"
  | "other";

export interface EngineeringObject {
  id: string;
  objectType: EngineeringObjectType;
  tag: string;
  name: string;
  description?: string;
  plantId?: string;
  unitId?: string;
  systemId?: string;
  pidId?: string;
  status: "active" | "inactive" | "standby" | "removed";
  attributes: Record<string, string | number | boolean | null>;
  createdAt: string;
  updatedAt: string;
}

export interface EngineeringRelationship {
  id: string;
  sourceObjectId: string;
  targetObjectId: string;
  relationshipType:
    | "connected-to"
    | "upstream-of"
    | "downstream-of"
    | "installed-on"
    | "document-for"
    | "part-of"
    | "isolated-by";
  metadata: Record<string, string | number | boolean | null>;
}

export interface EngineeringDocument {
  id: string;
  documentNumber: string;
  title: string;
  documentType: DocumentType;
  revision: string;
  status: "draft" | "approved" | "superseded" | "archived";
  storageBucket: string;
  storagePath: string;
  mimeType: string;
  pageCount?: number;
  issuedAt?: string;
  metadata: Record<string, string | number | boolean | null>;
}

export interface ObjectDocumentLink {
  objectId: string;
  documentId: string;
  relationship: "primary" | "reference" | "vendor" | "inspection" | "maintenance";
}
