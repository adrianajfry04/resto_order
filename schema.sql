-- Restaurant Waiter Order System - Supabase schema
-- Run this in Supabase Dashboard -> SQL Editor -> New query -> Run

-- Enable UUID generation (usually already on in Supabase)
create extension if not exists "uuid-ossp";

-- 1) menu_items
create table if not exists menu_items (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  price numeric(10,2) not null check (price >= 0),
  category text not null,
  available boolean not null default true
);

-- 2) orders
create table if not exists orders (
  id uuid primary key default uuid_generate_v4(),
  table_no integer not null check (table_no > 0),
  status text not null default 'Pending'
    check (status in ('Pending','Preparing','Served','Paid')),
  total numeric(10,2) not null default 0,
  created_at timestamptz not null default now()
);

-- 3) order_items (link table, snapshots the name/price at order time)
create table if not exists order_items (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  menu_item_id uuid references menu_items(id) on delete set null,
  name_snapshot text not null,
  price_snapshot numeric(10,2) not null,
  quantity integer not null check (quantity > 0)
);

-- ---------------------------------------------------------------
-- Row Level Security: the brief says "no login" and open policies
-- are fine for this test. We enable RLS (Supabase best practice)
-- but add fully-open policies so the app works with the anon key.
-- ---------------------------------------------------------------

alter table menu_items enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

create policy "public full access menu_items" on menu_items
  for all using (true) with check (true);

create policy "public full access orders" on orders
  for all using (true) with check (true);

create policy "public full access order_items" on order_items
  for all using (true) with check (true);

-- ---------------------------------------------------------------
-- Optional: seed a few menu items so the app isn't empty on first run
-- ---------------------------------------------------------------
insert into menu_items (name, price, category, available) values
  ('Teh Tarik', 2.50, 'Drink', true),
  ('Iced Lemon Tea', 3.00, 'Drink', true),
  ('Nasi Lemak', 8.50, 'Main', true),
  ('Mee Goreng', 7.00, 'Main', true),
  ('Roti Canai', 2.00, 'Main', true),
  ('Cendol', 4.50, 'Dessert', true);
