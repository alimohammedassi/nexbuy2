# How to Add Categories Data to Supabase

Follow these steps to populate your Supabase `categories` table with the current app data.

## Method 1: Using Supabase SQL Editor (Recommended)

### Step 1: Open Supabase Dashboard

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in to your account
3. Select your NexBuy project

### Step 2: Open SQL Editor

1. Click on **SQL Editor** in the left sidebar
2. Click **New query**

### Step 3: Run the SQL Script

1. Copy the entire content from [`insert_categories_data.sql`](file:///c:/Users/mabou/Desktop/NexBuy/nexbuy/insert_categories_data.sql)
2. Paste it into the SQL Editor
3. Click **Run** (or press Ctrl+Enter)

### Step 4: Verify the Data

You should see a success message and the query results showing all 6 categories:

- smartphones
- laptops
- headphones
- watches
- tablets
- accessories

---

## Method 2: Using Table Editor (Manual Entry)

If you prefer to add categories one by one:

### Step 1: Open Table Editor

1. Go to **Table Editor** in Supabase dashboard
2. Select the **categories** table

### Step 2: Insert Each Category

Click **Insert row** and fill in the data for each category:

#### Category 1: Smartphones

```
id: smartphones
name_en: Smartphones
name_ar: الهواتف الذكية
image_url: images/cards_iphone/iPhone_17_Pro_in_cosmic_orange_finish_showing_part.jpg
description: Latest smartphones and mobile devices
```

#### Category 2: Laptops

```
id: laptops
name_en: Laptops
name_ar: أجهزة الكمبيوتر المحمولة
image_url: images/ASUS_Asus_ProArt_P16_H7606WI-ME139W_RyzenAI_9-HX37.jpg
description: Gaming and professional laptops
```

#### Category 3: Headphones

```
id: headphones
name_en: Headphones
name_ar: سماعات الرأس
image_url: images/card images.jpg
description: Wireless and wired headphones
```

#### Category 4: Watches

```
id: watches
name_en: Watches
name_ar: الساعات
image_url: images/card images.jpg
description: Smartwatches and fitness trackers
```

#### Category 5: Tablets

```
id: tablets
name_en: Tablets
name_ar: الأجهزة اللوحية
image_url: images/Apple_New_2025_MacBook_Air_MW0Y3_13-Inch_Display_A.jpg
description: Tablets and e-readers
```

#### Category 6: Accessories

```
id: accessories
name_en: Accessories
name_ar: الإكسسوارات
image_url: images/card images.jpg
description: Phone cases, chargers, and more
```

---

## Verify in Your App

After adding the categories to Supabase:

1. **Restart your app** (or hot restart)
2. The app will automatically fetch categories from Supabase
3. You should see all 6 categories with their images and details
4. Categories will display in both English and Arabic based on app language

---

## Updating Category Images

If you want to use Supabase Storage for images instead of local assets:

### Step 1: Upload Images to Supabase Storage

1. Go to **Storage** in Supabase dashboard
2. Create a bucket called `categories` (if it doesn't exist)
3. Make it **public**
4. Upload your category images

### Step 2: Update image_url

1. Click on the uploaded image
2. Copy the **public URL**
3. Update the category's `image_url` field with this URL

Example:

```sql
UPDATE public.categories
SET image_url = 'https://your-project.supabase.co/storage/v1/object/public/categories/smartphones.jpg'
WHERE id = 'smartphones';
```

---

## Troubleshooting

### Categories Not Showing in App

- ✅ Verify data exists: `SELECT * FROM public.categories;`
- ✅ Check RLS policies allow public read access
- ✅ Restart the app completely (not just hot reload)
- ✅ Check Flutter console for error messages

### Images Not Loading

- ✅ For local assets: Ensure images exist in `images/` folder
- ✅ For Supabase Storage: Ensure bucket is public
- ✅ Verify image URLs are correct

### Duplicate Key Error

If you get a duplicate key error, the categories already exist. Use this to update them:

```sql
UPDATE public.categories SET
  name_en = 'New Name',
  image_url = 'new/image/path.jpg'
WHERE id = 'category-id';
```

---

## Summary

✅ Use **SQL Editor** for quick bulk insert (Method 1)
✅ Use **Table Editor** for manual entry (Method 2)
✅ Images can be local assets or Supabase Storage URLs
✅ App automatically fetches categories on startup
✅ Changes in Supabase reflect immediately on app restart

The SQL script uses `ON CONFLICT DO UPDATE` so you can run it multiple times safely - it will update existing categories instead of creating duplicates.
