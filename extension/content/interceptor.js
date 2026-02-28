// ============================================================
// SYNAP INTERCEPTOR.JS — Runs in MAIN world
// Extreme network interception for all AI tools
// ============================================================

(function () {
    function notify(toolId) {
        console.log(`[Synap] Detected usage for: ${toolId} 🚀`);
        window.dispatchEvent(new CustomEvent('SYNAP_USAGE', { detail: { toolId } }));
    }

    // 1. Intercept fetch()
    const originalFetch = window.fetch;
    window.fetch = async function (...args) {
        const url = (args[0] instanceof Request ? args[0].url : args[0]) || '';
        const options = args[1] || (args[0] instanceof Request ? args[0] : {});
        const method = options.method?.toUpperCase() || 'GET';

        // ChatGPT
        if (url.includes('/backend-api/conversation') || url.includes('/backend-api/chat')) {
            if (method === 'POST') notify('chatgpt_gpt4o');
        }

        // Claude
        else if (url.includes('/api/organizations/') && url.includes('/chat_conversations/')) {
            if (method === 'POST') notify('claude');
        }

        // Gemini
        else if (url.includes('WaitService/StreamGenerateContent') || url.includes('v1/messages')) {
            notify('gemini');
        }

        // Perplexity
        else if (url.includes('perplexity.ai/api/v1/chat')) {
            notify('perplexity');
        }

        return originalFetch.apply(this, args);
    };

    // 2. Intercept XMLHttpRequest (Fallback)
    const originalOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function (method, url, ...rest) {
        this._synapMethod = method;
        this._synapUrl = url;
        return originalOpen.apply(this, [method, url, ...rest]);
    };

    const originalSend = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.send = function (body) {
        const url = this._synapUrl || '';
        const method = this._synapMethod?.toUpperCase() || 'GET';

        if (method === 'POST') {
            if (url.includes('/backend-api/conversation')) notify('chatgpt_gpt4o');
            if (url.includes('/chat_conversations/')) notify('claude');
            if (url.includes('StreamGenerateContent')) notify('gemini');
        }

        return originalSend.apply(this, [body]);
    };

    console.log('[Synap] Extreme Interceptor Loaded ✅');
})();
