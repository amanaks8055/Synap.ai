try {
  importScripts('config.js');
} catch (_) {
  // Optional local-only config file.
}

const SUPABASE_URL = self.SUPABASE_URL;
const SUPABASE_KEY = self.SUPABASE_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.warn('[Synap] Missing Supabase config. Create extension/config.js');
}

// ── Storage ──────────────────────────────────────────────────
function getData() {
  return new Promise(r => chrome.storage.local.get(['usage', 'userId'], r));
}
function setData(obj) {
  return new Promise(r => chrome.storage.local.set(obj, r));
}
async function getUserId() {
  const { userId } = await getData();
  if (userId) return userId;
  // Use deterministic test ID so Flutter app can find it
  // In production, this would come from auth flow
  const id = 'synap_test_user';
  await setData({ userId: id });
  return id;
}

// ── Supabase Sync ────────────────────────────────────────────
async function syncToSupabase(usage) {
  const userId = await getUserId();
  try {
    // Pehle check karo row exist karti hai ya nahi
    const checkRes = await fetch(
      `${SUPABASE_URL}/rest/v1/extension_sync?user_id=eq.${userId}`,
      {
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`
        }
      }
    );
    const existing = await checkRes.json();

    // Exist kare toh PATCH (update), warna POST (insert)
    const method = existing.length > 0 ? 'PATCH' : 'POST';
    const url = existing.length > 0
      ? `${SUPABASE_URL}/rest/v1/extension_sync?user_id=eq.${userId}`
      : `${SUPABASE_URL}/rest/v1/extension_sync`;

    const res = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({
        user_id: userId,
        payload: usage,
        updated_at: new Date().toISOString()
      })
    });

    if (res.ok) {
      console.log('[Synap] ✅ Synced to Supabase');
    } else {
      console.error('[Synap] Supabase error:', await res.text());
    }
  } catch (e) {
    console.error('[Synap] Supabase sync failed:', e.message);
  }
}

// ── Message Handler ──────────────────────────────────────────
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {

  // Content script ne real usage data bheja (API call se)
  if (msg.action === 'realUsageData') {
    const provider = msg.provider;
    const data = msg.data;
    getData().then(async ({ usage = {} }) => {
      usage[provider] = { ...data, lastFetched: Date.now() };
      usage.lastUpdated = Date.now();
      await setData({ usage });
      await syncToSupabase(usage);
      console.log(`[Synap] ${provider} real usage saved:`, data);
    });
    sendResponse({ ok: true });
    return true;
  }

  // Simple count increment (fallback)
  if (msg.action === 'usage') {
    const provider = msg.provider;
    getData().then(async ({ usage = {} }) => {
      if (!usage[provider]) {
        usage[provider] = { provider, sessionUsed: 0, sessionLimit: getDefaultLimit(provider) };
      }
      usage[provider].sessionUsed = (usage[provider].sessionUsed || 0) + 1;
      usage[provider].lastActivity = Date.now();
      usage.lastUpdated = Date.now();
      await setData({ usage });
      await syncToSupabase(usage);
      console.log(`[Synap] ${provider} count:`, usage[provider].sessionUsed);
    });
    sendResponse({ ok: true });
    return true;
  }

  // Popup/app se data maanga
  if (msg.action === 'getAll') {
    getData().then(({ usage = {}, userId }) => {
      sendResponse({ usage, userId });
    });
    return true;
  }

  // Force reset
  if (msg.action === 'reset') {
    getData().then(async ({ usage = {} }) => {
      if (msg.provider && usage[msg.provider]) {
        usage[msg.provider].sessionUsed = 0;
      } else {
        // Reset all
        Object.keys(usage).forEach(k => {
          if (usage[k]?.sessionUsed !== undefined) usage[k].sessionUsed = 0;
        });
      }
      await setData({ usage });
      await syncToSupabase(usage);
      sendResponse({ ok: true });
    });
    return true;
  }

  return true;
});

function getDefaultLimit(provider) {
  return { claude: 10, chatgpt: 40, gemini: 100, perplexity: 50 }[provider] || 40;
}

// Periodic sync every 3 minutes
chrome.alarms.create('sync', { periodInMinutes: 3 });
chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name !== 'sync') return;

  // Also sync existing data to Supabase on each alarm
  const { usage = {} } = await getData();
  if (Object.keys(usage).length > 0) {
    await syncToSupabase(usage);
  }

  // Ask bridge scripts (ISOLATED world) to trigger MAIN world fetch
  const tabs = await chrome.tabs.query({});
  const targets = [
    'claude.ai', 'chatgpt.com', 'gemini.google.com', 'www.perplexity.ai'
  ];
  for (const tab of tabs) {
    if (!tab.url) continue;
    let hostname = '';
    try { hostname = new URL(tab.url).hostname; } catch (_) { continue; }
    if (targets.some(t => hostname === t || hostname.endsWith('.' + t))) {
      chrome.tabs.sendMessage(tab.id, { action: 'fetchRealUsage' }).catch(() => {});
    }
  }
});

chrome.runtime.onInstalled.addListener(() => console.log('[Synap] Installed ✅'));
console.log('[Synap] Background loaded ✅');
