// Default settings
const enableExtension = document.getElementById('enableExtension');
const hoverPattern = document.getElementById('hoverPattern');
const clickPattern = document.getElementById('clickPattern');
const connectionStatus = document.getElementById('connectionStatus');
const statusDot = document.querySelector('.dot');

// Check Connection to Native App
const checkConnection = () => {
  fetch('http://localhost:3000')
    .then(res => {
      if (res.ok) {
        connectionStatus.textContent = "Connected";
        connectionStatus.style.color = "#4CAF50";
        statusDot.style.backgroundColor = "#4CAF50";
        statusDot.style.boxShadow = "0 0 5px #4CAF50";
      } else {
        throw new Error("Server error");
      }
    })
    .catch(err => {
      console.log("Connection failed", err);
      connectionStatus.textContent = "Disconnected (App Closed?)";
      connectionStatus.style.color = "#FF5252";
      statusDot.style.backgroundColor = "#FF5252";
      statusDot.style.boxShadow = "0 0 5px #FF5252";
    });
};

// Run check immediately
checkConnection();

// Load saved settings
chrome.storage.local.get({
  enableExtension: true,
  hoverPattern: "single",
  clickPattern: "single"
}, (items) => {
  enableExtension.checked = items.enableExtension;
  hoverPattern.value = items.hoverPattern;
  clickPattern.value = items.clickPattern;
});

// Save settings when changed
const saveSettings = () => {
  chrome.storage.local.set({
    enableExtension: enableExtension.checked,
    hoverPattern: hoverPattern.value,
    clickPattern: clickPattern.value
  });
};

enableExtension.addEventListener('change', saveSettings);
hoverPattern.addEventListener('change', saveSettings);
clickPattern.addEventListener('change', saveSettings);

// Test Buttons Logic
document.getElementById('testHover').addEventListener('click', () => {
  const pattern = hoverPattern.value;
  if (pattern === 'none') return;

  chrome.runtime.sendMessage({
    type: "TRIGGER_HAPTIC",
    channel: 1,
    pattern: pattern
  });
});

document.getElementById('testClick').addEventListener('click', () => {
  const pattern = clickPattern.value;
  if (pattern === 'none') return;

  chrome.runtime.sendMessage({
    type: "TRIGGER_HAPTIC",
    channel: 1,
    pattern: pattern
  });
});
