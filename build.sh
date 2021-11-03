#! /bin/bash
mkdir -p js && npm run build
$(npm bin)/browserify -t babelify examples/main.bs.js > js/main.js
