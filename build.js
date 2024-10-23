const esbuild = require('esbuild');

esbuild.build({
    entryPoints: ['./src/cli/index.ts'], // Входной файл
    outfile: './dist/index.js',      // Выходной файл
    bundle: true,                    // Собрать все в один файл
    platform: 'node',                // Платформа: Node.js
    format: 'cjs',                   // Формат модуля: CommonJS
    target: ['node18'],              // Целевая версия Node.js
    sourcemap: true,                 // Генерация sourcemap для отладки
    tsconfig: './tsconfig.json', // Путь к tsconfig.json (опционально)
}).catch(() => process.exit(1));
