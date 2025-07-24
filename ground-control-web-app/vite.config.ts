import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig, loadEnv } from 'vite';

export default defineConfig(({
	mode
}) => {
	const env = loadEnv(mode, process.cwd(), '');
	return {
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
		define: {
			'import.meta.env.VITE_MQTT_BROKER_URL': JSON.stringify(env.MQTT_BROKER_URL)
		}
	}
});
