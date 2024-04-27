<script lang="ts">
    import { store } from '../game.ts';

    const FRAMERATE_INTERVAL = 200;
    let frameRate = 0;
    let lastDisplayTime = performance.now();

    $: {
        const currentTime = performance.now();
        if (currentTime - lastDisplayTime > FRAMERATE_INTERVAL) {
            lastDisplayTime = currentTime;
            frameRate = Math.trunc(1000 / ($store.currentFrameTime - $store.lastFrameTime));
        }
    }
</script>

<div>FPS: {frameRate}</div>
