-- ============================================================
-- Insert Categories Data into Supabase
-- ============================================================
-- This SQL script populates the categories table with the
-- current categories from your NexBuy app
-- ============================================================

-- First, ensure the categories table exists
-- (This should already be created from supabase_migration.sql)

-- Insert all categories with their images and details
INSERT INTO public.categories (id, name_en, name_ar, image_url, description) VALUES
  (
    'smartphones',
    'Smartphones',
    'الهواتف الذكية',
    'images/cards_iphone/iPhone_17_Pro_in_cosmic_orange_finish_showing_part.jpg',
    'Latest smartphones and mobile devices'
  ),
  (
    'laptops',
    'Laptops',
    'أجهزة الكمبيوتر المحمولة',
    'images/ASUS_Asus_ProArt_P16_H7606WI-ME139W_RyzenAI_9-HX37.jpg',
    'Gaming and professional laptops'
  ),
  (
    'headphones',
    'Headphones',
    'سماعات الرأس',
    'images/card images.jpg',
    'Wireless and wired headphones'
  ),
  (
    'watches',
    'Watches',
    'الساعات',
    'images/card images.jpg',
    'Smartwatches and fitness trackers'
  ),
  (
    'tablets',
    'Tablets',
    'الأجهزة اللوحية',
    'images/Apple_New_2025_MacBook_Air_MW0Y3_13-Inch_Display_A.jpg',
    'Tablets and e-readers'
  ),
  (
    'accessories',
    'Accessories',
    'الإكسسوارات',
    'images/card images.jpg',
    'Phone cases, chargers, and more'
  )
ON CONFLICT (id) DO UPDATE SET
  name_en = EXCLUDED.name_en,
  name_ar = EXCLUDED.name_ar,
  image_url = EXCLUDED.image_url,
  description = EXCLUDED.description,
  updated_at = NOW();

-- Verify the data was inserted
SELECT * FROM public.categories ORDER BY id;
