import { svelte } from '@sveltejs/vite-plugin-svelte';
import type { UserConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';

export default {
    base: '/conjam/',
    plugins: [
        tsconfigPaths(),
        svelte(),
        {
            name: 'Reload Fix',
            handleHotUpdate({ server }) {
                server.hot.send({ type: 'full-reload' });
            },
        },
    ],
} satisfies UserConfig;
