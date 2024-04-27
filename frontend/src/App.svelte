<script lang="ts">
    import { onMount } from 'svelte';
    import Controls from './components/Controls.svelte';
    import Framerate from './components/Framerate.svelte';
    import { init } from './game';

    onMount(() => {
        init();
    });
</script>

<div class="w-[640px]">
    <canvas
        class="scale h-[480px] w-full bg-black bg-opacity-25"
        style="image-rendering: pixelated"
        id="canvas"
        width="640"
        height="480"
    ></canvas>
    <Controls />
</div>
<Framerate />
