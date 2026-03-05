// ============================================================
// SYNAP — Perplexity Content Script (MAIN World)
// Network intercept for Perplexity AI
// NO chrome.runtime — communicate via window.postMessage
// ============================================================

console.log('[Synap] Perplexity MAIN script loaded ✅');

const _origFetch = window.fetch.bind(window);
let _lastDetect = 0;

window.fetch = function (input, init) {
  const url = typeof input === 'string' ? input : (input?.url || '');
  const opts = init || {};
  const method = (opts.method || 'GET').toUpperCase();

  // Perplexity search/chat API calls
  if (
    method === 'POST' && (
      url.includes('/api/query') ||
      url.includes('/api/v1/chat') ||
      url.includes('/api/search') ||
      url.includes('/backend/chat')
    )
  ) {
    const now = Date.now();
    if (now - _lastDetect > 3000) {
      _lastDetect = now;
      console.log('[Synap] Perplexity message detected via network ✅');
      window.postMessage({ type: 'SYNAP_USAGE', provider: 'perplexity' }, '*');
    }
  }

  return _origFetch(input, init);
};

console.log('[Synap] Perplexity network intercept active ✅');
