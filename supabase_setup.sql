-- Run in Supabase Dashboard > SQL Editor
create table if not exists public.uniplan_data (
 user_id uuid primary key references auth.users(id) on delete cascade,
 payload jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);
alter table public.uniplan_data enable row level security;
drop policy if exists "Users can read own UniPlan data" on public.uniplan_data;
create policy "Users can read own UniPlan data" on public.uniplan_data for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can insert own UniPlan data" on public.uniplan_data;
create policy "Users can insert own UniPlan data" on public.uniplan_data for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update own UniPlan data" on public.uniplan_data;
create policy "Users can update own UniPlan data" on public.uniplan_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
grant select, insert, update on public.uniplan_data to authenticated;
