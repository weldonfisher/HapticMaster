// Variables to manage cooldown
let lastTriggerTime = 0;
const COOLDOWN_MS = 100; // Reduced cooldown for snappier feel

// Default settings cache
let settings = {
    enableExtension: true,
    hoverPattern: "single",
    clickPattern: "single"
};

// Initialize settings
chrome.storage.local.get(settings, (items) => {
    settings = items;
});

// Update settings when they change
chrome.storage.onChanged.addListener((changes) => {
    for (let key in changes) {
        if (settings.hasOwnProperty(key)) {
            settings[key] = changes[key].newValue;
        }
    }
});

// Function to trigger haptic feedback
function triggerHaptic(source, pattern) {
    // If pattern is "none", it means disabled
    if (!pattern || pattern === "none") return;

    const now = Date.now();

    // Check cooldown
    if (now - lastTriggerTime < COOLDOWN_MS) {
        return;
    }

    // Check if extension is enabled
    if (!settings.enableExtension) {
        return;
    }

    lastTriggerTime = now;
    // Always use Channel 1 for this simplified version
    const channel = 1;
    console.log(`[MX4] Triggering Channel ${channel} (${pattern}) from ${source}`);

    // Send message to background script
    chrome.runtime.sendMessage({
        type: "TRIGGER_HAPTIC",
        source: source,
        channel: channel,
        pattern: pattern
    });
}

// Hover Event Listener
document.addEventListener('mouseover', (event) => {
    const target = event.target;

    if (target.closest('a') || target.closest('button') || target.closest('[role="button"]')) {
        triggerHaptic("HOVER", settings.hoverPattern);
    }
});

// Click Event Listener
document.addEventListener('click', (event) => {
    const target = event.target;

    // Ignore Inputs and Textareas
    if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') {
        return;
    }

    triggerHaptic("CLICK", settings.clickPattern);
});

console.log("[MX4] Content script loaded (Multi-Channel Version).");
