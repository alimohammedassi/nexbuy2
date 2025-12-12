-- STEP 3: Run this to add category column to products and set up policies
-- Add category column to products table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public'
    AND table_name = 'products' 
    AND column_name = 'category'
  ) THEN
    ALTER TABLE public.products ADD COLUMN category TEXT DEFAULT 'Laptops';
  END IF;
END $$;

-- Create index for faster category queries
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);

-- Enable RLS on categories table
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read categories
DROP POLICY IF EXISTS "Allow public read access to categories" ON public.categories;
CREATE POLICY "Allow public read access to categories"
  ON public.categories FOR SELECT
  TO public
  USING (true);

-- Allow authenticated users to manage categories (for admin)
DROP POLICY IF EXISTS "Allow authenticated users to manage categories" ON public.categories;
CREATE POLICY "Allow authenticated users to manage categories"
  ON public.categories FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);
