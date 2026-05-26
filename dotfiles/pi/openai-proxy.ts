import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Route the built-in `openai` provider through a relay configured by env.
// OPENAI_API_KEY in env should be the proxy/relay key when using a proxy.
export default function (pi: ExtensionAPI) {
  const baseUrl = process.env.OPENAI_BASE_URL;

  if (!baseUrl) {
    return;
  }

  pi.registerProvider("openai", {
    baseUrl,
  });
}
