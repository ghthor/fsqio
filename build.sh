#!/bin/sh

set -eo pipefail
set +a

./pants resolve.ivy
./pants buildgen
git diff --exit-code || exit "$?"
./pants compile src:: test::
mkdir -p /mongod-testdata
mongod --dbpath /mongod-testdata &
./pants test test::
pkill mongod
