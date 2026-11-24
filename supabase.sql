-- Oído de Corneta: tabla de progreso y clasificación
-- Pegar en Supabase > SQL Editor > New query, y pulsar Run.

create table if not exists public.progress (
  user_id     uuid primary key default auth.uid() references auth.users on delete cascade,
  username    text not null,
  best_streak int  not null default 0,
  correct     int  not null default 0,
  answered    int  not null default 0,
  updated_at  timestamptz not null default now()
);

alter table public.progress enable row level security;

-- Cualquiera con sesión iniciada ve la clasificación
create policy "progress_select" on public.progress
  for select to authenticated using (true);

-- Cada uno solo crea y modifica su propia fila
create policy "progress_insert" on public.progress
  for insert to authenticated with check (auth.uid() = user_id);

create policy "progress_update" on public.progress
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
