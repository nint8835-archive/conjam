<script lang="ts">
    import { store } from '../game';

    const propertyDescriptions: Record<number, string> = {
        16: 'Grows',
        23: 'Causes growth',
        24: 'Floats',
        32: 'Enable gravity',
    };

    let propertyValues = $store.brushColour.split('').map((v) => v === '1');

    store.subscribe((value) => {
        propertyValues = value.brushColour.split('').map((v) => v === '1');
    });

    $: {
        $store.brushColour = propertyValues.map((v) => (v ? '1' : '0')).join('');
    }
</script>

<div class="col-span-2 flex flex-col items-center">
    <h2 class="text-xl font-semibold">Pixel properties</h2>
    <div class="flex w-full gap-4 p-2">
        {#each Array(4) as _, groupIndex}
            <div class="flex flex-1 justify-between">
                {#each Array(8) as _, i}
                    <div class="flex flex-col items-center gap-2">
                        <input type="checkbox" bind:checked={propertyValues[8 * groupIndex + i]} />
                        <div style:writing-mode="vertical-lr">
                            {propertyDescriptions[8 * groupIndex + i + 1] || ''}
                        </div>
                    </div>
                {/each}
            </div>
        {/each}
    </div>
</div>
