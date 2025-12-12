<<<<<<< HEAD
-- ============================================================
-- Quick Fix: Drop all existing policies before recreating
-- ============================================================
-- Run this if you get "policy already exists" errors
-- Then run the main migration again

-- Drop all policies
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT schemaname, tablename, policyname 
              FROM pg_policies 
              WHERE schemaname = 'public') 
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
            r.policyname, r.schemaname, r.tablename);
    END LOOP;
END $$;

-- Drop all triggers
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT trigger_name, event_object_table, event_object_schema
              FROM information_schema.triggers 
              WHERE event_object_schema = 'public') 
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I', 
            r.trigger_name, r.event_object_schema, r.event_object_table);
    END LOOP;
END $$;

-- Now you can run the main migration again

=======
-- ============================================================
-- Quick Fix: Drop all existing policies before recreating
-- ============================================================
-- Run this if you get "policy already exists" errors
-- Then run the main migration again

-- Drop all policies
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT schemaname, tablename, policyname 
              FROM pg_policies 
              WHERE schemaname = 'public') 
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
            r.policyname, r.schemaname, r.tablename);
    END LOOP;
END $$;

-- Drop all triggers
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT trigger_name, event_object_table, event_object_schema
              FROM information_schema.triggers 
              WHERE event_object_schema = 'public') 
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I', 
            r.trigger_name, r.event_object_schema, r.event_object_table);
    END LOOP;
END $$;

-- Now you can run the main migration again

>>>>>>> 896380966d47b05a23f794163756ef8892357164
