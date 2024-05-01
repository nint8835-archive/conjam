<script lang="ts">
    import { twMerge } from 'tailwind-merge';
    import { store } from '../game';

    const selectableElements = {
        Eraser: 0x00000000,
        Sand: 0xffd880ff,
        Water: 0x0000ffff,
        Plant: 0x00ff00ff,
        Wall: 0x808080fe,
    };

    function toHex(value: number): string {
        return value.toString(16).padStart(8, '0');
    }

    function toBinary(value: number): string {
        return value.toString(2).padStart(32, '0');
    }

    function computeTextColour(value: number): string {
        const r = (value & 0xff000000) >> 24;
        const g = (value & 0x00ff0000) >> 16;
        const b = (value & 0x0000ff00) >> 8;

        // https://graphicdesign.stackexchange.com/a/17562
        const gamma = 2.2;
        return 0.2126 * Math.pow(r, gamma) + 0.7152 * Math.pow(g, gamma) + 0.0722 * Math.pow(b, gamma) > 0.5
            ? 'black'
            : 'white';
    }
</script>

<div class="h-full rounded-r-lg bg-zinc-950">
    {#each Object.entries(selectableElements) as [name, value]}
        <button
            class={twMerge(
                'w-full p-2 text-xl font-semibold transition-all hover:opacity-75',
                $store.brushColour === toBinary(value) && 'font-black',
            )}
            style:background-color={'#' + toHex(value)}
            style:color={computeTextColour(value)}
            on:click={() => {
                $store.brushColour = toBinary(value);
            }}
        >
            {name}
        </button>
    {/each}
</div>
