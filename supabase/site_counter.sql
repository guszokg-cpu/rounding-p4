-- Real visitor counter for the Grade 4 rounding website.
-- Run this once in Supabase SQL Editor.
-- Starts at 0, then increments once per browser session from the website.

create table if not exists public.site_counters (
  counter_key text primary key,
  count_value bigint not null default 0 check (count_value >= 0),
  updated_at timestamptz not null default now()
);

insert into public.site_counters (counter_key, count_value)
values ('visitors', 0)
on conflict (counter_key) do nothing;

alter table public.site_counters enable row level security;

revoke all on table public.site_counters from anon, authenticated;

create or replace function public.increment_site_visit()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  new_count bigint;
begin
  update public.site_counters
  set count_value = count_value + 1,
      updated_at = now()
  where counter_key = 'visitors'
  returning count_value into new_count;

  if new_count is null then
    insert into public.site_counters (counter_key, count_value)
    values ('visitors', 1)
    returning count_value into new_count;
  end if;

  return new_count;
end;
$$;

create or replace function public.get_site_visit_count()
returns bigint
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select count_value from public.site_counters where counter_key = 'visitors'),
    0
  );
$$;

revoke all on function public.increment_site_visit() from public;
revoke all on function public.get_site_visit_count() from public;
grant execute on function public.increment_site_visit() to anon;
grant execute on function public.get_site_visit_count() to anon;
