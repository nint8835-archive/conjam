<script lang="ts">
    import { onMount } from 'svelte';
    import Controls from './components/Controls.svelte';
    import ElementSelector from './components/ElementSelector.svelte';
    import Framerate from './components/Framerate.svelte';
    import { init } from './game';

    onMount(() => {
        init();
    });
</script>

<div class="flex w-full flex-row">
    <div class="flex-1"></div>
    <div class="w-[640px]">
        <canvas
            class="scale relative z-10 h-[480px] w-full bg-black"
            style="image-rendering: pixelated"
            id="canvas"
            width="640"
            height="480"
        ></canvas>
        <Controls />
    </div>
    <div class="h-[480px] flex-1"><ElementSelector /></div>
</div>
<Framerate />
