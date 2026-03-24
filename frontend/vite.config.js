import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [
    react({
      // Ativar Fast Refresh
      fastRefresh: true,
    }),
    // Opcional: instale com: npm install rollup-plugin-visualizer --save-dev
    // import { visualizer } from 'rollup-plugin-visualizer'
    // visualizer({ open: false, gzipSize: true }),
  ],

  resolve: {
    alias: {
      // Aliases para imports mais limpos
      '@': path.resolve(__dirname, './src'),
      '@components': path.resolve(__dirname, './src/components'),
      '@pages': path.resolve(__dirname, './src/pages'),
      '@services': path.resolve(__dirname, './src/services'),
      '@contexts': path.resolve(__dirname, './src/contexts'),
      '@hooks': path.resolve(__dirname, './src/hooks'),
      '@styles': path.resolve(__dirname, './src/styles'),
      '@constants': path.resolve(__dirname, './src/constants'),
    },
  },

  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
        rewrite: (path) => path,
      },
    },
    // Melhora performance em desenvolvimento
    middlewareMode: false,
    cors: true,
  },

  build: {
    // Otimização de bundle
    target: 'esnext',
    minify: 'esbuild',

    // Rollup options
    rollupOptions: {
      output: {
        // Code splitting para melhor cache
        manualChunks: {
          'vendor': ['react', 'react-dom', 'react-router-dom'],
          'ui': ['recharts', 'react-icons', 'react-transition-group'],
          'api': ['axios'],
        },
        // Otimizar tamanho dos chunks
        chunkFileNames: 'chunks/[name]-[hash].js',
        entryFileNames: '[name]-[hash].js',
        assetFileNames: 'assets/[name]-[hash][extname]',
      },
    },

    // Aumentar limite de chunk warning
    chunkSizeWarningLimit: 500,

    // Source maps em modo de staging
    sourcemap: process.env.NODE_ENV === 'staging',
  },

  // Otimizações de dependências
  optimizeDeps: {
    include: [
      'react',
      'react-dom',
      'react-router-dom',
      'axios',
      'recharts',
      'react-icons',
      'react-transition-group',
    ],
    // Exclude bundled dependencies
    exclude: ['@vite/preload-helper'],
  },

  // Environment variables
  define: {
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
  },
})
