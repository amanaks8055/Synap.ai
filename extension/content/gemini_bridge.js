// ============================================================
// SYNAP — Gemini Bridge (ISOLATED World)
// Relays postMessage from MAIN → chrome.runtime → background
// ============================================================

window.addEventListener('message', (event) => {
  if (event.source !== window) return;

  // Real usage data (if Gemini ever gets a usage API)
  if (event.data?.type === 'SYNAP_REAL_USAGE' && event.data?.provider === 'gemini') {
    chrome.runtime.sendMessage({
      action: 'realUsageData',
      provider: 'gemini',
      data: event.data.data
    }).catch(() => {});
    return;
  }

  // Simple count increment
  if (event.data?.type === 'SYNAP_USAGE' && event.data?.provider === 'gemini') {
    chrome.runtime.sendMessage({
      action: 'usage',
      provider: 'gemini'
    }).catch(() => {});
    return;
  }
});

// Listen for background triggers and relay to MAIN world
chrome.runtime.onMessage.addListener((msg) => {
  if (msg.action === 'fetchRealUsage') {
    window.postMessage({ type: 'SYNAP_FETCH_USAGE', provider: 'gemini' }, '*');
  }
});

console.log('[Synap] Gemini bridge (ISOLATED) ready ✅');
