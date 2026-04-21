// supabase/functions/verify-purchase/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0"

const GOOGLE_PLAY_API_URL = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications"
const GOOGLE_OAUTH_TOKEN_URL = "https://oauth2.googleapis.com/token"
const ANDROID_PUBLISHER_SCOPE = "https://www.googleapis.com/auth/androidpublisher"

serve(async (req) => {
    if (req.method !== "POST") {
        return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 })
    }

    const payload = await req.json().catch(() => null)
    if (!payload) {
        return new Response(JSON.stringify({ error: "Invalid JSON body" }), { status: 400 })
    }

    const { productId, purchaseToken, package_name } = payload
    const userId = req.headers.get("x-user-id")

    if (!productId || !purchaseToken || !package_name || !userId) {
        return new Response(
            JSON.stringify({ error: "Missing required fields: productId, purchaseToken, package_name, x-user-id" }),
            { status: 400 },
        )
    }

    // 1. Get Google Play Access Token (requires service account credentials)
    const accessToken = await getGoogleAccessToken()
    if (!accessToken) {
        return new Response(JSON.stringify({ error: "Unable to obtain Google Play access token" }), { status: 500 })
    }

    // 2. Verify with Google Play Developer API
    const verifyUrl = `${GOOGLE_PLAY_API_URL}/${package_name}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`
    const response = await fetch(verifyUrl, {
        headers: { Authorization: `Bearer ${accessToken}` },
    })

    if (!response.ok) {
        const errText = await response.text().catch(() => "")
        return new Response(
            JSON.stringify({ error: "Google Play verification failed", status: response.status, details: errText }),
            { status: 400 },
        )
    }

    const purchaseData = await response.json()

    if (purchaseData.paymentState !== 1) { // 1 = Received
        return new Response(JSON.stringify({ error: "Invalid payment state", purchaseData }), { status: 400 })
    }

    // 3. Update Supabase Database (Internal call via Service Role Key)
    const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const tier = String(productId).includes("synap_pro_") ? "professional" : "student"

    const { data, error } = await supabase.from('subscriptions').upsert({
        user_id: userId,
        product_id: productId,
        tier,
        status: 'active',
        purchase_token: purchaseToken,
        updated_at: new Date().toISOString(),
    })

    if (error) {
        return new Response(JSON.stringify({ error: "DB upsert failed", details: error.message }), { status: 500 })
    }

    return new Response(JSON.stringify({ success: true, data }), { status: 200 })
})

async function getGoogleAccessToken() {
    // Prefer static token if explicitly configured
    const fallback = Deno.env.get("GOOGLE_PLAY_ACCESS_TOKEN")?.trim()
    if (fallback) return fallback

    const serviceAccountEmail = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_EMAIL")?.trim()
    const privateKeyRaw = Deno.env.get("GOOGLE_PRIVATE_KEY")?.trim()

    if (!serviceAccountEmail || !privateKeyRaw) {
        throw new Error("Missing Google credentials: GOOGLE_SERVICE_ACCOUNT_EMAIL / GOOGLE_PRIVATE_KEY")
    }

    const now = Math.floor(Date.now() / 1000)
    const claims = {
        iss: serviceAccountEmail,
        scope: ANDROID_PUBLISHER_SCOPE,
        aud: GOOGLE_OAUTH_TOKEN_URL,
        iat: now,
        exp: now + 3600,
    }

    const assertion = await createSignedJwt(claims, privateKeyRaw)

    const tokenRes = await fetch(GOOGLE_OAUTH_TOKEN_URL, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
            grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
            assertion,
        }),
    })

    if (!tokenRes.ok) {
        const details = await tokenRes.text().catch(() => "")
        throw new Error(`OAuth token fetch failed: ${tokenRes.status} ${details}`)
    }

    const tokenJson = await tokenRes.json()
    return tokenJson.access_token as string
}

async function createSignedJwt(claims: Record<string, unknown>, privateKeyRaw: string): Promise<string> {
    const header = { alg: "RS256", typ: "JWT" }
    const enc = new TextEncoder()

    const encodedHeader = base64UrlEncode(enc.encode(JSON.stringify(header)))
    const encodedClaims = base64UrlEncode(enc.encode(JSON.stringify(claims)))
    const signingInput = `${encodedHeader}.${encodedClaims}`

    const key = await importPrivateKey(privateKeyRaw)
    const signature = await crypto.subtle.sign(
        { name: "RSASSA-PKCS1-v1_5" },
        key,
        enc.encode(signingInput),
    )

    const encodedSig = base64UrlEncode(new Uint8Array(signature))
    return `${signingInput}.${encodedSig}`
}

async function importPrivateKey(privateKeyRaw: string): Promise<CryptoKey> {
    const normalizedPem = privateKeyRaw.replace(/\\n/g, "\n")
    const keyData = pemToArrayBuffer(normalizedPem)
    return crypto.subtle.importKey(
        "pkcs8",
        keyData,
        { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
        false,
        ["sign"],
    )
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
    const b64 = pem
        .replace("-----BEGIN PRIVATE KEY-----", "")
        .replace("-----END PRIVATE KEY-----", "")
        .replace(/\s+/g, "")
    const raw = atob(b64)
    const bytes = new Uint8Array(raw.length)
    for (let i = 0; i < raw.length; i++) bytes[i] = raw.charCodeAt(i)
    return bytes.buffer
}

function base64UrlEncode(bytes: Uint8Array): string {
    let str = ""
    for (const b of bytes) str += String.fromCharCode(b)
    return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "")
}
