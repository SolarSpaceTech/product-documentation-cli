VERSION=$1
ARCH=${2:-$(uname -m)}
OS="win"
EXT="zip"
BUILD_DIR="build"
PLUGINS_DIR="plugins/$OS"
RESULT_DIR="platforms/$OS"
INSTRUCTION_DIR="instructions/win"
INSTRUCTION_FILE="README.md"

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

# Копируем Node.js и плагины
mv $NODE_DIR/node.exe $BUILD_DIR
cp $INSTRUCTION_DIR/$INSTRUCTION_FILE $BUILD_DIR
if [ -d $PLUGINS_DIR ]; then
  cp -R $PLUGINS_DIR $BUILD_DIR/plugins
fi

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT.b64"
cd $BUILD_DIR && zip -r - . | base64 -o ../$ARCHIVE_NAME && cd ../

cat << 'EOF' > run.bat
@echo off

set "OUT=bin"
set "ENCODED_ARCHIVE=%OUT%.b64"
set "DECODED_ARCHIVE=%OUT%.zip"
set "INSTRUCTION_FILE=README.md"
set "PLUGINS_DIR=plugins"
set "PD_CONTENT_DIR=../content"

cd %~dp0

if not exist "%OUT%" (
    @echo on
    echo Directory bin not found. Creating bin and extracting files...
    @echo off

    more +54 "%~f0" > %ENCODED_ARCHIVE%
    powershell -command "([System.IO.File]::WriteAllBytes('%DECODED_ARCHIVE%', [System.Convert]::FromBase64String((Get-Content -Path '%ENCODED_ARCHIVE%' -Raw))))"
    powershell -command "Expand-Archive -Path %DECODED_ARCHIVE% -DestinationPath %OUT%"
    move %OUT%\%PLUGINS_DIR% %cd%
    move %OUT%\%INSTRUCTION_FILE% %cd%
    mkdir %OUT%\%PLUGINS_DIR%
    del %ENCODED_ARCHIVE% %DECODED_ARCHIVE%

    @echo on
    echo Files successfully extracted to bin.
    @echo off
)

if exist "%cd%\%PLUGINS_DIR%" (
    @echo on
    echo Plugins initialization
    @echo off

    for %%f in ("%cd%\%PLUGINS_DIR%\*") do (
        if exist "%cd%\%OUT%\%PLUGINS_DIR%\%%~nf" (
            rmdir /s /q "%cd%\%OUT%\%PLUGINS_DIR%\%%~nf"
        )

    	  cmd /c "%%f"
        if errorlevel 1 (
            echo Ошибка в %%f
        )
    )
)

@echo on
echo Starting the program
@echo off

cd .\%OUT%\
.\node.exe .\index.js

exit /b
EOF

if [ ! -d $RESULT_DIR ]; then
  mkdir $RESULT_DIR
fi

cat run.bat $ARCHIVE_NAME > $RESULT_DIR/pd.bat

rm -rf run.bat $ARCHIVE_NAME $BUILD_DIR/node.exe $BUILD_DIR/plugins $BUILD_DIR/$INSTRUCTION_FILE $FILE_NAME $NODE_DIR

echo "Бинарный файл 'pd.bat' создан и готов к использованию."
echo "Запустите его командой: ./pd.bat"

