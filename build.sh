#!/bin/sh

set -eo pipefail
set +a

./pants resolve.ivy
./pants buildgen
git diff --exit-code || exit "$?"
./pants compile src:: test::
mkdir -p $TMPDIR/mongod-testdata
mongod --dbpath $TMPDIR/mongod-testdata &
./pants test test::
pkill mongod
