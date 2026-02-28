// ============================================================
// SYNAP — ChatGPT Content Script — FIXED
// ============================================================

console.log('[Synap] ChatGPT content script loaded ✅');

// ── Page load pe fetch karo ───────────────────────────────────
fetchChatGPTRealUsage();

// ── MutationObserver — naya ChatGPT reply detect karo ─────────
let lastChatCount = 0;

const observer = new MutationObserver(() => {
    // ChatGPT ke assistant messages count karo
    const msgs = document.querySelectorAll('.agent-turn, [data-testid*="assistant"]');
    if (msgs.length > lastChatCount) {
        lastChatCount = msgs.length;
        console.log('[Synap] ChatGPT new message detected! Count:', lastChatCount);
        setTimeout(fetchChatGPTRealUsage, 2000);
    }
});

function startObserver() {
    if (document.body) {
        observer.observe(document.body, { childList: true, subtree: true });
        console.log('[Synap] ChatGPT observer active ✅');
    }
}

if (document.body) {
    startObserver();
} else {
    document.addEventListener('DOMContentLoaded', startObserver);
}

// ── Real ChatGPT Usage ────────────────────────────────────────
async function fetchChatGPTRealUsage() {
    try {
        const res = await fetch('/backend-api/wham/usage', { credentials: 'include' });
        if (!res.ok) return;

        const data = await res.json();
        console.log('[Synap] ChatGPT real usage:', data);

        const gpt4o = data?.window_usage?.['gpt-4o'] || data?.window_usage?.['gpt4o'] || {};

        chrome.runtime.sendMessage({
            action: 'realUsageData',
            provider: 'chatgpt',
            data: {
                provider: 'chatgpt',
                sessionUsed: gpt4o.count ?? 0,
                sessionLimit: gpt4o.limit ?? 40,
                resetAt: gpt4o.reset_at ?? null,
                models: data?.window_usage ?? {},
            }
        });
    } catch (e) {
        console.log('[Synap] ChatGPT API error:', e.message);
    }
}

chrome.runtime.onMessage.addListener((msg) => {
    if (msg.action === 'fetchRealUsage') fetchChatGPTRealUsage();
});
