import { fileURLToPath, URL } from 'node:url';
import vue from '@vitejs/plugin-vue';
import { defineConfig } from 'vite';
import vuetify from 'vite-plugin-vuetify';

export default defineConfig({
  root: fileURLToPath(new URL('../', import.meta.url)),
  base: '/TestesAutomatizadosERP/',
  plugins: [vue(), vuetify({ autoImport: true })],
  resolve: { alias: { '@': fileURLToPath(new URL('./app', import.meta.url)) } },
  cacheDir: fileURLToPath(new URL('./node_modules/.vite', import.meta.url)),
  build: { outDir: fileURLToPath(new URL('./.pages-output', import.meta.url)), emptyOutDir: true, target: 'es2022', chunkSizeWarningLimit: 1600 },
  server: { fs: { allow: [fileURLToPath(new URL('../', import.meta.url))] } }
});
