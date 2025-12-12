<<<<<<< HEAD
-- ============================================================
-- Fix RLS Policies for Products Table
-- ============================================================
-- This script fixes the RLS policies to allow admins to insert products
-- Run this in Supabase SQL Editor

-- First, drop existing policies
DROP POLICY IF EXISTS "Only admins can insert products" ON public.products;
DROP POLICY IF EXISTS "Only admins can update products" ON public.products;
DROP POLICY IF EXISTS "Only admins can delete products" ON public.products;

-- Create a function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.users 
    WHERE id = auth.uid() 
    AND is_admin = TRUE
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- Recreate policies with better logic
CREATE POLICY "Only admins can insert products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

CREATE POLICY "Only admins can update products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

CREATE POLICY "Only admins can delete products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (public.is_admin());

-- ============================================================
-- Create trigger to auto-create user record on signup
-- ============================================================
-- This ensures that when a user signs up, a record is created in public.users

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, name, phone, profile_image, is_admin)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', ''),
    NEW.phone,
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'profile_image', NULL),
    CASE WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    name = COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', users.name),
    phone = COALESCE(NEW.phone, users.phone),
    profile_image = COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'profile_image', users.profile_image);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- Update existing user if needed
-- ============================================================
-- If you already have a user, run this to create their record:
-- INSERT INTO public.users (id, name, email, is_admin)
-- SELECT 
--   id,
--   COALESCE(raw_user_meta_data->>'name', raw_user_meta_data->>'full_name', email),
--   email,
--   CASE WHEN email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
-- FROM auth.users
-- WHERE id NOT IN (SELECT id FROM public.users)
-- ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- Verify admin user
-- ============================================================
-- Check if admin user exists and is set as admin:
-- SELECT u.id, u.email, pu.is_admin 
-- FROM auth.users u
-- LEFT JOIN public.users pu ON u.id = pu.id
-- WHERE u.email = 'aliabouali2005@gmail.com';

-- If admin is not set, run:
-- UPDATE public.users 
-- SET is_admin = TRUE 
-- WHERE id = (SELECT id FROM auth.users WHERE email = 'aliabouali2005@gmail.com');

=======
-- ============================================================
-- Fix RLS Policies for Products Table
-- ============================================================
-- This script fixes the RLS policies to allow admins to insert products
-- Run this in Supabase SQL Editor

-- First, drop existing policies
DROP POLICY IF EXISTS "Only admins can insert products" ON public.products;
DROP POLICY IF EXISTS "Only admins can update products" ON public.products;
DROP POLICY IF EXISTS "Only admins can delete products" ON public.products;

-- Create a function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.users 
    WHERE id = auth.uid() 
    AND is_admin = TRUE
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- Recreate policies with better logic
CREATE POLICY "Only admins can insert products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

CREATE POLICY "Only admins can update products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

CREATE POLICY "Only admins can delete products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (public.is_admin());

-- ============================================================
-- Create trigger to auto-create user record on signup
-- ============================================================
-- This ensures that when a user signs up, a record is created in public.users

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, name, phone, profile_image, is_admin)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', ''),
    NEW.phone,
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'profile_image', NULL),
    CASE WHEN NEW.email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    name = COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', users.name),
    phone = COALESCE(NEW.phone, users.phone),
    profile_image = COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'profile_image', users.profile_image);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- Update existing user if needed
-- ============================================================
-- If you already have a user, run this to create their record:
-- INSERT INTO public.users (id, name, email, is_admin)
-- SELECT 
--   id,
--   COALESCE(raw_user_meta_data->>'name', raw_user_meta_data->>'full_name', email),
--   email,
--   CASE WHEN email = 'aliabouali2005@gmail.com' THEN TRUE ELSE FALSE END
-- FROM auth.users
-- WHERE id NOT IN (SELECT id FROM public.users)
-- ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- Verify admin user
-- ============================================================
-- Check if admin user exists and is set as admin:
-- SELECT u.id, u.email, pu.is_admin 
-- FROM auth.users u
-- LEFT JOIN public.users pu ON u.id = pu.id
-- WHERE u.email = 'aliabouali2005@gmail.com';

-- If admin is not set, run:
-- UPDATE public.users 
-- SET is_admin = TRUE 
-- WHERE id = (SELECT id FROM auth.users WHERE email = 'aliabouali2005@gmail.com');

>>>>>>> 896380966d47b05a23f794163756ef8892357164
