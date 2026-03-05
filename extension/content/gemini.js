// ============================================================
// SYNAP — Gemini Content Script (MAIN World)
// CodexBar Approach: Network intercept
// NO chrome.runtime — communicate via window.postMessage
// ============================================================

console.log('[Synap] Gemini MAIN script loaded ✅');

const _origFetch = window.fetch.bind(window);
let _lastDetect = 0;

window.fetch = function (input, init) {
  const url = typeof input === 'string' ? input : (input?.url || '');

  if (
    url.includes('StreamGenerateContent') ||
    url.includes('GenerateContent') ||
    url.includes('batchEmbedContents')
  ) {
    const now = Date.now();
    if (now - _lastDetect > 3000) {
      _lastDetect = now;
      console.log('[Synap] Gemini message detected via network ✅');
      window.postMessage({ type: 'SYNAP_USAGE', provider: 'gemini' }, '*');
    }
  }

  return _origFetch(input, init);
};

// ── Listen for fetch triggers from bridge ─────────────────────
window.addEventListener('message', (e) => {
  if (e.data?.type === 'SYNAP_FETCH_USAGE' && e.data?.provider === 'gemini') {
    // Gemini has no public usage API, count-based only
    console.log('[Synap] Gemini fetch trigger received');
  }
});

console.log('[Synap] Gemini network intercept active ✅');
