import Link from "next/link";
import { ArrowLeft, Download, ExternalLink, FileText } from "lucide-react";

interface DocumentPageProps {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ src?: string; title?: string; revision?: string }>;
}

export default async function DocumentPage({ params, searchParams }: DocumentPageProps) {
  const { id } = await params;
  const query = await searchParams;
  const source = query.src ? decodeURIComponent(query.src) : "";
  const title = query.title ? decodeURIComponent(query.title) : "Engineering Document";
  const revision = query.revision ? decodeURIComponent(query.revision) : "—";

  return (
    <main style={{ minHeight: "100vh", background: "#07111f", color: "#eef5ff" }}>
      <header style={{ height: 68, display: "flex", alignItems: "center", gap: 14, padding: "0 20px", borderBottom: "1px solid #29415e", background: "#0a1728" }}>
        <Link href="/" aria-label="Back to Smart P&ID" style={{ display: "grid", placeItems: "center", width: 40, height: 40, border: "1px solid #355676", borderRadius: 9 }}>
          <ArrowLeft size={18} />
        </Link>
        <FileText size={22} />
        <div style={{ minWidth: 0 }}>
          <strong style={{ display: "block", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{title}</strong>
          <span style={{ color: "#8ca9c8", fontSize: 12 }}>Document ID: {id} · Revision {revision}</span>
        </div>
        <div style={{ marginLeft: "auto", display: "flex", gap: 8 }}>
          {source ? (
            <>
              <a href={source} target="_blank" rel="noreferrer" style={buttonStyle}><ExternalLink size={16} /> Open</a>
              <a href={source} download style={buttonStyle}><Download size={16} /> Download</a>
            </>
          ) : null}
        </div>
      </header>

      <section style={{ height: "calc(100vh - 68px)", padding: 14 }}>
        {source ? (
          <iframe
            title={title}
            src={`${source}#toolbar=1&navpanes=1&view=FitH`}
            style={{ width: "100%", height: "100%", border: "1px solid #29415e", borderRadius: 12, background: "white" }}
          />
        ) : (
          <div style={{ height: "100%", display: "grid", placeItems: "center", border: "1px dashed #355676", borderRadius: 12, color: "#8ca9c8", textAlign: "center", padding: 30 }}>
            <div>
              <FileText size={44} style={{ marginBottom: 12 }} />
              <h1 style={{ color: "#eef5ff", margin: "0 0 8px" }}>Document not uploaded</h1>
              <p style={{ maxWidth: 520, lineHeight: 1.6, margin: 0 }}>
                This document record exists, but its Supabase Storage path has not been connected yet. Upload the approved PDF to the engineering-documents bucket and store its path in the documents table.
              </p>
            </div>
          </div>
        )}
      </section>
    </main>
  );
}

const buttonStyle = {
  display: "inline-flex",
  alignItems: "center",
  gap: 7,
  minHeight: 38,
  padding: "0 12px",
  border: "1px solid #355676",
  borderRadius: 8,
  color: "#eef5ff",
  textDecoration: "none",
  fontSize: 13,
} as const;
