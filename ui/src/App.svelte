<script lang="ts">
  import { onMount } from 'svelte';
  import { ServiceRequest, Pong } from './proto/base';

  let status = $state("Waiting for signal...");
  let serverTime = $state<string | null>(null);
  let error = $state<string | null>(null);

  async function sendPing() {
    status = "Sending Ping...";
    error = null;

    try {
      // 1. Construct the Payload (Binary Contract)
      const req = ServiceRequest.create({
        ping: { timestamp: Date.now() }
      });
      const buffer = ServiceRequest.encode(req).finish();

      // 2. Fire at Sovereign Core
      // Note: We use fetch directly. In the real app, we'll wrap this in a transport layer.
      const response = await fetch('http://localhost:4000/api', {
        method: 'POST',
        headers: { 'Content-Type': 'application/octet-stream' },
        body: buffer
      });

      if (!response.ok) throw new Error(`Server status: ${response.status}`);

      // 3. Decode the Echo
      const responseBlob = await response.arrayBuffer();
      // The backend returns the raw Pong message (based on our router.ex logic)
      const pong = Pong.decode(new Uint8Array(responseBlob));

      status = `Received Signal from: ${pong.serverName}`;
      serverTime = new Date(Number(pong.timestamp)).toLocaleTimeString();

    } catch (e) {
      console.error(e);
      status = "Connection Failed";
      error = e instanceof Error ? e.message : "Unknown error";
    }
  }
</script>

<main>
  <div class="card">
    <h1>Protocol Zero</h1>
    <p class="status" class:error={!!error}>{status}</p>
    
    {#if serverTime}
      <p class="timestamp">Server Time: {serverTime}</p>
    {/if}

    <button onclick={sendPing}>
      Ping Core (:4000)
    </button>
  </div>
</main>

<style>
  main { 
    height: 100vh; display: grid; place-items: center; 
    font-family: monospace; background: #1a1a1a; color: #fff;
  }
  .card {
    background: #2a2a2a; padding: 2rem; border-radius: 8px;
    border: 1px solid #333; text-align: center;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
  }
  h1 { margin-top: 0; color: #a388ee; }
  button {
    background: #a388ee; color: #1a1a1a; border: none;
    padding: 0.8em 1.5em; font-size: 1rem; font-weight: bold;
    cursor: pointer; border-radius: 4px; transition: opacity 0.2s;
  }
  button:hover { opacity: 0.9; }
  .status { color: #888; margin: 1em 0; }
  .status.error { color: #ee8888; }
  .timestamp { color: #88eeaa; font-weight: bold; }
</style>
