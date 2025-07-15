import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [sveltekit()],
	server: {
		port: 8080
	},
	build: {
		assetsDir: '_app',
		rollupOptions: {
			output: {
				entryFileNames: '_app/immutable/entry/[name].js',
				chunkFileNames: '_app/immutable/chunks/[name].js',
				assetFileNames: '_app/immutable/assets/[name].[ext]',
			},
		},
	},
});
