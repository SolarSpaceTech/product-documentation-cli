VERSION=$1
ARCH=${2:-$(uname -m)}

./util-builder/create-mac.sh $VERSION $ARCH
./util-builder/create-win.sh $VERSION $ARCH
