import type { UserConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';

export default {
    base: '/conjam/',
    plugins: [tsconfigPaths()],
} satisfies UserConfig;
