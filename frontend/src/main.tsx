import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

window.addEventListener("error", (event) => {
  const root = document.getElementById("root");
  if (root && root.innerHTML.trim() === "") {
    root.innerHTML = `
      <div style="padding: 40px; text-align: center; font-family: sans-serif; background: #0A1712; color: #E6F0EC; min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center;">
        <h2 style="color: #16C47F; margin-bottom: 8px;">OrbX Nexus ERP</h2>
        <p style="color: #9EB3AA; margin-bottom: 16px;">An unexpected startup error occurred:</p>
        <pre style="background: rgba(0,0,0,0.4); padding: 12px; border-radius: 8px; font-size: 13px; color: #ff5252; max-width: 600px; overflow: auto; text-align: left;">${event.message} (${event.filename}:${event.lineno})</pre>
        <button onclick="localStorage.clear(); window.location.href='/login';" style="margin-top: 20px; padding: 10px 20px; font-size: 14px; font-weight: 600; cursor: pointer; border-radius: 8px; background: #16C47F; color: #0A1712; border: none;">Clear Cache & Login</button>
      </div>
    `;
  }
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
