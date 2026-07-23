"use client";

import { FormEvent, useState } from "react";
import { LogIn, ShieldCheck } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function signIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setLoading(true);
    setMessage("");

    try {
      const supabase = createClient();
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
      window.location.href = "/";
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Unable to sign in.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <main style={{ minHeight: "100vh", display: "grid", placeItems: "center", padding: 24, background: "radial-gradient(circle at top, #153b68, #07111f 55%)", color: "#eef5ff" }}>
      <section style={{ width: "100%", maxWidth: 430, padding: 32, border: "1px solid #294766", borderRadius: 20, background: "rgba(10, 25, 44, .94)", boxShadow: "0 30px 90px rgba(0,0,0,.35)" }}>
        <div style={{ width: 52, height: 52, display: "grid", placeItems: "center", borderRadius: 14, background: "#155eef", marginBottom: 22 }}>
          <ShieldCheck size={26} />
        </div>
        <p style={{ margin: 0, color: "#6fa8e5", fontSize: 12, fontWeight: 800, letterSpacing: ".14em" }}>ENGINEERING INTELLIGENCE PLATFORM</p>
        <h1 style={{ margin: "10px 0 8px", fontSize: 31 }}>Sign in to Smart P&amp;ID</h1>
        <p style={{ margin: "0 0 24px", color: "#9cb9d9", lineHeight: 1.6 }}>Access controlled engineering objects, source documents, revisions and maintenance records.</p>

        <form onSubmit={signIn} style={{ display: "grid", gap: 14 }}>
          <label style={labelStyle}>Email<input required type="email" value={email} onChange={(event) => setEmail(event.target.value)} style={inputStyle} /></label>
          <label style={labelStyle}>Password<input required type="password" value={password} onChange={(event) => setPassword(event.target.value)} style={inputStyle} /></label>
          {message ? <div style={{ padding: 11, borderRadius: 9, background: "#4a1720", color: "#ffbac2", fontSize: 13 }}>{message}</div> : null}
          <button disabled={loading} type="submit" style={{ minHeight: 46, border: 0, borderRadius: 10, background: "#155eef", color: "white", fontWeight: 800, display: "inline-flex", alignItems: "center", justifyContent: "center", gap: 9, cursor: "pointer" }}>
            <LogIn size={17} /> {loading ? "Signing in..." : "Sign in"}
          </button>
        </form>
      </section>
    </main>
  );
}

const labelStyle = { display: "grid", gap: 7, color: "#b8cce4", fontSize: 13, fontWeight: 700 } as const;
const inputStyle = { width: "100%", minHeight: 44, borderRadius: 9, border: "1px solid #355676", padding: "0 12px", background: "#081525", color: "white", outline: "none" } as const;
