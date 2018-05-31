#!/bin/bash
#
# Early version of a downloader/installer for Istio
#
# This file will be fetched as: curl -L https://git.io/getLatestIstio | sh -
# so it should be pure bourne shell, not bash (and not reference other scripts)
#
# The script fetches the latest Istio release candidate and untars it.
# It's a copy of ../downloadIstio.sh which is for stable releases but lets
# users do curl -L https://git.io/getLatestIstio | ISTIO_VERSION=0.3.6 sh -
# for instance to change the version fetched.

# This is the latest release candidate (matches ../istio.VERSION after basic
# sanity checks)

ISTIO_VERSION=${ISTIO_VERSION:-0.4.0}

NAME="istio-$ISTIO_VERSION"
OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  OSEXT="osx"
else
  # TODO we should check more/complain if not likely to work, etc...
  OSEXT="linux"
fi

#######CRI: Changing directory for consistency purposes:
cd $HOME

URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"
echo "Downloading $NAME from $URL ..."
curl -s -L "$URL" | tar xz
# TODO: change this so the version is in the tgz/directory name (users trying multiple versions)
echo "Downloaded into ${HOME}/$NAME:"
ls "${HOME}/$NAME"
BINDIR="$(cd ${HOME}/$NAME/bin; pwd)"
echo "Add $BINDIR to your path; e.g copy paste in your shell and/or ~/.profile:"
echo "export PATH=\"\$PATH:$BINDIR\""