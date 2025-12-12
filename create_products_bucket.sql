-- 1. Create the 'products' bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('products', 'products', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Enable Row Level Security (RLS)
-- (Storage objects table has RLS enabled by default, skipping explicit enable to avoid permission errors)
-- ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- 3. Create Policy: Allow Public Read Access
-- This allows anyone (including unauthenticated users) to view images
DROP POLICY IF EXISTS "Public Access Products" ON storage.objects;
CREATE POLICY "Public Access Products"
ON storage.objects FOR SELECT
USING ( bucket_id = 'products' );

-- 4. Create Policy: Allow Authenticated Uploads
-- This allows any logged-in user to upload images to the bucket
DROP POLICY IF EXISTS "Authenticated Upload Products" ON storage.objects;
CREATE POLICY "Authenticated Upload Products"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK ( bucket_id = 'products' );

-- 5. Create Policy: Allow Authenticated Updates
-- This allows logged-in users to update images
DROP POLICY IF EXISTS "Authenticated Update Products" ON storage.objects;
CREATE POLICY "Authenticated Update Products"
ON storage.objects FOR UPDATE
TO authenticated
USING ( bucket_id = 'products' );

-- 6. Create Policy: Allow Authenticated Deletes
-- This allows logged-in users to delete images
DROP POLICY IF EXISTS "Authenticated Delete Products" ON storage.objects;
CREATE POLICY "Authenticated Delete Products"
ON storage.objects FOR DELETE
TO authenticated
USING ( bucket_id = 'products' );
