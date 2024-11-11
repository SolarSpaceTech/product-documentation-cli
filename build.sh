#!/bin/bash

# Проверка наличия версии
if [ -z "$1" ]; then
  echo "Использование: $0 <версия-nodejs> [операционная_система] [архитектура]"
  echo "Пример: $0 18.18.0 win x64"
  exit 1
fi

# Присваиваем значения переменным из аргументов или определяем их автоматически
VERSION=$1
OS=${2:-$(uname | tr '[:upper:]' '[:lower:]')}
ARCH=${3:-$(uname -m)}

# Проверка корректности операционной системы
if [[ $OS != "all" && $OS != "mac" && $OS != "win" ]]; then
  echo "Ошибка: неподдерживаемая операционная система '$OS'."
  exit 1
fi

# Приведение архитектуры к допустимому формату
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

BUILD_DIR="build"
UTIL_FILE="index.js"
ESBUILD_CONFIG_FILE="esbuild.js"
RESULT_DIR="platforms"
echo "Сборка CLI утилиты..."

if ! node $ESBUILD_CONFIG_FILE "$BUILD_DIR/$UTIL_FILE"; then
  echo "Ошибка: не удалось собрать утилиту."
  exit 1
fi

if [ ! -d $RESULT_DIR ]; then
  mkdir $RESULT_DIR
fi

./util-builder/create-$OS.sh $VERSION $ARCH
