const COLORS = {
    chatgpt: '#10A37F',
    claude: '#FF6B35',
    gemini: '#4285F4',
    perplexity: '#8B5CF6'
};

const EMOJIS = {
    chatgpt: '🟢',
    claude: '🟠',
    gemini: '🔵',
    perplexity: '🟣'
};

const NAMES = {
    chatgpt: 'ChatGPT',
    claude: 'Claude',
    gemini: 'Gemini',
    perplexity: 'Perplexity'
};

function render(usage) {
    const wrap = document.getElementById('toolsWrap');

    if (!usage || Object.keys(usage).length === 0) {
        wrap.innerHTML = '<div class="empty-state">Open ChatGPT, Claude or Gemini<br>— tracking starts automatically</div>';
        return;
    }

    wrap.innerHTML = '';

    // Convert object to array and sort by last used
    const tools = Object.entries(usage)
        .filter(([id]) => id !== 'lastUpdated')
        .sort((a, b) => (b[1].lastActivity || 0) - (a[1].lastActivity || 0));

    tools.forEach(([id, t]) => {
        const used = t.sessionUsed || 0;
        const limit = t.sessionLimit || 40;
        const pct = Math.min(used / limit, 1);
        const remaining = Math.max(limit - used, 0);

        const isExhausted = used >= limit;
        const isLow = pct >= 0.8;

        const col = isExhausted ? '#FF4F6A' : isLow ? '#F5A623' : (COLORS[id] || '#00C8E8');
        const badgeClass = isExhausted ? 'bempty' : isLow ? 'blow' : 'bgood';
        const badgeLabel = isExhausted ? 'LIMIT' : isLow ? 'LOW' : 'OK';

        // Format reset time
        let resetIn = '';
        if (t.resetAt) {
            const diff = new Date(t.resetAt) - new Date();
            if (diff > 0) {
                const h = Math.floor(diff / 3600000);
                const m = Math.floor((diff % 3600000) / 60000);
                resetIn = h > 0 ? `Reset in ${h}h ${m}m` : `Reset in ${m}m`;
            } else {
                resetIn = 'Resetting soon';
            }
        }

        const row = document.createElement('div');
        row.className = 'trow';
        row.innerHTML = `
      <div class="temoji">${EMOJIS[id] || '🤖'}</div>
      <div class="tinfo">
        <div class="tname">${NAMES[id] || id} <span class="badge ${badgeClass}">${badgeLabel}</span></div>
        <div class="tbar"><div class="tfill" style="width:${pct * 100}%;background:${col}"></div></div>
      </div>
      <div class="tright">
        <div class="trem" style="color:${col}">${remaining}</div>
        <div class="tunit">${used}/${limit}</div>
        <div class="treset">${resetIn}</div>
      </div>`;

        row.onclick = () => {
            chrome.runtime.sendMessage({ action: 'reset', provider: id }, () => {
                toast(`✅ ${NAMES[id] || id} reset!`);
                load();
            });
        };
        wrap.appendChild(row);
    });
}

function load() {
    chrome.runtime.sendMessage({ action: 'getAll' }, d => {
        if (d && d.usage) {
            render(d.usage);
            const syncText = document.getElementById('syncText');
            if (syncText) {
                const now = new Date();
                syncText.textContent = `Synced ${now.getHours()}:${String(now.getMinutes()).padStart(2, '0')}`;
            }
        }
    });
}

function toast(msg) {
    const t = document.getElementById('toast');
    if (t) {
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2200);
    }
}

const btnReset = document.getElementById('btnReset');
if (btnReset) {
    btnReset.onclick = () => {
        chrome.runtime.sendMessage({ action: 'reset' }, () => {
            toast('🔄 All tools reset!');
            load();
        });
    };
}

const btnApp = document.getElementById('btnApp');
if (btnApp) {
    btnApp.onclick = () => {
        // Attempt deep link, otherwise alert
        window.open('synap://tracker', '_blank');
        toast('Attempting to open Synap app...');
    };
}

load();
setInterval(load, 3000);
