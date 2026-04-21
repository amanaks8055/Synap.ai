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
        wrap.replaceChildren();
        const emptyDiv = document.createElement('div');
        emptyDiv.className = 'empty-state';
        emptyDiv.textContent = 'Open ChatGPT, Claude or Gemini';
        const br = document.createElement('br');
        emptyDiv.appendChild(br);
        const text = document.createTextNode('— tracking starts automatically');
        emptyDiv.appendChild(text);
        wrap.appendChild(emptyDiv);
        return;
    }

    wrap.replaceChildren();

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
        
        const emojiDiv = document.createElement('div');
        emojiDiv.className = 'temoji';
        emojiDiv.textContent = EMOJIS[id] || '🤖';
        row.appendChild(emojiDiv);

        const infoDiv = document.createElement('div');
        infoDiv.className = 'tinfo';
        
        const nameDiv = document.createElement('div');
        nameDiv.className = 'tname';
        nameDiv.textContent = (NAMES[id] || id) + ' ';
        
        const badgeSpan = document.createElement('span');
        badgeSpan.className = `badge ${badgeClass}`;
        badgeSpan.textContent = badgeLabel;
        nameDiv.appendChild(badgeSpan);
        infoDiv.appendChild(nameDiv);

        const barDiv = document.createElement('div');
        barDiv.className = 'tbar';
        const fillDiv = document.createElement('div');
        fillDiv.className = 'tfill';
        fillDiv.style.width = `${pct * 100}%`;
        fillDiv.style.background = col;
        barDiv.appendChild(fillDiv);
        infoDiv.appendChild(barDiv);
        row.appendChild(infoDiv);

        const rightDiv = document.createElement('div');
        rightDiv.className = 'tright';
        
        const remDiv = document.createElement('div');
        remDiv.className = 'trem';
        remDiv.style.color = col;
        remDiv.textContent = remaining;
        rightDiv.appendChild(remDiv);

        const unitDiv = document.createElement('div');
        unitDiv.className = 'tunit';
        unitDiv.textContent = `${used}/${limit}`;
        rightDiv.appendChild(unitDiv);

        const resetDiv = document.createElement('div');
        resetDiv.className = 'treset';
        resetDiv.textContent = resetIn;
        rightDiv.appendChild(resetDiv);
        row.appendChild(rightDiv);

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
