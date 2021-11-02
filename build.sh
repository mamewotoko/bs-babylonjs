#! /bin/bash
mkdir -p js && npm run build
#sed -i "xxx" 's|"BABYLON"|"babylonjs/babylon.js"|' examples/main.bs.js
# sed -i "xxx" 's|\["MeshBuilder.CreateSphere"\]|.MeshBuilder.CreateSphere|' examples/main.bs.js
$(npm bin)/browserify -t babelify examples/main.bs.js > js/main.js
sed -ixxx 's|BabylonJs.CreateSphere|BabylonJs.MeshBuilder.CreateSphere|' js/main.js
