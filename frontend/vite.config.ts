import type { UserConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default {
    base: '/conjam/',
    plugins: [tsconfigPaths(), svelte()],
} satisfies UserConfig;
