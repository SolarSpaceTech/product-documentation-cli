const { build } = require('esbuild');

build({
  entryPoints: ['src/cli/index.ts'],
  outfile: 'dist/cli.js',
  bundle: true,
  platform: 'node',
  format: 'cjs',
  target: ['node18'],
  sourcemap: false,
  minify: true,
}).catch(() => process.exit(1));
