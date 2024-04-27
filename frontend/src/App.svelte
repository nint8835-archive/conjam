<script lang="ts">
    import { onMount } from 'svelte';
    import Framerate from './components/Framerate.svelte';
    import { init } from './game';

    onMount(() => {
        init();
    });
</script>

<canvas
    class="scale h-[480px] w-[640px] bg-black bg-opacity-25"
    style="image-rendering: pixelated"
    id="canvas"
    width="640"
    height="480"
></canvas>
<Framerate />
