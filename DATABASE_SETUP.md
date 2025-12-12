<<<<<<< HEAD
# 📊 NexBuy Database Setup Guide

This guide will help you set up the complete database structure for your NexBuy app in Supabase.

## 🚀 Quick Start

### Step 1: Open Supabase SQL Editor

1. Go to your Supabase project dashboard
2. Click on **SQL Editor** in the left sidebar
3. Click **New Query**

### Step 2: Run the Migration

1. Copy the entire contents of `supabase_migration.sql`
2. Paste it into the SQL Editor
3. Click **Run** (or press `Ctrl+Enter` / `Cmd+Enter`)

### Step 3: Verify Tables

1. Go to **Table Editor** in the left sidebar
2. You should see these tables:
   - ✅ `users`
   - ✅ `addresses`
   - ✅ `categories`
   - ✅ `products`
   - ✅ `orders`
   - ✅ `order_items`
   - ✅ `cart_items`
   - ✅ `favorites`

---

## 📋 Database Schema Overview

### 1. **users** Table
Stores extended user information (name, phone, profile image, admin status)

**Columns:**
- `id` (UUID) - References `auth.users.id`
- `name` (TEXT)
- `phone` (TEXT)
- `profile_image` (TEXT)
- `is_admin` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only read/update their own data
- RLS (Row Level Security) enabled

---

### 2. **addresses** Table
Stores user shipping addresses

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `title` (TEXT) - e.g., "Home", "Work"
- `full_address` (TEXT)
- `latitude` (DOUBLE PRECISION)
- `longitude` (DOUBLE PRECISION)
- `city` (TEXT)
- `state` (TEXT)
- `zip_code` (TEXT)
- `country` (TEXT) - Default: "Egypt"
- `is_default` (BOOLEAN)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only manage their own addresses
- RLS enabled

---

### 3. **categories** Table
Stores product categories

**Columns:**
- `id` (TEXT) - Primary key (e.g., "smartphones", "laptops")
- `name_en` (TEXT) - English name
- `name_ar` (TEXT) - Arabic name
- `image_url` (TEXT)
- `description` (TEXT)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Everyone can read categories
- Only admins can modify
- RLS enabled

**Default Categories:**
- Smartphones / الهواتف الذكية
- Laptops / أجهزة الكمبيوتر المحمولة
- Headphones / سماعات الرأس
- Watches / الساعات
- Tablets / الأجهزة اللوحية
- Accessories / الإكسسوارات

---

### 4. **products** Table
Stores product information

**Columns:**
- `id` (TEXT) - Primary key
- `name` (TEXT)
- `description` (TEXT)
- `price` (DECIMAL) - e.g., 1299.99
- `rating` (DECIMAL) - Default: 4.5
- `image_path` (TEXT)
- `category` (TEXT) - References `categories.id`
- `is_favorite` (BOOLEAN)
- `features` (JSONB) - Array of strings
- `brand` (TEXT)
- `model` (TEXT)
- `specifications` (JSONB) - Object with key-value pairs
- `stock_quantity` (INTEGER) - Default: 0
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Everyone can read products
- Only admins can insert/update/delete
- RLS enabled

---

### 5. **orders** Table
Stores user orders

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `order_number` (TEXT) - Unique, e.g., "NEX-2024-001"
- `total_amount` (DECIMAL)
- `status` (TEXT) - One of: pending, confirmed, processing, shipped, delivered, cancelled, returned
- `shipping_address_id` (UUID) - References `addresses.id`
- `order_date` (TIMESTAMP)
- `delivery_date` (TIMESTAMP)
- `tracking_number` (TEXT)
- `payment_method` (TEXT)
- `payment_status` (TEXT) - Default: "pending"
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only read/manage their own orders
- RLS enabled

---

### 6. **order_items** Table
Stores items in each order

**Columns:**
- `id` (UUID) - Primary key
- `order_id` (UUID) - References `orders.id`
- `product_id` (TEXT) - References `products.id`
- `product_name` (TEXT) - Snapshot of product name at time of order
- `product_image` (TEXT) - Snapshot of product image
- `price` (DECIMAL) - Snapshot of price at time of order
- `quantity` (INTEGER) - Default: 1
- `created_at` (TIMESTAMP)

**Security:**
- Users can only read items from their own orders
- RLS enabled

---

### 7. **cart_items** Table
Stores items in user's shopping cart

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `product_id` (TEXT) - References `products.id`
- `quantity` (INTEGER) - Default: 1
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)
- **Unique constraint:** (user_id, product_id)

**Security:**
- Users can only manage their own cart items
- RLS enabled

---

### 8. **favorites** Table
Stores user's favorite products

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `product_id` (TEXT) - References `products.id`
- `created_at` (TIMESTAMP)
- **Unique constraint:** (user_id, product_id)

**Security:**
- Users can only manage their own favorites
- RLS enabled

---

## 🔒 Security (RLS Policies)

All tables have **Row Level Security (RLS)** enabled with the following policies:

### Users Table
- ✅ Users can read their own data
- ✅ Users can update their own data
- ✅ Users can insert their own data

### Addresses Table
- ✅ Users can read their own addresses
- ✅ Users can insert their own addresses
- ✅ Users can update their own addresses
- ✅ Users can delete their own addresses

### Categories Table
- ✅ Everyone can read categories
- ✅ Only admins can modify categories

### Products Table
- ✅ Everyone can read products
- ✅ Only admins can insert/update/delete products

### Orders Table
- ✅ Users can read their own orders
- ✅ Users can insert their own orders
- ✅ Users can update their own orders

### Order Items Table
- ✅ Users can read items from their own orders
- ✅ Users can insert items to their own orders

### Cart Items Table
- ✅ Users can read their own cart items
- ✅ Users can insert their own cart items
- ✅ Users can update their own cart items
- ✅ Users can delete their own cart items

### Favorites Table
- ✅ Users can read their own favorites
- ✅ Users can insert their own favorites
- ✅ Users can delete their own favorites

---

## 👤 Admin Setup

The admin user is automatically set when a user with email `aliabouali2005@gmail.com` signs up.

**To manually set admin:**
```sql
UPDATE public.users 
SET is_admin = TRUE 
WHERE id = (SELECT id FROM auth.users WHERE email = 'aliabouali2005@gmail.com');
```

---

## 📝 Example Queries

### Get all products
```sql
SELECT * FROM public.products ORDER BY created_at DESC;
```

### Get user's cart items with product details
```sql
SELECT 
  ci.*,
  p.name,
  p.image_path,
  p.price
FROM public.cart_items ci
JOIN public.products p ON ci.product_id = p.id
WHERE ci.user_id = auth.uid();
```

### Get user's orders with items
```sql
SELECT 
  o.*,
  json_agg(oi.*) as items
FROM public.orders o
LEFT JOIN public.order_items oi ON o.id = oi.order_id
WHERE o.user_id = auth.uid()
GROUP BY o.id;
```

---

## 🔧 Maintenance

### Update Product Stock
```sql
UPDATE public.products 
SET stock_quantity = stock_quantity - 1 
WHERE id = 'product-id';
```

### Get Low Stock Products
```sql
SELECT * FROM public.products 
WHERE stock_quantity < 10;
```

---

## ✅ Verification Checklist

After running the migration, verify:

- [ ] All 8 tables are created
- [ ] RLS is enabled on all tables
- [ ] Default categories are inserted
- [ ] Indexes are created
- [ ] Triggers are set up for `updated_at`
- [ ] Admin user can be set (if email matches)

---

## 🆘 Troubleshooting

### Error: "relation already exists"
- Some tables might already exist. The migration uses `CREATE TABLE IF NOT EXISTS`, so it's safe to run again.

### Error: "permission denied"
- Make sure you're running the migration as the database owner or with proper permissions.

### RLS Policies Not Working
- Check that RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
- Verify policies exist: Check in Supabase Dashboard → Authentication → Policies

---

## 📚 Next Steps

1. **Add Products**: Use the Admin Dashboard in your app
2. **Test Cart**: Add items to cart and verify they're saved
3. **Test Orders**: Create an order and verify it's saved
4. **Test Favorites**: Add products to favorites

---

## 🎉 You're All Set!

Your database is now ready to use. All tables are secured with RLS, and the structure supports all features of your NexBuy app!

=======
# 📊 NexBuy Database Setup Guide

This guide will help you set up the complete database structure for your NexBuy app in Supabase.

## 🚀 Quick Start

### Step 1: Open Supabase SQL Editor

1. Go to your Supabase project dashboard
2. Click on **SQL Editor** in the left sidebar
3. Click **New Query**

### Step 2: Run the Migration

1. Copy the entire contents of `supabase_migration.sql`
2. Paste it into the SQL Editor
3. Click **Run** (or press `Ctrl+Enter` / `Cmd+Enter`)

### Step 3: Verify Tables

1. Go to **Table Editor** in the left sidebar
2. You should see these tables:
   - ✅ `users`
   - ✅ `addresses`
   - ✅ `categories`
   - ✅ `products`
   - ✅ `orders`
   - ✅ `order_items`
   - ✅ `cart_items`
   - ✅ `favorites`

---

## 📋 Database Schema Overview

### 1. **users** Table
Stores extended user information (name, phone, profile image, admin status)

**Columns:**
- `id` (UUID) - References `auth.users.id`
- `name` (TEXT)
- `phone` (TEXT)
- `profile_image` (TEXT)
- `is_admin` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only read/update their own data
- RLS (Row Level Security) enabled

---

### 2. **addresses** Table
Stores user shipping addresses

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `title` (TEXT) - e.g., "Home", "Work"
- `full_address` (TEXT)
- `latitude` (DOUBLE PRECISION)
- `longitude` (DOUBLE PRECISION)
- `city` (TEXT)
- `state` (TEXT)
- `zip_code` (TEXT)
- `country` (TEXT) - Default: "Egypt"
- `is_default` (BOOLEAN)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only manage their own addresses
- RLS enabled

---

### 3. **categories** Table
Stores product categories

**Columns:**
- `id` (TEXT) - Primary key (e.g., "smartphones", "laptops")
- `name_en` (TEXT) - English name
- `name_ar` (TEXT) - Arabic name
- `image_url` (TEXT)
- `description` (TEXT)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Everyone can read categories
- Only admins can modify
- RLS enabled

**Default Categories:**
- Smartphones / الهواتف الذكية
- Laptops / أجهزة الكمبيوتر المحمولة
- Headphones / سماعات الرأس
- Watches / الساعات
- Tablets / الأجهزة اللوحية
- Accessories / الإكسسوارات

---

### 4. **products** Table
Stores product information

**Columns:**
- `id` (TEXT) - Primary key
- `name` (TEXT)
- `description` (TEXT)
- `price` (DECIMAL) - e.g., 1299.99
- `rating` (DECIMAL) - Default: 4.5
- `image_path` (TEXT)
- `category` (TEXT) - References `categories.id`
- `is_favorite` (BOOLEAN)
- `features` (JSONB) - Array of strings
- `brand` (TEXT)
- `model` (TEXT)
- `specifications` (JSONB) - Object with key-value pairs
- `stock_quantity` (INTEGER) - Default: 0
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Everyone can read products
- Only admins can insert/update/delete
- RLS enabled

---

### 5. **orders** Table
Stores user orders

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `order_number` (TEXT) - Unique, e.g., "NEX-2024-001"
- `total_amount` (DECIMAL)
- `status` (TEXT) - One of: pending, confirmed, processing, shipped, delivered, cancelled, returned
- `shipping_address_id` (UUID) - References `addresses.id`
- `order_date` (TIMESTAMP)
- `delivery_date` (TIMESTAMP)
- `tracking_number` (TEXT)
- `payment_method` (TEXT)
- `payment_status` (TEXT) - Default: "pending"
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Security:**
- Users can only read/manage their own orders
- RLS enabled

---

### 6. **order_items** Table
Stores items in each order

**Columns:**
- `id` (UUID) - Primary key
- `order_id` (UUID) - References `orders.id`
- `product_id` (TEXT) - References `products.id`
- `product_name` (TEXT) - Snapshot of product name at time of order
- `product_image` (TEXT) - Snapshot of product image
- `price` (DECIMAL) - Snapshot of price at time of order
- `quantity` (INTEGER) - Default: 1
- `created_at` (TIMESTAMP)

**Security:**
- Users can only read items from their own orders
- RLS enabled

---

### 7. **cart_items** Table
Stores items in user's shopping cart

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `product_id` (TEXT) - References `products.id`
- `quantity` (INTEGER) - Default: 1
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)
- **Unique constraint:** (user_id, product_id)

**Security:**
- Users can only manage their own cart items
- RLS enabled

---

### 8. **favorites** Table
Stores user's favorite products

**Columns:**
- `id` (UUID) - Primary key
- `user_id` (UUID) - References `users.id`
- `product_id` (TEXT) - References `products.id`
- `created_at` (TIMESTAMP)
- **Unique constraint:** (user_id, product_id)

**Security:**
- Users can only manage their own favorites
- RLS enabled

---

## 🔒 Security (RLS Policies)

All tables have **Row Level Security (RLS)** enabled with the following policies:

### Users Table
- ✅ Users can read their own data
- ✅ Users can update their own data
- ✅ Users can insert their own data

### Addresses Table
- ✅ Users can read their own addresses
- ✅ Users can insert their own addresses
- ✅ Users can update their own addresses
- ✅ Users can delete their own addresses

### Categories Table
- ✅ Everyone can read categories
- ✅ Only admins can modify categories

### Products Table
- ✅ Everyone can read products
- ✅ Only admins can insert/update/delete products

### Orders Table
- ✅ Users can read their own orders
- ✅ Users can insert their own orders
- ✅ Users can update their own orders

### Order Items Table
- ✅ Users can read items from their own orders
- ✅ Users can insert items to their own orders

### Cart Items Table
- ✅ Users can read their own cart items
- ✅ Users can insert their own cart items
- ✅ Users can update their own cart items
- ✅ Users can delete their own cart items

### Favorites Table
- ✅ Users can read their own favorites
- ✅ Users can insert their own favorites
- ✅ Users can delete their own favorites

---

## 👤 Admin Setup

The admin user is automatically set when a user with email `aliabouali2005@gmail.com` signs up.

**To manually set admin:**
```sql
UPDATE public.users 
SET is_admin = TRUE 
WHERE id = (SELECT id FROM auth.users WHERE email = 'aliabouali2005@gmail.com');
```

---

## 📝 Example Queries

### Get all products
```sql
SELECT * FROM public.products ORDER BY created_at DESC;
```

### Get user's cart items with product details
```sql
SELECT 
  ci.*,
  p.name,
  p.image_path,
  p.price
FROM public.cart_items ci
JOIN public.products p ON ci.product_id = p.id
WHERE ci.user_id = auth.uid();
```

### Get user's orders with items
```sql
SELECT 
  o.*,
  json_agg(oi.*) as items
FROM public.orders o
LEFT JOIN public.order_items oi ON o.id = oi.order_id
WHERE o.user_id = auth.uid()
GROUP BY o.id;
```

---

## 🔧 Maintenance

### Update Product Stock
```sql
UPDATE public.products 
SET stock_quantity = stock_quantity - 1 
WHERE id = 'product-id';
```

### Get Low Stock Products
```sql
SELECT * FROM public.products 
WHERE stock_quantity < 10;
```

---

## ✅ Verification Checklist

After running the migration, verify:

- [ ] All 8 tables are created
- [ ] RLS is enabled on all tables
- [ ] Default categories are inserted
- [ ] Indexes are created
- [ ] Triggers are set up for `updated_at`
- [ ] Admin user can be set (if email matches)

---

## 🆘 Troubleshooting

### Error: "relation already exists"
- Some tables might already exist. The migration uses `CREATE TABLE IF NOT EXISTS`, so it's safe to run again.

### Error: "permission denied"
- Make sure you're running the migration as the database owner or with proper permissions.

### RLS Policies Not Working
- Check that RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
- Verify policies exist: Check in Supabase Dashboard → Authentication → Policies

---

## 📚 Next Steps

1. **Add Products**: Use the Admin Dashboard in your app
2. **Test Cart**: Add items to cart and verify they're saved
3. **Test Orders**: Create an order and verify it's saved
4. **Test Favorites**: Add products to favorites

---

## 🎉 You're All Set!

Your database is now ready to use. All tables are secured with RLS, and the structure supports all features of your NexBuy app!

>>>>>>> 896380966d47b05a23f794163756ef8892357164
