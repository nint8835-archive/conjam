<script lang="ts">
    import { settingsStore, tickFrame } from '../game';

    function insertNoise() {
        const canvas = document.getElementById('canvas')! as HTMLCanvasElement;
        const ctx = canvas.getContext('2d')!;
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

        const colours = [
            [255, 0, 0, 0],
            [0, 255, 0],
            [0, 0, 255],
        ];

        for (let i = 0; i < imageData.data.length; i += 4) {
            if (imageData.data[i + 3]) {
                continue;
            }

            const [r, g, b] = colours[Math.floor(Math.random() * colours.length)];

            imageData.data[i] = r;
            imageData.data[i + 1] = g;
            imageData.data[i + 2] = b;
            imageData.data[i + 3] = 255;
        }

        ctx.putImageData(imageData, 0, 0);
    }

    function clearCanvas() {
        const canvas = document.getElementById('canvas')! as HTMLCanvasElement;
        const ctx = canvas.getContext('2d')!;

        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
</script>

<div class="grid grid-cols-2 gap-2 rounded-b-lg bg-slate-950 p-4">
    <label class="flex flex-row items-center justify-between">
        Brush size:
        <input
            class="rounded-md bg-slate-900 p-2 outline-none ring-teal-600 transition-all focus:ring-2"
            type="number"
            min="0"
            max="50"
            step="1"
            bind:value={$settingsStore.brushSize}
        />
    </label>
    <label class="flex flex-row items-center justify-between">
        Brush colour:
        <input
            class="rounded-md bg-slate-900 p-2 outline-none ring-teal-600 transition-all focus:ring-2"
            type="color"
            bind:value={$settingsStore.brushColour}
        />
    </label>
    <button class="rounded-md bg-teal-600 p-2 transition-colors hover:bg-teal-700" on:click={insertNoise}>
        Insert noise
    </button>
    <button class="rounded-md bg-teal-600 p-2 transition-colors hover:bg-teal-700" on:click={clearCanvas}>
        Clear canvas
    </button>
    <label class="flex flex-row items-center justify-between">
        Auto tick:
        <input
            class="rounded-md bg-slate-900 p-2 outline-none ring-teal-600 transition-all focus:ring-2"
            type="checkbox"
            bind:checked={$settingsStore.autoTick}
        />
    </label>
    <button class="rounded-md bg-teal-600 p-2 transition-colors hover:bg-teal-700" on:click={tickFrame}>
        Tick frame
    </button>
</div>
