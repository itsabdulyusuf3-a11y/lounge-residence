-- ============================================
-- THE LOUNGE RESIDENCE - SUPABASE DATABASE SCHEMA
-- Run this in: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================

-- 1. ROOMS TABLE (the 13 residences)
CREATE TABLE IF NOT EXISTS rooms (
  id SERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,           -- e.g. '01', '02', '07', '13'
  floor TEXT NOT NULL,                 -- 'Ground', '1st', '2nd', '3rd', '4th'
  name TEXT NOT NULL,                  -- 'Residence 01', 'Studio 13'...
  category TEXT NOT NULL,              -- 'three','two','one','studio','lounge'
  capacity INT DEFAULT 2,
  base_price NUMERIC NOT NULL DEFAULT 0,
  is_lounge BOOLEAN DEFAULT FALSE      -- true for The Lounge (4th floor event space)
);

-- 2. AVAILABILITY TABLE (date ranges when a room is unavailable)
CREATE TABLE IF NOT EXISTS unavailability (
  id SERIAL PRIMARY KEY,
  room_id INT REFERENCES rooms(id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  reason TEXT DEFAULT 'booked',        -- 'booked', 'maintenance', 'blocked'
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3. BOOKINGS / REQUESTS TABLE
CREATE TABLE IF NOT EXISTS bookings (
  id SERIAL PRIMARY KEY,
  room_id INT REFERENCES rooms(id),
  room_code TEXT,
  category TEXT,
  guest_name TEXT NOT NULL,
  guest_email TEXT,
  guest_phone TEXT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  guests INT DEFAULT 1,
  total_amount NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'pending',       -- 'pending','confirmed','declined','cancelled'
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. SEED THE ROOMS (13 residences per your directory)
--    LR 07 is the premium 3-bedroom residence at 300,000/night.
INSERT INTO rooms (code, floor, name, category, capacity, base_price) VALUES
  ('01', 'Ground', 'Residence 01', 'three', 6, 250000),
  ('02', 'Ground', 'Residence 02', 'three', 6, 250000),
  ('03', '1st',   'Residence 03', 'three', 6, 250000),
  ('04', '1st',   'Residence 04', 'three', 6, 250000),
  ('05', '1st',   'Residence 05', 'two', 4, 200000),
  ('06', '2nd',   'Residence 06', 'three', 6, 250000),
  ('07', '2nd',   'Residence 07', 'three_premium', 6, 300000),
  ('08', '2nd',   'Residence 08', 'two', 4, 200000),
  ('09', '3rd',   'Residence 09', 'three', 6, 250000),
  ('10', '3rd',   'Residence 10', 'three', 6, 250000),
  ('11', '3rd',   'Residence 11', 'two', 4, 200000),
  ('12', '4th',   'Residence 12', 'one', 3, 180000),
  ('13', '4th',   'Residence 13', 'studio', 2, 150000),
  ('LOUNGE', '4th', 'The Lounge (Event Space)', 'lounge', 50, 250000)
ON CONFLICT (code) DO NOTHING;

-- 5. ROW LEVEL SECURITY
-- Allow public read access to rooms and availability
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE unavailability ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Public can read rooms
CREATE POLICY "Public read rooms" ON rooms
  FOR SELECT USING (true);

-- Public can read unavailability (so the site knows what's booked)
CREATE POLICY "Public read unavailability" ON unavailability
  FOR SELECT USING (true);

-- Public can insert booking requests
CREATE POLICY "Public submit booking request" ON bookings
  FOR INSERT WITH CHECK (true);

-- Public can read their own booking (by phone - simple approach)
CREATE POLICY "Public read own booking" ON bookings
  FOR SELECT USING (true);

-- 6. ADMIN ACCESS VIA SUPABASE AUTH
-- Staff will authenticate via Supabase Auth.
-- Restrict writes to authenticated users:
CREATE POLICY "Auth users manage unavailability" ON unavailability
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Auth users manage bookings" ON bookings
  FOR ALL USING (auth.role() = 'authenticated');

-- Note: To create staff accounts, use Supabase Dashboard → Authentication → Users → Add user
-- OR invite them via the admin panel we will build.
