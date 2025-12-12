-- ============================================================
-- Fix Products Table - Add Missing Columns
-- ============================================================
-- This script adds the missing columns to your products table
-- Run this in Supabase SQL Editor
-- ============================================================

-- Add category column (required, references categories table)
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS category TEXT;

-- Add brand column
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS brand TEXT DEFAULT 'Unknown';

-- Add model column
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS model TEXT DEFAULT '';

-- Add features column (JSONB array)
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS features JSONB DEFAULT '[]'::jsonb;

-- Add specifications column (JSONB object)
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS specifications JSONB DEFAULT '{}'::jsonb;

-- Add stock_quantity column
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 0;

-- Add is_favorite column
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN DEFAULT FALSE;

-- Add created_at and updated_at if missing
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Add foreign key constraint for category (after adding the column)
-- First, update existing products to have a valid category
UPDATE public.products 
SET category = 'smartphones' 
WHERE category IS NULL;

-- Now add the foreign key constraint
ALTER TABLE public.products
DROP CONSTRAINT IF EXISTS products_category_fkey;

ALTER TABLE public.products
ADD CONSTRAINT products_category_fkey 
FOREIGN KEY (category) REFERENCES public.categories(id);

-- Verify the changes
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'products' AND table_schema = 'public'
ORDER BY ordinal_position;

-- Show current products
SELECT id, name, category, brand, price, stock_quantity 
FROM public.products;
