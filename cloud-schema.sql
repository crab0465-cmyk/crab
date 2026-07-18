-- Supabase SQL for Crab bless you cloud accounts.
-- Run this in Supabase SQL Editor, then set SUPABASE_URL and SUPABASE_ANON_KEY in index.html.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.diary_entries (
  user_id uuid not null references auth.users(id) on delete cascade,
  id bigint not null,
  date text not null default '',
  text text not null default '',
  photos jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.favorite_wishes (
  user_id uuid not null references auth.users(id) on delete cascade,
  id bigint not null,
  name text not null default '',
  tone text not null default '',
  wish text not null default '',
  tags jsonb not null default '[]'::jsonb,
  date text not null default '',
  season text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.profiles enable row level security;
alter table public.diary_entries enable row level security;
alter table public.favorite_wishes enable row level security;

drop policy if exists "profiles select own" on public.profiles;
drop policy if exists "profiles insert own" on public.profiles;
drop policy if exists "profiles update own" on public.profiles;
drop policy if exists "diary select own" on public.diary_entries;
drop policy if exists "diary insert own" on public.diary_entries;
drop policy if exists "diary update own" on public.diary_entries;
drop policy if exists "diary delete own" on public.diary_entries;
drop policy if exists "favorites select own" on public.favorite_wishes;
drop policy if exists "favorites insert own" on public.favorite_wishes;
drop policy if exists "favorites update own" on public.favorite_wishes;
drop policy if exists "favorites delete own" on public.favorite_wishes;

create policy "profiles select own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles insert own" on public.profiles
  for insert with check (auth.uid() = id);
create policy "profiles update own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

create policy "diary select own" on public.diary_entries
  for select using (auth.uid() = user_id);
create policy "diary insert own" on public.diary_entries
  for insert with check (auth.uid() = user_id);
create policy "diary update own" on public.diary_entries
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "diary delete own" on public.diary_entries
  for delete using (auth.uid() = user_id);

create policy "favorites select own" on public.favorite_wishes
  for select using (auth.uid() = user_id);
create policy "favorites insert own" on public.favorite_wishes
  for insert with check (auth.uid() = user_id);
create policy "favorites update own" on public.favorite_wishes
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "favorites delete own" on public.favorite_wishes
  for delete using (auth.uid() = user_id);
