// ============================================================
// SYNAP — ChatGPT Bridge (ISOLATED World)
// Relays postMessage from MAIN → chrome.runtime → background
// ============================================================

window.addEventListener('message', (event) => {
  if (event.source !== window) return;

  // Real usage data from API
  if (event.data?.type === 'SYNAP_REAL_USAGE' && event.data?.provider === 'chatgpt') {
    chrome.runtime.sendMessage({
      action: 'realUsageData',
      provider: 'chatgpt',
      data: event.data.data
    }).catch(() => {});
    return;
  }

  // Simple count increment
  if (event.data?.type === 'SYNAP_USAGE' && event.data?.provider === 'chatgpt') {
    chrome.runtime.sendMessage({
      action: 'usage',
      provider: 'chatgpt'
    }).catch(() => {});
    return;
  }
});

// Listen for background triggers and relay to MAIN world
chrome.runtime.onMessage.addListener((msg) => {
  if (msg.action === 'fetchRealUsage') {
    window.postMessage({ type: 'SYNAP_FETCH_USAGE', provider: 'chatgpt' }, '*');
  }
});

console.log('[Synap] ChatGPT bridge (ISOLATED) ready ✅');
