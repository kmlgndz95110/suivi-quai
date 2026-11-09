-- Table pour la synchro en direct (Supabase > SQL Editor).
-- Ensuite renseigner SUPABASE_URL et SUPABASE_KEY (clé anon/publishable) dans index.html.
create table if not exists public.deliveries (
  id         text primary key,
  date       date not null,
  time       text not null,
  type       text not null default 'Camion',
  supplier   text not null,
  pallets    integer,
  dock       text not null default '',
  note       text not null default '',
  status     text not null default 'EN_ATTENTE' check (status in ('EN_ATTENTE','EN_COURS','DECHARGE')),
  started_at bigint,
  done_at    bigint,
  updated_at bigint not null default (extract(epoch from now()) * 1000)::bigint
);

create index if not exists deliveries_date_idx on public.deliveries (date);

alter table public.deliveries enable row level security;

-- Accès sans connexion (le site n'a pas de login) : toute personne ayant le lien peut lire/écrire.
create policy "quai_public_access" on public.deliveries
  for all to anon using (true) with check (true);

alter publication supabase_realtime add table public.deliveries;
