import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Smart P&ID",
  description: "Engineering intelligence for connected P&ID objects"
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
