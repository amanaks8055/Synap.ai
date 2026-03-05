// supabase/functions/verify-purchase/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0"

const GOOGLE_PLAY_API_URL = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications"

serve(async (req) => {
    const { productId, purchaseToken, package_name } = await req.json()

    // 1. Get Google Play Access Token (requires service account credentials)
    // Use env vars for security: GOOGLE_SERVICE_ACCOUNT_EMAIL, GOOGLE_PRIVATE_KEY
    const accessToken = await getGoogleAccessToken()

    // 2. Verify with Google Play Developer API
    const verifyUrl = `${GOOGLE_PLAY_API_URL}/${package_name}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`
    const response = await fetch(verifyUrl, {
        headers: { Authorization: `Bearer ${accessToken}` },
    })

    const purchaseData = await response.json()

    if (purchaseData.paymentState !== 1) { // 1 = Received
        return new Response(JSON.stringify({ error: "Invalid payment state" }), { status: 400 })
    }

    // 3. Update Supabase Database (Internal call via Service Role Key)
    const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data, error } = await supabase.from('subscriptions').upsert({
        user_id: req.headers.get('x-user-id'), // Provided by Supabase Auth
        product_id: productId,
        status: 'active',
        purchase_token: purchaseToken,
        updated_at: new Date().toISOString(),
    })

    return new Response(JSON.stringify({ success: true, data }), { status: 200 })
})

async function getGoogleAccessToken() {
    // Implementation for OAuth2 service account token fetching
    // In production, use 'google_auth' or similar Deno module
    return Deno.env.get('GOOGLE_PLAY_ACCESS_TOKEN_FALLBACK')
}
