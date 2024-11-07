# Присваиваем значения переменным из аргументов или определяем их автоматически
VERSION=$1
ARCH=${2:-$(uname -m)}
OS="darwin"
EXT="tar.gz"
BUILD_DIR="build"
UTIL_FILE="index.js"

ESBUILD_CONFIG_FILE="esbuild.js"
echo "Сборка CLI утилиты..."

if ! node $ESBUILD_CONFIG_FILE "$BUILD_DIR/$UTIL_FILE"; then
  echo "Ошибка: не удалось собрать утилиту."
  exit 1
fi

# Сформировать URL для скачивания
DOWNLOAD_URL="https://nodejs.org/dist/v$VERSION/node-v$VERSION-$OS-$ARCH.$EXT"

# Скачивание архива
echo "Скачивание Node.js версии $VERSION для $OS-$ARCH..."
if ! curl -O "$DOWNLOAD_URL"; then
  echo "Ошибка: не удалось скачать Node.js."
  exit 1
fi

# Распаковка архива
FILE_NAME="node-v$VERSION-$OS-$ARCH.$EXT"
echo "Распаковка $FILE_NAME..."
tar -xzf $FILE_NAME -C .

NODE_DIR="node-v$VERSION-$OS-$ARCH"

# Копируем Node.js
mv $NODE_DIR/bin/node $BUILD_DIR

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT"
tar -czf $ARCHIVE_NAME -C $BUILD_DIR .

# Создаем исполняемый файл-обертку
echo "Создаем исполняемый файл pd..."

cat << 'EOF' > run.sh
#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
TEMP_DIR="$temp"
BIN_DIR="bin"
PLUGINS_DIR="plugins"
export PD_CONTENT_DIR="../content"

if [ ! -d $BIN_DIR ]; then
    echo "Директория bin не найдена. Создаю bin и распаковываю файлы..."
    mkdir -p "$CURRENT_DIR$TEMP_DIR" "$CURRENT_DIR$BIN_DIR" "$CURRENT_DIR$PLUGINS_DIR"
    tail -n +21 "$0" | tar -x -C "$CURRENT_DIR$TEMP_DIR"
    mv "$CURRENT_DIR$TEMP_DIR/$PLUGINS_DIR" "$CURRENT_DIR$PLUGINS_DIR"
    mv "$CURRENT_DIR$TEMP_DIR" "$CURRENT_DIR$BIN_DIR"
    echo "Файлы успешно распакованы"
fi

echo "Запуск программы"
cd "$CURRENT_DIR$BIN_DIR"
exec ./node ./index.js
EOF

chmod +x run.sh

# Формируем бинарный файл с помощью cat
cat run.sh $ARCHIVE_NAME > pd
chmod +x pd

# Очистка временных файлов
rm -rf $NODE_DIR $BUILD_DIR $FILE_NAME $ARCHIVE_NAME run.sh

echo "Бинарный файл 'pd' создан и готов к использованию."
echo "Запустите его командой: ./pd"
