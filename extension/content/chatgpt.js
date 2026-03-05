// ============================================================
// SYNAP — ChatGPT Content Script (MAIN World)
// CodexBar Approach: Network intercept + API usage fetch
// NO chrome.runtime — communicate via window.postMessage
// ============================================================

console.log('[Synap] ChatGPT MAIN script loaded ✅');

// ── Fetch real ChatGPT usage from internal API ────────────────
async function fetchChatGPTRealUsage() {
  try {
    const res = await fetch('/backend-api/wham/usage', { credentials: 'include' });
    if (!res.ok) {
      console.log('[Synap] ChatGPT usage API returned:', res.status);
      return;
    }

    const data = await res.json();
    console.log('[Synap] ChatGPT real usage:', data);

    // Extract GPT-4o usage (primary model)
    const gpt4o = data?.window_usage?.['gpt-4o']
      || data?.window_usage?.['gpt4o']
      || data?.window_usage?.['auto']
      || {};

    // Send to ISOLATED world via postMessage
    window.postMessage({
      type: 'SYNAP_REAL_USAGE',
      provider: 'chatgpt',
      data: {
        provider: 'chatgpt',
        sessionUsed: gpt4o.count ?? 0,
        sessionLimit: gpt4o.limit ?? 40,
        resetAt: gpt4o.reset_at ?? null,
        models: data?.window_usage ?? {},
        source: 'api'
      }
    }, '*');
  } catch (e) {
    console.log('[Synap] ChatGPT API error:', e.message);
  }
}

// ── Network Intercept — fetch() override ──────────────────────
const _origFetch = window.fetch;
let _lastDetect = 0;

window.fetch = async function (...args) {
  const url = typeof args[0] === 'string' ? args[0] : args[0]?.url ?? '';
  const opts = args[1] || {};
  const method = (opts.method || 'GET').toUpperCase();

  const result = _origFetch.apply(this, args);

  // Detect ChatGPT message send
  if (
    method === 'POST' &&
    (url.includes('/backend-api/conversation') || url.includes('/backend-api/chat'))
  ) {
    const now = Date.now();
    if (now - _lastDetect > 3000) {
      _lastDetect = now;
      console.log('[Synap] ChatGPT message detected via network ✅');

      // Notify bridge of simple count increment
      window.postMessage({ type: 'SYNAP_USAGE', provider: 'chatgpt' }, '*');

      // Fetch real usage after API updates
      setTimeout(fetchChatGPTRealUsage, 2000);
    }
  }

  return result;
};

// ── MutationObserver — fallback detection ─────────────────────
let lastMsgCount = 0;
const observer = new MutationObserver(() => {
  const msgs = document.querySelectorAll(
    '.agent-turn, [data-testid*="assistant"], [data-message-author-role="assistant"]'
  );
  if (msgs.length > lastMsgCount) {
    lastMsgCount = msgs.length;
    console.log('[Synap] ChatGPT DOM message detected, count:', lastMsgCount);
    setTimeout(fetchChatGPTRealUsage, 2000);
  }
});

function startObserver() {
  if (document.body) {
    observer.observe(document.body, { childList: true, subtree: true });
    console.log('[Synap] ChatGPT observer active ✅');
  }
}

if (document.body) startObserver();
else document.addEventListener('DOMContentLoaded', startObserver);

// ── Listen for fetch triggers from bridge ─────────────────────
window.addEventListener('message', (e) => {
  if (e.data?.type === 'SYNAP_FETCH_USAGE' && e.data?.provider === 'chatgpt') {
    fetchChatGPTRealUsage();
  }
});

// ── Initial fetch on page load ────────────────────────────────
fetchChatGPTRealUsage();

console.log('[Synap] ChatGPT network intercept active ✅');
