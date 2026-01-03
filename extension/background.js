console.log("MX4 Background Worker Loaded");

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.type === "TRIGGER_HAPTIC") {
        // console.log("Forwarding haptic trigger", message);

        fetch('http://localhost:3000/haptic', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                channel: message.channel || 1,
                pattern: message.pattern || "single"
            })
        })
            .then(res => {
                if (!res.ok) {
                    console.error("Bridge error:", res.status);
                }
            })
            .catch(err => {
                console.error("Bridge connection failed:", err);
            });

        sendResponse({ status: "sent" });
    }
    return true;
});
