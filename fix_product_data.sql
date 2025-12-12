-- ============================================================
-- Fix Products Data - Add Missing Required Fields
-- ============================================================
-- Your products are missing fields that cause the app to crash
-- This script updates all products with required fields
-- ============================================================

-- Update Samsung ultra25
UPDATE public.products
SET 
  description = COALESCE(description, 'High-end smartphone with advanced features'),
  rating = COALESCE(rating, 4.5),
  image_path = COALESCE(image_path, 'images/phone/samsung.jpg'),
  brand = COALESCE(brand, 'Samsung'),
  model = COALESCE(model, 'Ultra25'),
  features = COALESCE(features, '["5G", "High Resolution Camera", "Long Battery Life"]'::jsonb),
  specifications = COALESCE(specifications, '{"RAM": "12GB", "Storage": "512GB", "Display": "6.8 inch"}'::jsonb),
  stock_quantity = COALESCE(stock_quantity, 50),
  is_favorite = COALESCE(is_favorite, false)
WHERE id = 'prod_1764544148056_1764544148056514';

-- Update iPhone17 pro max
UPDATE public.products
SET 
  description = COALESCE(description, 'Latest iPhone with Pro Max features'),
  rating = COALESCE(rating, 4.8),
  image_path = COALESCE(image_path, 'images/phone/_iPhone_17_Pro_Max_256_GB_Cosmic_Orange_5G_eSim_on.jpg'),
  brand = COALESCE(brand, 'Apple'),
  model = COALESCE(model, 'iPhone 17 Pro Max'),
  features = COALESCE(features, '["A18 Pro Chip", "Pro Camera System", "Titanium Design"]'::jsonb),
  specifications = COALESCE(specifications, '{"Storage": "512GB", "Display": "6.7 inch", "5G": "Yes"}'::jsonb),
  stock_quantity = COALESCE(stock_quantity, 30),
  is_favorite = COALESCE(is_favorite, false)
WHERE id = 'prod_1764545632705_1764545632705531';

-- Update MacBook (laptop)
UPDATE public.products
SET 
  description = COALESCE(description, 'Powerful laptop for professionals and creators'),
  rating = COALESCE(rating, 4.7),
  image_path = COALESCE(image_path, 'images/Apple_2023_Newest_MacBook_Pro_MR7J3_Laptop_M3_chip.jpg'),
  brand = COALESCE(brand, 'Apple'),
  model = COALESCE(model, 'MacBook Pro'),
  features = COALESCE(features, '["M3 Chip", "Retina Display", "All-day Battery"]'::jsonb),
  specifications = COALESCE(specifications, '{"RAM": "16GB", "Storage": "512GB", "Display": "14 inch"}'::jsonb),
  stock_quantity = COALESCE(stock_quantity, 20),
  is_favorite = COALESCE(is_favorite, false)
WHERE id = 'laptop';

-- Verify all products have required fields
SELECT 
  id,
  name,
  category,
  price,
  CASE WHEN description IS NULL THEN '❌ NULL' ELSE '✅' END as description,
  CASE WHEN brand IS NULL THEN '❌ NULL' ELSE '✅' END as brand,
  CASE WHEN model IS NULL THEN '❌ NULL' ELSE '✅' END as model,
  CASE WHEN image_path IS NULL THEN '❌ NULL' ELSE '✅' END as image_path,
  rating,
  stock_quantity
FROM public.products
ORDER BY id;

-- Final check - this should return all products with complete data
SELECT * FROM public.products;
