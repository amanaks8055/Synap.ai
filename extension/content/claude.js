// ============================================================
// SYNAP — claude.js — CodexBar Approach (Network Intercept)
// DOM observation NAHI — fetch() intercept karta hai
// ============================================================

console.log('[Synap] Claude sensor active ✅');

// ── Real Usage Fetch (credentials:include — cookie automatic) ──
async function fetchClaudeRealUsage() {
    try {
        const orgRes = await fetch('/api/organizations', {
            credentials: 'include'
        });
        if (!orgRes.ok) return;

        const orgs = await orgRes.json();
        const orgId = orgs?.[0]?.uuid;
        if (!orgId) return;

        const usageRes = await fetch(`/api/organizations/${orgId}/usage`, {
            credentials: 'include'
        });
        if (!usageRes.ok) return;

        const usage = await usageRes.json();
        console.log('[Synap] Claude real usage:', usage);

        const stored = await new Promise(r => chrome.storage.local.get(['usage'], r));
        const localCount = stored?.usage?.claude?.sessionUsed || 0;

        // Background ko real data bhejo
        chrome.runtime.sendMessage({
            action: 'realUsageData',
            provider: 'claude',
            data: {
                provider: 'claude',
                sessionUsed: localCount > 0 ? localCount : (usage.session_message_count ?? 0),
                sessionLimit: usage.session_message_limit ?? 10,
                weeklyUsed: usage.weekly_message_count ?? 0,
                weeklyLimit: usage.weekly_message_limit ?? 50,
                resetAt: usage.session_reset_at ?? null,
                weeklyResetAt: usage.weekly_reset_at ?? null,
                source: 'api' // Real data hai
            }
        });

    } catch (e) {
        console.log('[Synap] Claude API error:', e.message);
    }
}

// ── Network Intercept — fetch() override ──────────────────────
// DOM nahi dekhta — network call pakadta hai
const _originalFetch = window.fetch;
let _lastDetected = 0;

window.fetch = async function (...args) {
    const url = typeof args[0] === 'string' ? args[0] : args[0]?.url ?? '';
    const result = await _originalFetch.apply(this, args);

    // Claude message send hone wali API detect karo
    if (
        (url.includes('/api/organizations') && url.includes('/messages')) ||
        url.includes('/api/append_message') ||
        (url.includes('claude.ai/api') && url.includes('completion'))
    ) {
        const now = Date.now();
        if (now - _lastDetected > 2000) { // Duplicate avoid
            _lastDetected = now;
            console.log('[Synap] Claude message detected via network ✅');

            // Background ko signal bhejo
            chrome.runtime.sendMessage({
                action: 'usage',
                provider: 'claude'
            });

            // 1.5 sec baad real usage fetch karo (API update hone ka time)
            setTimeout(fetchClaudeRealUsage, 1500);
        }
    }

    return result;
};

// ── Page load pe fetch karo ────────────────────────────────────
fetchClaudeRealUsage();

// ── Background se trigger aane par fetch karo ──────────────────
chrome.runtime.onMessage.addListener((msg) => {
    if (msg.action === 'fetchRealUsage') {
        fetchClaudeRealUsage();
    }
});

console.log('[Synap] Claude network intercept active ✅');
