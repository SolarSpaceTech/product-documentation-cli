# Присваиваем значения переменным из аргументов или определяем их автоматически
VERSION=$1
ARCH=${2:-$(uname -m)}
OS="win"
EXT="zip"
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
unzip $FILE_NAME -d .

NODE_DIR="node-v$VERSION-$OS-$ARCH"

# Копируем Node.js и index.js в папку сборки
mv $NODE_DIR/node.exe $BUILD_DIR

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT.b64"
zip -r - $BUILD_DIR | base64 -o $ARCHIVE_NAME

cat << 'EOF' > run.bat
@echo off

set "ENCODED_ARCHIVE=archive.b64"
set "DECODED_ARCHIVE=archive.zip"
set "TEMP_DIR=temp"
set "OUT=bin"
set "PD_CONTENT_DIR=../content"
set "PD_PLUGINS_DIR=../plugins"

cd %~dp0

if not exist "%OUT%" (
    @echo on
    echo Directory bin not found. Creating bin and extracting files...
    @echo off

    more +35 "%~f0" > %ENCODED_ARCHIVE%
    powershell -command "([System.IO.File]::WriteAllBytes('%DECODED_ARCHIVE%', [System.Convert]::FromBase64String((Get-Content -Path '%ENCODED_ARCHIVE%' -Raw))))"
    powershell -command "Expand-Archive -Path %DECODED_ARCHIVE% -DestinationPath %TEMP_DIR%"
    move %TEMP_DIR%/build %OUT%
    del %TEMP_DIR% %ENCODED_ARCHIVE% %DECODED_ARCHIVE%

    @echo on
    echo Files successfully extracted to bin.
    @echo off
)

@echo on
echo Starting the program
@echo off

cd .\%OUT%\
.\node.exe .\index.js

exit /b
EOF

cat run.bat $ARCHIVE_NAME > pd.bat

rm -rf run.bat $ARCHIVE_NAME $BUILD_DIR $FILE_NAME $NODE_DIR

echo "Бинарный файл 'pd.bat' создан и готов к использованию."
echo "Запустите его командой: ./pd.bat"

