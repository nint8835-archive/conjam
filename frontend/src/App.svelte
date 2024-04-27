<script lang="ts">
    import { onMount } from "svelte";
    import { init, store } from "./game";

    $: frameRate = $store.currentFrameTime - $store.lastFrameTime;

    onMount(() => {
        init();
    });
</script>

<h1 class="font-bold">Nit's Game of Sand</h1>
<canvas
        class="scale h-[480px] w-[640px] bg-black bg-opacity-25"
        style="image-rendering: pixelated"
        id="canvas"
        width="640"
        height="480"
></canvas>
<div>FPS: {frameRate}</div>