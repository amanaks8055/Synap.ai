// ============================================================
// SYNAP — Gemini Content Script
// ============================================================

console.log('[Synap] Gemini content script loaded ✅');

const origFetch = window.fetch.bind(window);
window.fetch = function (input, init) {
    const url = typeof input === 'string' ? input : (input?.url || '');

    if (url.includes('StreamGenerateContent') || url.includes('batchEmbedContents') || url.includes('GenerateContent')) {
        console.log('[Synap] Gemini message detected!');
        chrome.runtime.sendMessage({ action: 'usage', provider: 'gemini' });
    }

    return origFetch(input, init);
};

console.log('[Synap] Gemini sensor active ✅');
