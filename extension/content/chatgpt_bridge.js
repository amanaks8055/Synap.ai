window.addEventListener('__synapUsage', (e) => {
    const provider = e.detail?.provider;
    if (provider) chrome.runtime.sendMessage({ action: 'usage', provider });
});
console.log('[Synap] ChatGPT bridge ready ✅');
