#! /bin/bash
mkdir -p js && npm run build
cp examples/lib.js js
$(npm bin)/browserify -t babelify examples/main.bs.js > js/main.js
