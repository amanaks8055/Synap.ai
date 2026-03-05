// ============================================================
// SYNAP — Perplexity Bridge (ISOLATED World)
// Relays postMessage from MAIN → chrome.runtime → background
// ============================================================

window.addEventListener('message', (event) => {
  if (event.source !== window) return;

  // Real usage data
  if (event.data?.type === 'SYNAP_REAL_USAGE' && event.data?.provider === 'perplexity') {
    chrome.runtime.sendMessage({
      action: 'realUsageData',
      provider: 'perplexity',
      data: event.data.data
    }).catch(() => {});
    return;
  }

  // Simple count increment
  if (event.data?.type === 'SYNAP_USAGE' && event.data?.provider === 'perplexity') {
    chrome.runtime.sendMessage({
      action: 'usage',
      provider: 'perplexity'
    }).catch(() => {});
    return;
  }
});

// Listen for background triggers and relay to MAIN world
chrome.runtime.onMessage.addListener((msg) => {
  if (msg.action === 'fetchRealUsage') {
    window.postMessage({ type: 'SYNAP_FETCH_USAGE', provider: 'perplexity' }, '*');
  }
});

console.log('[Synap] Perplexity bridge (ISOLATED) ready ✅');
