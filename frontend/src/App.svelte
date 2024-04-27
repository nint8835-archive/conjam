<script lang="ts">
    import { onMount } from "svelte";
    import { init } from "./game";
    import Framerate from "./components/Framerate.svelte";

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
<Framerate />