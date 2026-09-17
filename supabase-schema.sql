-- PARC ENTREPRISE : schéma Supabase
-- À exécuter dans SQL Editor de Supabase.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nom text not null,
  email text,
  role text not null default 'commercial' check (role in ('admin','commercial')),
  permissions jsonb not null default '{"reserver":true,"annulerPropre":true}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.equipements (
  id uuid primary key default gen_random_uuid(),
  nom text not null,
  categorie text not null default 'Tracteur',
  reference text,
  notes text,
  statut_manuel text check (statut_manuel in ('maintenance','indisponible') or statut_manuel is null),
  maintenance jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reservations (
  id uuid primary key default gen_random_uuid(),
  equipement_id uuid not null references public.equipements(id) on delete cascade,
  date_debut date not null,
  date_fin date not null,
  client text not null,
  adresse text,
  cree_par text,
  created_at timestamptz not null default now(),
  constraint reservations_dates_valides check (date_fin >= date_debut)
);

create index if not exists reservations_equipement_idx on public.reservations(equipement_id);
create index if not exists reservations_dates_idx on public.reservations(date_debut, date_fin);

alter table public.profiles enable row level security;
alter table public.equipements enable row level security;
alter table public.reservations enable row level security;

-- Helpers
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'); $$;

-- Profiles: users can read their own profile; admins can read/manage profiles.
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_admin_all on public.profiles;
create policy profiles_admin_all on public.profiles for all using (public.is_admin()) with check (public.is_admin());

-- Equipment: authenticated users can read; only admins can create/delete/change protected fields.
drop policy if exists equip_select on public.equipements;
create policy equip_select on public.equipements for select to authenticated using (true);

drop policy if exists equip_insert on public.equipements;
create policy equip_insert on public.equipements for insert to authenticated with check (public.is_admin());

drop policy if exists equip_update on public.equipements;
create policy equip_update on public.equipements for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists equip_delete on public.equipements;
create policy equip_delete on public.equipements for delete to authenticated using (public.is_admin());

-- Reservations: authenticated users can read/create; cancellation is restricted by application role
-- and should be hardened further with an RPC if strict server-side enforcement is required.
drop policy if exists resa_select on public.reservations;
create policy resa_select on public.reservations for select to authenticated using (true);

drop policy if exists resa_insert on public.reservations;
create policy resa_insert on public.reservations for insert to authenticated with check (true);

drop policy if exists resa_delete on public.reservations;
create policy resa_delete on public.reservations for delete to authenticated using (true);

-- Administrateurs ALEXANDRE SA
-- Comptes prévus : Baptiste et Judicael.
-- Pour chacun :
-- 1) Créez l'utilisateur dans Supabase > Authentication > Users.
-- 2) Récupérez son UUID.
-- 3) Exécutez, en remplaçant les valeurs :
-- insert into public.profiles(id, nom, email, role)
-- values ('UUID_SUPABASE', 'Baptiste', 'email@alexandre-sa.com', 'admin');
--
-- Exemple pour Judicael :
-- insert into public.profiles(id, nom, email, role)
-- values ('UUID_SUPABASE', 'Judicael', 'email@alexandre-sa.com', 'admin');
--
-- First admin:
-- 1) Create the first user in Supabase Authentication > Users.
-- 2) Replace USER_UUID below and run:
-- insert into public.profiles(id, nom, email, role) values ('USER_UUID', 'Administrateur', 'email@entreprise.fr', 'admin');
