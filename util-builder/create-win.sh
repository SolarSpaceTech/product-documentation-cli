VERSION=$1
ARCH=${2:-$(uname -m)}
OS="win"
EXT="zip"
BUILD_DIR="build"
PLUGINS_DIR="plugins/$OS"
RESULT_DIR="platforms/$OS"

# Копируем плагины
if [ -d $PLUGINS_DIR ]; then
  cp -R $PLUGINS_DIR $BUILD_DIR/plugins
fi

# Создаем архив с содержимым сборки
ARCHIVE_NAME="node_bundle.$EXT.b64"
cd $BUILD_DIR && zip -r - . | base64 -o ../$ARCHIVE_NAME && cd ../

echo "Создаем исполняемый файл pd..."

BROWSER_ARCH="64"
if [[ $ARCH == "x86" ]]; then
  BROWSER_ARCH="32"
fi

case "$ARCH" in
  x64 | x86 | arm64) ;;  # Допустимые архитектуры
  x86_64) ARCH="x64" ;;
  i686) ARCH="x86" ;;
  aarch64) ARCH="arm64" ;;
  *)
    echo "Ошибка: неподдерживаемая архитектура '$ARCH'."
    exit 1
    ;;
esac

cat << EOF > run.bat
@echo off

cd %~dp0

set "VERSION=$VERSION"
set "OS=$OS"
set "ARCH=$ARCH"
set "BROWSER_ARCH=$BROWSER_ARCH"
set "EXT=$EXT"

set "CHROMIUM_VERSION=131.0.6778.85"
set "BIN_DIR=bin"
set "INSTRUCTION_FILE=README.md"
set "PLUGINS_DIR=plugins"
set "NODE_DIR=node"
set "TEMP_NODE_DIR=node-v%VERSION%-%OS%-%ARCH%"
set "NODE_ARCHIVE=%TEMP_NODE_DIR%.%EXT%"
set "NODE_DOWNLOAD_URL=https://nodejs.org/dist/v%VERSION%/%NODE_ARCHIVE%"
set "CHROMIUM=chrome-headless-shell"
set "CHROMIUM_DIR=browser"
set "TEMP_CHROMIUM_DIR=%CHROMIUM%-win%BROWSER_ARCH%"
set "CHROMIUM_ARCHIVE=%TEMP_CHROMIUM_DIR%.zip"
set "CHROMIUM_DOWNLOAD_URL=https://storage.googleapis.com/chrome-for-testing-public/%CHROMIUM_VERSION%/win%BROWSER_ARCH%/%CHROMIUM_ARCHIVE%"
set "PD_CONTENT_DIR=../content"
set "PD_BROWSER_PATH=./browser/chrome-headless-shell.exe"
set "PD_PDF_DOC=../solar-space-doc.pdf"
set "PD_BOOK_CONFIG_DIR=./plugins/client/frontend/browser/book-configs"

set "ENCODED_ARCHIVE=%BIN_DIR%.b64"
set "DECODED_ARCHIVE=%BIN_DIR%.zip"

if not exist "%BIN_DIR%" (
    echo Directory bin not found. Creating bin and extracting files...

    more +81 "%~f0" > %ENCODED_ARCHIVE%
    powershell -command "([System.IO.File]::WriteAllBytes('%DECODED_ARCHIVE%', [System.Convert]::FromBase64String((Get-Content -Path '%ENCODED_ARCHIVE%' -Raw))))"
    powershell -command "Expand-Archive -Path %DECODED_ARCHIVE% -DestinationPath %BIN_DIR%"
    move %BIN_DIR%\%PLUGINS_DIR% %cd%
    move %BIN_DIR%\%INSTRUCTION_FILE% %cd%
    mkdir %BIN_DIR%\%PLUGINS_DIR%
    del %ENCODED_ARCHIVE% %DECODED_ARCHIVE%

    echo Downloading Node.js from %NODE_DOWNLOAD_URL%
    powershell -Command "try { Invoke-WebRequest -Uri '%NODE_DOWNLOAD_URL%' -OutFile '%NODE_ARCHIVE%' -ErrorAction Stop } catch { exit 1 }"
    echo Extracting Node.js from %NODE_ARCHIVE%
    powershell -Command "try { Expand-Archive -Path '%NODE_ARCHIVE%' -DestinationPath '.' -ErrorAction Stop } catch { exit 1 }"
    move %TEMP_NODE_DIR% %BIN_DIR%\%NODE_DIR%
    del %NODE_ARCHIVE%

    echo Downloading %CHROMIUM% from %CHROMIUM_DOWNLOAD_URL%
    powershell -Command "try { Invoke-WebRequest -Uri '%CHROMIUM_DOWNLOAD_URL%' -OutFile '%CHROMIUM_ARCHIVE%' -ErrorAction Stop } catch { exit 1 }"
    echo Extracting %CHROMIUM% from %CHROMIUM_ARCHIVE%
    powershell -Command "try { Expand-Archive -Path '%CHROMIUM_ARCHIVE%' -DestinationPath '.' -ErrorAction Stop } catch { exit 1 }"
    move %TEMP_CHROMIUM_DIR% %BIN_DIR%\%CHROMIUM_DIR%
    del %CHROMIUM_ARCHIVE%

    echo Files successfully extracted to bin.
)

if exist "%cd%\%PLUGINS_DIR%" (
    echo Plugins initialization

    for %%f in ("%cd%\%PLUGINS_DIR%\*") do (
        if exist "%cd%\%BIN_DIR%\%PLUGINS_DIR%\%%~nf" (
            rmdir /s /q "%cd%\%BIN_DIR%\%PLUGINS_DIR%\%%~nf"
        )

    	  cmd /c "%%f"
        if errorlevel 1 (
            echo Ошибка в %%f
        )
    )
)

echo Starting the program

cd .\%BIN_DIR%

.\%NODE_DIR%\node.exe .\index.js

exit /b
EOF

if [ ! -d $RESULT_DIR ]; then
  mkdir $RESULT_DIR
fi

cat run.bat $ARCHIVE_NAME > $RESULT_DIR/pd.bat

rm -rf run.bat $ARCHIVE_NAME $BUILD_DIR/node.exe $BUILD_DIR/plugins $BUILD_DIR/$INSTRUCTION_FILE $FILE_NAME $NODE_DIR

echo "Бинарный файл 'pd.bat' создан и готов к использованию."
echo "Запустите его командой: ./pd.bat"

