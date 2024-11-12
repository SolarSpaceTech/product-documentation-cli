# product-documentation-cli
Для того чтобы собрать утилиту под разные операционные системы можно использовать скрипт:
```bash
./build.sh [NODE_JS_VERSION] [OS] [ARCH]
```
где 
- `NODE_JS_VERSION` версия NodeJS, например `22.10.0`
- `OS` операционная система (`win`, `linux`, `mac`)
- `ARCH` архитектура процессора (`x64`, `x86`, `arm64`) 

Пример запуска сборки для Windows:
```bash
./build.sh 22.10.0 win x64
```

Пример запуска сборки для MacOS:
```bash
./build.sh 22.10.0 mac x64
```

Пример запуска сборки для Linux:
```bash
./build.sh 22.10.0 linux x64
```
