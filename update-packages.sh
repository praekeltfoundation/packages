#!/bin/bash -e

VARLIB=${VARLIB:-$HOME/packages-lib}
VARCACHE=${VARCACHE:-$HOME/packages-cache}
GPG=${GPG:?Please set the GPG envvar.}

cat > ~/freight.packages.conf <<EOF
VARLIB=${VARLIB}
VARCACHE=${VARCACHE}
GPG=${GPG}
EOF

PACKAGES=${PACKAGES:-$HOME/packages}
SIG_ARGS=${SIG_ARGS:-}


rm -rf $VARLIB $VARCACHE

for pkg in $PACKAGES/pool/main/*/*/*; do
    if dpkg-sig -l $pkg | grep '^builder$' > /dev/null; then
        echo "$pkg is already signed"
    else
        dpkg-sig --sign builder $SIG_ARGS $pkg
    fi
    freight add -c ~/freight.packages.conf $pkg apt/jessie apt/trusty
done

freight cache -c ~/freight.packages.conf

pushd $PACKAGES
mkdir -p pool/{trusty,jessie}
ln -sf ../main pool/trusty/
ln -sf ../main pool/jessie/
cp -a $VARCACHE/dists/trusty/* dists/trusty/
cp -a $VARCACHE/dists/jessie/* dists/jessie/
popd
