// ============================================================
// SYNAP — Claude Bridge (ISOLATED World)
// Relays postMessage from MAIN → chrome.runtime → background
// ============================================================

window.addEventListener('message', (event) => {
  if (event.source !== window) return;

  // Real usage data from API
  if (event.data?.type === 'SYNAP_REAL_USAGE' && event.data?.provider === 'claude') {
    chrome.runtime.sendMessage({
      action: 'realUsageData',
      provider: 'claude',
      data: event.data.data
    }).catch(() => {});
    return;
  }

  // Simple count increment
  if (event.data?.type === 'SYNAP_USAGE' && event.data?.provider === 'claude') {
    chrome.runtime.sendMessage({
      action: 'usage',
      provider: 'claude'
    }).catch(() => {});
    return;
  }
});

// Listen for background triggers and relay to MAIN world
chrome.runtime.onMessage.addListener((msg) => {
  if (msg.action === 'fetchRealUsage') {
    window.postMessage({ type: 'SYNAP_FETCH_USAGE', provider: 'claude' }, '*');
  }
});

console.log('[Synap] Claude bridge (ISOLATED) ready ✅');
