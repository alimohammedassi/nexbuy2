-- Step 1: Create categories table
CREATE TABLE IF NOT EXISTS public.categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_name TEXT NOT NULL UNIQUE,
  icon_name TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Insert default categories
INSERT INTO public.categories (category_name, icon_name, display_order) VALUES
  ('Laptops', 'laptop_mac', 1),
  ('Smartphones', 'phone_android', 2),
  ('Tablets', 'tablet', 3),
  ('Accessories', 'headphones', 4),
  ('Gaming', 'sports_esports', 5),
  ('Audio', 'headset', 6)
ON CONFLICT (category_name) DO NOTHING;

-- Step 3: Add category column to products table if it doesn't exist
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

-- Step 4: Create index for faster category queries
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);

-- Step 5: Enable RLS on categories table
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Step 6: Allow everyone to read categories
DROP POLICY IF EXISTS "Allow public read access to categories" ON public.categories;
CREATE POLICY "Allow public read access to categories"
  ON public.categories FOR SELECT
  TO public
  USING (true);

-- Step 7: Allow authenticated users to manage categories (for admin)
DROP POLICY IF EXISTS "Allow authenticated users to manage categories" ON public.categories;
CREATE POLICY "Allow authenticated users to manage categories"
  ON public.categories FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);
