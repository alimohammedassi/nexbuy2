# How to Add Products to NexBuy from Supabase

This guide explains how to add products to your NexBuy app using Supabase, ensuring they are properly stored in the database with correct categories.

## Table of Contents

1. [Database Schema Overview](#database-schema-overview)
2. [Adding Products via Admin Dashboard](#adding-products-via-admin-dashboard)
3. [Adding Products Directly in Supabase](#adding-products-directly-in-supabase)
4. [Product Image Upload](#product-image-upload)
5. [Categories Setup](#categories-setup)

---

## Database Schema Overview

### Products Table Structure

Your products are stored in the `public.products` table with the following fields:

| Field            | Type          | Description               | Required            |
| ---------------- | ------------- | ------------------------- | ------------------- |
| `id`             | TEXT          | Unique product identifier | ✅                  |
| `name`           | TEXT          | Product name              | ✅                  |
| `description`    | TEXT          | Product description       | ❌                  |
| `price`          | DECIMAL(10,2) | Product price             | ✅                  |
| `rating`         | DECIMAL(3,2)  | Product rating (0-5)      | ❌ (default: 4.5)   |
| `image_path`     | TEXT          | Product image URL/path    | ✅                  |
| `category`       | TEXT          | Category ID (foreign key) | ✅                  |
| `is_favorite`    | BOOLEAN       | Favorite flag             | ❌ (default: false) |
| `features`       | JSONB         | Array of features         | ❌ (default: [])    |
| `brand`          | TEXT          | Brand name                | ❌                  |
| `model`          | TEXT          | Model number              | ❌                  |
| `specifications` | JSONB         | Key-value specifications  | ❌ (default: {})    |
| `stock_quantity` | INTEGER       | Available stock           | ❌ (default: 0)     |
| `created_at`     | TIMESTAMP     | Creation timestamp        | Auto                |
| `updated_at`     | TIMESTAMP     | Last update timestamp     | Auto                |

### Categories Table Structure

Categories are stored in `public.categories`:

| Field         | Type | Description                       |
| ------------- | ---- | --------------------------------- |
| `id`          | TEXT | Category ID (e.g., 'smartphones') |
| `name_en`     | TEXT | English name                      |
| `name_ar`     | TEXT | Arabic name                       |
| `image_url`   | TEXT | Category image                    |
| `description` | TEXT | Category description              |

**Available Categories:**

- `smartphones` - Smartphones / الهواتف الذكية
- `laptops` - Laptops / أجهزة الكمبيوتر المحمولة
- `headphones` - Headphones / سماعات الرأس
- `watches` - Watches / الساعات
- `tablets` - Tablets / الأجهزة اللوحية
- `accessories` - Accessories / الإكسسوارات

---

## Adding Products via Admin Dashboard

### Step 1: Access Admin Dashboard

1. Sign in with your admin account (`aliabouali2005@gmail.com`)
2. Navigate to the Admin Dashboard from the app menu
3. You'll see two tabs: **Products** and **Add New**

### Step 2: Fill Product Information

Click on the **Add New** tab and fill in the following:

#### Basic Information

- **Product Name**: Enter the product name (e.g., "iPhone 15 Pro")
- **Description**: Detailed product description
- **Price**: Product price in dollars (e.g., 999.99)
- **Rating**: Rating from 0 to 5 (e.g., 4.5)

#### Product Details

- **Brand**: Manufacturer name (e.g., "Apple")
- **Model**: Model number (e.g., "A2848")
- **Category**: Select from dropdown (smartphones, laptops, etc.)
- **Stock Quantity**: Available units (e.g., 50)

#### Product Image

1. Click **"Pick Image"** button
2. Select an image from your device
3. The image will be automatically uploaded to Supabase Storage
4. The uploaded URL will be stored in the `image_path` field

#### Features (Optional)

Add product features one by one:

1. Type a feature (e.g., "6.7-inch display")
2. Click **"Add Feature"**
3. Repeat for all features

Example features:

```
- 6.7-inch Super Retina XDR display
- A17 Pro chip
- 48MP main camera
- Titanium design
```

#### Specifications (Optional)

Add technical specifications as key-value pairs:

1. Enter **Key** (e.g., "Display")
2. Enter **Value** (e.g., "6.7 inches")
3. Click **"Add Specification"**

Example specifications:

```json
{
  "Display": "6.7 inches",
  "Processor": "A17 Pro",
  "RAM": "8GB",
  "Storage": "256GB",
  "Camera": "48MP + 12MP + 12MP",
  "Battery": "4422 mAh"
}
```

### Step 3: Submit

1. Click the **"Add Product"** button
2. Wait for the success message
3. The product will appear in the **Products** tab
4. The product is now stored in Supabase and visible in the app

---

## Adding Products Directly in Supabase

You can also add products directly in the Supabase dashboard:

### Step 1: Open Supabase Dashboard

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in to your project
3. Navigate to **Table Editor** → **products**

### Step 2: Insert New Row

Click **"Insert row"** and fill in the data:

```sql
INSERT INTO public.products (
  id,
  name,
  description,
  price,
  rating,
  image_path,
  category,
  brand,
  model,
  features,
  specifications,
  stock_quantity
) VALUES (
  'iphone-15-pro-256gb',
  'iPhone 15 Pro 256GB',
  'The most advanced iPhone ever with titanium design',
  999.99,
  4.8,
  'https://your-supabase-url.supabase.co/storage/v1/object/public/products/iphone-15-pro.jpg',
  'smartphones',
  'Apple',
  'A2848',
  '["6.7-inch display", "A17 Pro chip", "48MP camera", "Titanium design"]'::jsonb,
  '{"Display": "6.7 inches", "Processor": "A17 Pro", "RAM": "8GB", "Storage": "256GB"}'::jsonb,
  50
);
```

### Important Notes:

- **ID**: Must be unique (use lowercase with hyphens)
- **Category**: Must match an existing category ID
- **Features**: Must be valid JSON array format
- **Specifications**: Must be valid JSON object format
- **Image Path**: Must be a valid URL or asset path

---

## Product Image Upload

### Option 1: Upload via Admin Dashboard (Recommended)

The admin dashboard automatically handles image uploads to Supabase Storage.

### Option 2: Manual Upload to Supabase Storage

1. Go to **Storage** in Supabase dashboard
2. Select the **products** bucket (or create it if it doesn't exist)
3. Upload your image
4. Click on the uploaded image and copy the public URL
5. Use this URL in the `image_path` field

### Option 3: Use Asset Images

Place images in your Flutter project's `images` folder and reference them:

```
images/product_name.png
```

---

## Categories Setup

### Viewing Categories

To see all available categories:

```sql
SELECT * FROM public.categories;
```

### Adding New Categories

If you need to add a new category:

```sql
INSERT INTO public.categories (id, name_en, name_ar, image_url, description)
VALUES (
  'cameras',
  'Cameras',
  'الكاميرات',
  'images/category_cameras.png',
  'Digital cameras and photography equipment'
);
```

---

## Product Visibility & Permissions

### Row Level Security (RLS)

- **Everyone** can view products (no authentication required)
- **Only admins** can add, update, or delete products
- Admin status is determined by the `is_admin` field in the `users` table

### Checking Admin Status

Your admin email is: `aliabouali2005@gmail.com`

To verify admin status in Supabase:

```sql
SELECT id, name, email, is_admin
FROM auth.users
JOIN public.users ON auth.users.id = public.users.id
WHERE email = 'aliabouali2005@gmail.com';
```

If `is_admin` is not `TRUE`, update it:

```sql
UPDATE public.users
SET is_admin = TRUE
WHERE id = (SELECT id FROM auth.users WHERE email = 'aliabouali2005@gmail.com');
```

---

## Troubleshooting

### Product Not Showing in App

1. **Check category**: Ensure the category ID exists in the `categories` table
2. **Verify RLS policies**: Make sure RLS policies allow reading products
3. **Refresh the app**: Pull to refresh on the home screen
4. **Check logs**: Look for errors in the Flutter console

### Image Not Loading

1. **Verify URL**: Make sure the image URL is accessible
2. **Check storage permissions**: Ensure the `products` bucket is public
3. **Use correct path**: For assets, use `images/filename.png` format
4. **For Supabase Storage**: Use the full public URL

### Permission Denied

1. **Verify admin status**: Check if your user has `is_admin = TRUE`
2. **Re-login**: Sign out and sign in again
3. **Check RLS policies**: Ensure admin policies are correctly set

---

## Example: Complete Product Entry

Here's a complete example of adding a product:

```json
{
  "id": "macbook-pro-16-m3",
  "name": "MacBook Pro 16\" M3 Max",
  "description": "The most powerful MacBook Pro ever with M3 Max chip, stunning Liquid Retina XDR display, and up to 22 hours of battery life.",
  "price": 2499.0,
  "rating": 4.9,
  "image_path": "https://your-supabase-url.supabase.co/storage/v1/object/public/products/macbook-pro-16.jpg",
  "category": "laptops",
  "brand": "Apple",
  "model": "MRW13",
  "features": [
    "16-inch Liquid Retina XDR display",
    "M3 Max chip with 16-core CPU",
    "40-core GPU",
    "48GB unified memory",
    "1TB SSD storage",
    "Up to 22 hours battery life"
  ],
  "specifications": {
    "Display": "16.2-inch Liquid Retina XDR",
    "Processor": "Apple M3 Max",
    "RAM": "48GB",
    "Storage": "1TB SSD",
    "Graphics": "40-core GPU",
    "Battery": "Up to 22 hours",
    "Weight": "2.16 kg",
    "Ports": "3x Thunderbolt 4, HDMI, SD card"
  },
  "stock_quantity": 25
}
```

---

## Summary

✅ **Admin Dashboard Method**: Best for non-technical users, handles image upload automatically
✅ **Supabase Direct Method**: Best for bulk imports or technical users
✅ **Categories**: Must exist before adding products
✅ **Images**: Can use Supabase Storage or local assets
✅ **Permissions**: Only admins can add/edit products
✅ **Data Format**: Features are arrays, specifications are objects

For questions or issues, check the troubleshooting section or review the database schema in `supabase_migration.sql`.
