# Categories from Supabase - Implementation Guide

## Overview

The app now loads category images and details dynamically from Supabase instead of using hardcoded values.

## What Was Changed

### 1. New CategoryService (`lib/services/category_service.dart`)

- Fetches categories from Supabase `categories` table
- Provides reactive updates using `ChangeNotifier`
- Handles loading states and errors

### 2. Updated CategoryProvider (`lib/providers/category_provider.dart`)

- Now uses `CategoryService` to get dynamic data
- Maintains fallback hardcoded categories for offline/error scenarios
- Automatically switches between Supabase data and fallback

### 3. App Initialization (`lib/main.dart`)

- Categories are loaded from Supabase on app startup
- Happens after Supabase initialization

## How It Works

1. **App Starts**: `CategoryProvider.initialize()` is called in `main()`
2. **Fetch Data**: Categories are loaded from Supabase `categories` table
3. **Display**: All screens automatically use Supabase categories
4. **Fallback**: If Supabase fails, hardcoded categories are used

## Database Requirements

Your Supabase `categories` table must have:

- `id` (TEXT) - Category identifier
- `name_en` (TEXT) - English name
- `name_ar` (TEXT) - Arabic name
- `image_url` (TEXT) - Image URL or path
- `description` (TEXT) - Category description

## Usage in Code

Categories are accessed the same way as before:

```dart
// Get all categories
final categories = CategoryProvider.categories;

// Get featured categories
final featured = CategoryProvider.getFeaturedCategories();

// Get by ID
final category = CategoryProvider.getCategoryById('smartphones');

// Search
final results = CategoryProvider.searchCategories('phone');
```

## Adding/Updating Categories

### Via Supabase Dashboard

1. Go to Supabase → Table Editor → `categories`
2. Add/edit rows with required fields
3. App will automatically fetch updates on next launch

### Example SQL

```sql
INSERT INTO public.categories (id, name_en, name_ar, image_url, description)
VALUES (
  'cameras',
  'Cameras',
  'الكاميرات',
  'https://your-url.com/camera.jpg',
  'Digital cameras and accessories'
);
```

## Benefits

✅ Categories managed from Supabase dashboard
✅ No app updates needed to change categories
✅ Images can be Supabase Storage URLs or asset paths
✅ Automatic fallback if Supabase is unavailable
✅ Bilingual support (English/Arabic)
