#!/bin/bash

VERSION=$1
ARCH=${2:-$(uname -m)}
OS="linux"
EXT="tar.gz"
BUILD_DIR="build"
RESULT_DIR="platforms/$OS"
ARCHIVE_NAME="node_bundle.$EXT"

set -e

echo "Сборка CLI для Linux ($VERSION, $ARCH)..."

mkdir -p "$RESULT_DIR/bin"

# Упаковка архива
tar -czf "$RESULT_DIR/$ARCHIVE_NAME" -C "$BUILD_DIR" .

# Генерация pd
cat <<EOF > "$RESULT_DIR/pd"
#!/bin/bash
SCRIPT_DIR=\$(cd \$(dirname "\$0") && pwd)
node "\$SCRIPT_DIR/bin/index.js" "\$@"
EOF

chmod +x "$RESULT_DIR/pd"

# Копируем index.js
cp "$BUILD_DIR/index.js" "$RESULT_DIR/bin/index.js"

echo "pd готов: $RESULT_DIR/pd"

