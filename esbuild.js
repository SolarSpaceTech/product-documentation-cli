const { build } = require('esbuild');

build({
  entryPoints: ['src/cli/index.ts'],
  outfile: process.argv[2] ?? 'dist/cli.js',
  bundle: true,
  platform: 'node',
  format: 'cjs',
  target: ['node18'],
  sourcemap: false,
  minify: true,
}).catch(() => process.exit(1));
