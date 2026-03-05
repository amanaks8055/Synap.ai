-- supabase/migrations/20260304130000_secure_subscriptions.sql

-- 1. Enable RLS
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- 2. Drop existing permissive policies (if any)
DROP POLICY IF EXISTS "Users can manage their own subscriptions" ON subscriptions;

-- 3. Create READ-ONLY policy for users
CREATE POLICY "Users can view their own subscription status"
ON subscriptions FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- 4. Ensure NO direct INSERT/UPDATE from client
-- (Only Service Role Key via Edge Function can write)
REVOKE ALL ON subscriptions FROM anon, authenticated;
GRANT SELECT ON subscriptions TO authenticated;
