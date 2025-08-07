VERSION=$1
ARCH=${2:-$(uname -m)}
OS="darwin"
EXT="tar.gz"
BUILD_DIR="build"
PLUGINS_DIR="plugins/mac"
RESULT_DIR="platforms/mac"

# Копируем плагины
if [ -d $PLUGINS_DIR ]; then
  cp -R $PLUGINS_DIR $BUILD_DIR/plugins
fi

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT"
tar -czf $ARCHIVE_NAME -C $BUILD_DIR .

echo "Создаем исполняемый файл pd..."

cat << 'EOF' > run.sh
#!/bin/bash

cd $(dirname "$(readlink -f "$0")")

EOF

cat << EOF >> run.sh
VERSION=$VERSION
OS=$OS
ARCH=$ARCH
EXT=$EXT
EOF

cat << 'EOF' >> run.sh
CHROMIUM_VERSION="131.0.6778.85"
BIN_DIR="bin"
INSTRUCTION_FILE="README.md"
PLUGINS_DIR="plugins"
NODE_DIR="node"
TEMP_NODE_DIR="node-v$VERSION-$OS-$ARCH"
NODE_ARCHIVE="$TEMP_NODE_DIR.$EXT"
DOWNLOAD_URL="https://nodejs.org/dist/v$VERSION/$NODE_ARCHIVE"
CHROMIUM="chrome-headless-shell"
CHROMIUM_DIR="browser"
TEMP_CHROMIUM_DIR="$CHROMIUM-mac-$ARCH"
CHROMIUM_ARCHIVE="$TEMP_CHROMIUM_DIR.zip"
CHROMIUM_DOWNLOAD_URL="https://storage.googleapis.com/chrome-for-testing-public/$CHROMIUM_VERSION/mac-$ARCH/$CHROMIUM_ARCHIVE"
export PD_CONTENT_DIR="../content"
export PD_BROWSER_PATH="./browser/chrome-headless-shell"
export PD_PDF_DOC="../solar-space-doc.pdf"
export PD_BOOK_CONFIG_DIR="./plugins/client/frontend/browser/book-configs"
export PD_WHITE_LABELS_DIR_PATH="../white-label"
export IAM_SERVICE_DOMAIN="https://iam.solarspace.pro"

# Скачивание архива
echo "Скачивание Node.js версии $VERSION для $OS-$ARCH..."

if [ ! -d $BIN_DIR ]; then
    echo "Директория bin не найдена. Создаю bin и распаковываю файлы..."
    mkdir -p $BIN_DIR $PLUGINS_DIR

    if ! curl -O "$DOWNLOAD_URL"; then
      echo "Ошибка: не удалось скачать Node.js."
      exit 1
    fi

    # Распаковка архива
    echo "Распаковка $NODE_ARCHIVE..."
    tar -xzf $NODE_ARCHIVE -C .

    # Копируем Node.js
    mv $TEMP_NODE_DIR $BIN_DIR/$NODE_DIR
    rm -r $NODE_ARCHIVE

    if ! curl -O $CHROMIUM_DOWNLOAD_URL; then
      echo "Ошибка: не удалось скачать Chromium."
      exit 1
    fi

    # Распаковка архива
    echo "Распаковка $CHROMIUM_ARCHIVE..."
    unzip $CHROMIUM_ARCHIVE -d .
    mv $TEMP_CHROMIUM_DIR $BIN_DIR/$CHROMIUM_DIR
    rm -r $CHROMIUM_ARCHIVE

    README_URL="https://raw.githubusercontent.com/SolarSpaceTech/product-documentation-help/refs/heads/main/ru/util/instruction/mac.md"
    counter=0
    curl -s $README_URL | while IFS= read -r line; do
        if [[ $counter -ge 2 ]]; then
            echo $line >> $INSTRUCTION_FILE
        fi

        if [[ $line =~ ---[[:space:]]*$ ]]; then
            ((counter++))
        fi
    done

    tail -n +95 "$0" | tar -x -C $BIN_DIR
    mv "$BIN_DIR/$PLUGINS_DIR" .
    mkdir "$BIN_DIR/$PLUGINS_DIR"
    echo "Файлы успешно распакованы"
fi

if [ -d $PLUGINS_DIR ]; then
    echo "Инициализация плагинов"
    for script in $PLUGINS_DIR/*; do
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
exec ./$NODE_DIR/bin/node ./index.js
EOF

chmod +x run.sh

if [ ! -d $RESULT_DIR ]; then
  mkdir $RESULT_DIR
fi

# Формируем бинарный файл с помощью cat
cat run.sh $ARCHIVE_NAME > $RESULT_DIR/pd
chmod +x $RESULT_DIR/pd

# Очистка временных файлов
rm -rf $NODE_DIR $BUILD_DIR/node $BUILD_DIR/plugins $BUILD_DIR/$INSTRUCTION_FILE $ARCHIVE_NAME run.sh

echo "Бинарный файл 'pd' создан и готов к использованию."
echo "Запустите его командой: ./pd"
