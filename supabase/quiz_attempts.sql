-- Supabase table for storing quiz results from the Grade 4 rounding website.
-- Run this in Supabase SQL Editor.
-- Security model:
-- - Public website visitors (anon role) can insert quiz attempts only.
-- - Public website visitors cannot read student names/scores.
-- - Authenticated users can read results for teacher/admin review.

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  attempt_id text not null unique,
  first_name text not null,
  last_name text not null,
  class_name text,
  student_number text,
  school_name text not null,
  score integer not null check (score >= 0),
  total integer not null check (total > 0),
  percent integer not null check (percent >= 0 and percent <= 100),
  stars integer not null check (stars >= 0 and stars <= 3),
  timed_out boolean not null default false,
  started_at timestamptz,
  finished_at timestamptz not null default now(),
  answers jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.quiz_attempts enable row level security;

grant usage on schema public to anon, authenticated;
grant insert on table public.quiz_attempts to anon;
grant select on table public.quiz_attempts to authenticated;

drop policy if exists "Allow public quiz result submissions" on public.quiz_attempts;
create policy "Allow public quiz result submissions"
on public.quiz_attempts
for insert
to anon
with check (
  attempt_id is not null
  and first_name is not null
  and last_name is not null
  and school_name is not null
  and score >= 0
  and total > 0
  and percent between 0 and 100
  and stars between 0 and 3
);

drop policy if exists "Allow authenticated teachers to read quiz results" on public.quiz_attempts;
create policy "Allow authenticated teachers to read quiz results"
on public.quiz_attempts
for select
to authenticated
using (true);

create index if not exists quiz_attempts_created_at_idx
on public.quiz_attempts (created_at desc);

create index if not exists quiz_attempts_school_class_idx
on public.quiz_attempts (school_name, class_name);
