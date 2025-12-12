<<<<<<< HEAD
-- ============================================================
-- Complete Fix for RLS Policies - Run this in Supabase SQL Editor
-- ============================================================

-- Step 1: Drop all existing policies on products table
DROP POLICY IF EXISTS "Products are viewable by everyone" ON public.products;
DROP POLICY IF EXISTS "Only admins can insert products" ON public.products;
DROP POLICY IF EXISTS "Only admins can update products" ON public.products;
DROP POLICY IF EXISTS "Only admins can delete products" ON public.products;

-- Step 2: Create or replace the is_admin function with SECURITY DEFINER
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if user exists in public.users and is admin
  RETURN EXISTS (
    SELECT 1 
    FROM public.users 
    WHERE id = auth.uid() 
    AND is_admin = TRUE
  );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO anon;

-- Step 3: Recreate policies with the function
-- Everyone can read products
CREATE POLICY "Products are viewable by everyone"
  ON public.products
  FOR SELECT
  TO public
  USING (true);

-- Only admins can insert products
CREATE POLICY "Only admins can insert products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

-- Only admins can update products
CREATE POLICY "Only admins can update products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Only admins can delete products
CREATE POLICY "Only admins can delete products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (public.is_admin());

-- ============================================================
-- Step 4: Create trigger to auto-create user record
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, name, phone, profile_image, is_admin)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'name', 
      NEW.raw_user_meta_data->>'full_name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.phone,
    COALESCE(
      NEW.raw_user_meta_data->>'avatar_url', 
      NEW.raw_user_meta_data->>'profile_image',
      NULL
    ),
    CASE WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    name = COALESCE(
      NEW.raw_user_meta_data->>'name', 
      NEW.raw_user_meta_data->>'full_name',
      users.name
    ),
    phone = COALESCE(NEW.phone, users.phone),
    profile_image = COALESCE(
      NEW.raw_user_meta_data->>'avatar_url', 
      NEW.raw_user_meta_data->>'profile_image',
      users.profile_image
    ),
    is_admin = CASE 
      WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE 
      ELSE users.is_admin 
    END;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- Step 5: Ensure admin user exists and is set as admin
-- ============================================================
-- This will create/update the admin user record
DO $$
DECLARE
  admin_user_id UUID;
BEGIN
  -- Get admin user ID
  SELECT id INTO admin_user_id
  FROM auth.users
  WHERE email = 'aliabouali2005@gmail.com';
  
  -- If admin user exists, ensure they have a record in public.users
  IF admin_user_id IS NOT NULL THEN
    INSERT INTO public.users (id, name, is_admin)
    VALUES (
      admin_user_id,
      COALESCE(
        (SELECT raw_user_meta_data->>'name' FROM auth.users WHERE id = admin_user_id),
        (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = admin_user_id),
        'Admin User'
      ),
      TRUE
    )
    ON CONFLICT (id) 
    DO UPDATE SET 
      is_admin = TRUE,
      name = COALESCE(
        (SELECT raw_user_meta_data->>'name' FROM auth.users WHERE id = admin_user_id),
        (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = admin_user_id),
        public.users.name
      );
  END IF;
END $$;

-- ============================================================
-- Step 6: Verify the setup
-- ============================================================
-- Run this query to verify admin user:
-- SELECT 
--   u.id,
--   u.email,
--   pu.name,
--   pu.is_admin
-- FROM auth.users u
-- LEFT JOIN public.users pu ON u.id = pu.id
-- WHERE u.email = 'aliabouali2005@gmail.com';

-- ============================================================
-- Step 7: Test the function
-- ============================================================
-- To test if the function works, run this (while logged in as admin):
-- SELECT public.is_admin();

-- ============================================================
-- END OF FIX
-- ============================================================

=======
-- ============================================================
-- Complete Fix for RLS Policies - Run this in Supabase SQL Editor
-- ============================================================

-- Step 1: Drop all existing policies on products table
DROP POLICY IF EXISTS "Products are viewable by everyone" ON public.products;
DROP POLICY IF EXISTS "Only admins can insert products" ON public.products;
DROP POLICY IF EXISTS "Only admins can update products" ON public.products;
DROP POLICY IF EXISTS "Only admins can delete products" ON public.products;

-- Step 2: Create or replace the is_admin function with SECURITY DEFINER
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if user exists in public.users and is admin
  RETURN EXISTS (
    SELECT 1 
    FROM public.users 
    WHERE id = auth.uid() 
    AND is_admin = TRUE
  );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO anon;

-- Step 3: Recreate policies with the function
-- Everyone can read products
CREATE POLICY "Products are viewable by everyone"
  ON public.products
  FOR SELECT
  TO public
  USING (true);

-- Only admins can insert products
CREATE POLICY "Only admins can insert products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

-- Only admins can update products
CREATE POLICY "Only admins can update products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Only admins can delete products
CREATE POLICY "Only admins can delete products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (public.is_admin());

-- ============================================================
-- Step 4: Create trigger to auto-create user record
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, name, phone, profile_image, is_admin)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'name', 
      NEW.raw_user_meta_data->>'full_name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.phone,
    COALESCE(
      NEW.raw_user_meta_data->>'avatar_url', 
      NEW.raw_user_meta_data->>'profile_image',
      NULL
    ),
    CASE WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    name = COALESCE(
      NEW.raw_user_meta_data->>'name', 
      NEW.raw_user_meta_data->>'full_name',
      users.name
    ),
    phone = COALESCE(NEW.phone, users.phone),
    profile_image = COALESCE(
      NEW.raw_user_meta_data->>'avatar_url', 
      NEW.raw_user_meta_data->>'profile_image',
      users.profile_image
    ),
    is_admin = CASE 
      WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE 
      ELSE users.is_admin 
    END;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- Step 5: Ensure admin user exists and is set as admin
-- ============================================================
-- This will create/update the admin user record
DO $$
DECLARE
  admin_user_id UUID;
BEGIN
  -- Get admin user ID
  SELECT id INTO admin_user_id
  FROM auth.users
  WHERE email = 'aliabouali2005@gmail.com';
  
  -- If admin user exists, ensure they have a record in public.users
  IF admin_user_id IS NOT NULL THEN
    INSERT INTO public.users (id, name, is_admin)
    VALUES (
      admin_user_id,
      COALESCE(
        (SELECT raw_user_meta_data->>'name' FROM auth.users WHERE id = admin_user_id),
        (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = admin_user_id),
        'Admin User'
      ),
      TRUE
    )
    ON CONFLICT (id) 
    DO UPDATE SET 
      is_admin = TRUE,
      name = COALESCE(
        (SELECT raw_user_meta_data->>'name' FROM auth.users WHERE id = admin_user_id),
        (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = admin_user_id),
        public.users.name
      );
  END IF;
END $$;

-- ============================================================
-- Step 6: Verify the setup
-- ============================================================
-- Run this query to verify admin user:
-- SELECT 
--   u.id,
--   u.email,
--   pu.name,
--   pu.is_admin
-- FROM auth.users u
-- LEFT JOIN public.users pu ON u.id = pu.id
-- WHERE u.email = 'aliabouali2005@gmail.com';

-- ============================================================
-- Step 7: Test the function
-- ============================================================
-- To test if the function works, run this (while logged in as admin):
-- SELECT public.is_admin();

-- ============================================================
-- END OF FIX
-- ============================================================

>>>>>>> 896380966d47b05a23f794163756ef8892357164
