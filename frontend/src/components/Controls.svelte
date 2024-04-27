<script lang="ts">
    import { settingsStore } from '../game';
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
</div>
