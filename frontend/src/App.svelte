<script lang="ts">
    import { onMount } from 'svelte';
    import Controls from './components/Controls.svelte';
    import Framerate from './components/Framerate.svelte';
    import { init } from './game';

    onMount(() => {
        init();
    });
</script>

<div class="flex w-[640px] flex-col">
    <canvas
        class="scale z-10 h-[480px] w-full bg-black"
        style="image-rendering: pixelated"
        id="canvas"
        width="640"
        height="480"
    ></canvas>
    <Controls />
</div>
<Framerate />
