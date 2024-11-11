VERSION=$1
ARCH=${2:-$(uname -m)}
OS="darwin"
EXT="tar.gz"
BUILD_DIR="build"
PLUGINS_DIR="plugins/mac"
RESULT_DIR="platforms/mac"

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

# Копируем Node.js и плагины
mv $NODE_DIR/bin/node $BUILD_DIR
if [ -d $PLUGINS_DIR ]; then
  cp -R $PLUGINS_DIR $BUILD_DIR/plugins
fi

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT"
tar -czf $ARCHIVE_NAME -C $BUILD_DIR .

# Создаем исполняемый файл-обертку
echo "Создаем исполняемый файл pd..."

cat << 'EOF' > run.sh
#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
BIN_DIR="$CURRENT_DIR/bin"
PLUGINS_DIR="plugins"
export PD_CONTENT_DIR="../content"

if [ ! -d $BIN_DIR ]; then
    echo "Директория bin не найдена. Создаю bin и распаковываю файлы..."
    mkdir -p "$BIN_DIR" "$CURRENT_DIR/$PLUGINS_DIR"
    tail -n +36 "$0" | tar -x -C $BIN_DIR
    mv "$BIN_DIR/$PLUGINS_DIR" "$CURRENT_DIR"
    mkdir "$BIN_DIR/$PLUGINS_DIR"
    echo "Файлы успешно распакованы"
fi

cd $CURRENT_DIR

if [ -d $CURRENT_DIR/$PLUGINS_DIR ]; then
    echo "Инициализация плагинов"
    for script in $CURRENT_DIR/$PLUGINS_DIR/*; do
        INSTALLED_PLUGIN_DIR="$BIN_DIR/$PLUGINS_DIR/$(basename $script)"
        if [ -d $INSTALLED_PLUGIN_DIR ]; then
            rm -rf $INSTALLED_PLUGIN_DIR
        fi

        if [ -f $script ]; then
            bash $script
        fi
    done
fi

echo "Запуск программы"
cd "$BIN_DIR"
exec ./node ./index.js
EOF

chmod +x run.sh

if [ ! -d $RESULT_DIR ]; then
  mkdir $RESULT_DIR
fi

# Формируем бинарный файл с помощью cat
cat run.sh $ARCHIVE_NAME > $RESULT_DIR/pd
chmod +x $RESULT_DIR/pd

# Очистка временных файлов
rm -rf $NODE_DIR $BUILD_DIR $FILE_NAME $ARCHIVE_NAME run.sh

echo "Бинарный файл 'pd' создан и готов к использованию."
echo "Запустите его командой: ./pd"
