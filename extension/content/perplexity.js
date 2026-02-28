// Bridge script between MAIN world and BACKGROUND
window.addEventListener('SYNAP_USAGE', (event) => {
    chrome.runtime.sendMessage({
        action: 'usage',
        toolId: event.detail.toolId,
        timestamp: Date.now()
    });
});
