<script lang="ts">
    import { store } from '../game';

    const propertyDescriptions: Record<number, string> = {
        16: 'Grows',
        22: 'Fluid',
        23: 'Causes growth',
        24: 'Floats',
        32: 'Enable gravity',
    };
</script>

<div class="col-span-2 flex flex-col items-center">
    <h2 class="text-xl font-semibold">Pixel properties</h2>
    <div class="flex w-full gap-4 p-2">
        {#each Array(4) as _, groupIndex}
            <div class="flex flex-1 justify-between">
                {#each Array(8) as _, i}
                    {@const index = 8 * groupIndex + i}
                    {@const checked = $store.brushColour[index] === '1'}
                    <div class="flex flex-col items-center gap-2">
                        <input
                            type="checkbox"
                            {checked}
                            on:change={() => {
                                const arr = $store.brushColour.split('');
                                arr[index] = checked ? '0' : '1';
                                $store.brushColour = arr.join('');
                            }}
                        />
                        <div style:writing-mode="vertical-lr">
                            {propertyDescriptions[index] || ''}
                        </div>
                    </div>
                {/each}
            </div>
        {/each}
    </div>
</div>
