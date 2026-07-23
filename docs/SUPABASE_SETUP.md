# Supabase setup

## 1. Create the project

Create a Supabase project and keep the database password secure.

## 2. Run the migration

Open **SQL Editor** in Supabase and run:

`supabase/migrations/001_engineering_core.sql`

This creates:

- user profiles and roles
- engineering objects
- engineering relationships
- controlled documents
- object-to-document links
- object revision history
- maintenance records
- private `engineering-documents` storage bucket
- row-level security policies

## 3. Configure environment variables

Copy `.env.example` to `.env.local` and provide:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_APP_URL`

Never expose the service-role key to browser code.

## 4. Create the first user

Create a user through Supabase Authentication. Then insert the matching profile row:

```sql
insert into public.profiles (id, full_name, role)
values ('AUTH-USER-UUID', 'Administrator', 'admin');
```

## 5. Upload controlled documents

Upload approved PDFs into the private `engineering-documents` bucket. Use a predictable path:

```text
plant/unit/system/document-number/revision/file.pdf
```

Create a record in `public.documents`, then connect it through `public.object_documents`.

## 6. Vercel

Import `rohith-star-1235/Smart-P-ID` into Vercel and add the same environment variables under Project Settings → Environment Variables.

## Data-authority rule

- P&ID: connectivity and graphical navigation
- Pump vendor documents: pump engineering data
- PMS: pipeline, fitting, flange, gasket, bolting and branch data
- VMS: valve construction and specification
- Line list: line-specific design and operating conditions

Do not duplicate authoritative values across object records. Store the source reference and link the controlled document.
