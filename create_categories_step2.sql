-- STEP 2: Run this after step 1 succeeds
INSERT INTO public.categories (category_name, icon_name, display_order) VALUES
  ('Laptops', 'laptop_mac', 1),
  ('Smartphones', 'phone_android', 2),
  ('Tablets', 'tablet', 3),
  ('Accessories', 'headphones', 4),
  ('Gaming', 'sports_esports', 5),
  ('Audio', 'headset', 6)
ON CONFLICT (category_name) DO NOTHING;
