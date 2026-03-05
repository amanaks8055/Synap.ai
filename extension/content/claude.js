// ============================================================
// SYNAP — Claude Content Script (MAIN World)
// CodexBar Approach: Network intercept + API usage fetch
// NO chrome.runtime — communicate via window.postMessage
// ============================================================

console.log('[Synap] Claude MAIN script loaded ✅');

// ── Fetch real Claude usage from internal API ─────────────────
async function fetchClaudeRealUsage() {
  try {
    const orgRes = await fetch('/api/organizations', {
      credentials: 'include'
    });
    if (!orgRes.ok) {
      console.log('[Synap] Claude orgs API returned:', orgRes.status);
      return;
    }

    const orgs = await orgRes.json();
    const orgId = orgs?.[0]?.uuid;
    if (!orgId) {
      console.log('[Synap] Claude: no org found');
      return;
    }

    const usageRes = await fetch(`/api/organizations/${orgId}/usage`, {
      credentials: 'include'
    });
    if (!usageRes.ok) return;

    const usage = await usageRes.json();
    console.log('[Synap] Claude real usage:', usage);

    // Send to ISOLATED world via postMessage
    window.postMessage({
      type: 'SYNAP_REAL_USAGE',
      provider: 'claude',
      data: {
        provider: 'claude',
        sessionUsed: usage.session_message_count ?? 0,
        sessionLimit: usage.session_message_limit ?? 10,
        weeklyUsed: usage.weekly_message_count ?? 0,
        weeklyLimit: usage.weekly_message_limit ?? 50,
        resetAt: usage.session_reset_at ?? null,
        weeklyResetAt: usage.weekly_reset_at ?? null,
        source: 'api'
      }
    }, '*');
  } catch (e) {
    console.log('[Synap] Claude API error:', e.message);
  }
}

// ── Network Intercept — fetch() override ──────────────────────
const _origFetch = window.fetch;
let _lastDetect = 0;

window.fetch = async function (...args) {
  const url = typeof args[0] === 'string' ? args[0] : args[0]?.url ?? '';
  const result = _origFetch.apply(this, args);

  // Detect Claude message send
  if (
    (url.includes('/api/organizations') && url.includes('/messages')) ||
    url.includes('/api/append_message') ||
    (url.includes('claude.ai/api') && url.includes('completion'))
  ) {
    const now = Date.now();
    if (now - _lastDetect > 2000) {
      _lastDetect = now;
      console.log('[Synap] Claude message detected via network ✅');

      // Notify bridge of count increment
      window.postMessage({ type: 'SYNAP_USAGE', provider: 'claude' }, '*');

      // Fetch real usage after API updates
      setTimeout(fetchClaudeRealUsage, 1500);
    }
  }

  return result;
};

// ── Listen for fetch triggers from bridge ─────────────────────
window.addEventListener('message', (e) => {
  if (e.data?.type === 'SYNAP_FETCH_USAGE' && e.data?.provider === 'claude') {
    fetchClaudeRealUsage();
  }
});

// ── Initial fetch on page load ────────────────────────────────
fetchClaudeRealUsage();

console.log('[Synap] Claude network intercept active ✅');
