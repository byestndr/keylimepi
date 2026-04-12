#!/bin/bash
if [ ! -f "./pubspec.yaml" ]; then
    echo "Run this script on the project root"
    exit 1
fi

if ! command -v flutterpi_tool &> /dev/null; then
    echo "Missing flutterpi_tool, install it or make sure it's in your path."
    exit 1
fi

rm -rf ./build/flutter-pi/pi4-64

flutterpi_tool build --cpu=pi4 --arch=arm64 --release
echo "Changing into bundle directory"
cd ./build/flutter-pi/pi4-64

echo "Creating directories"
mkdir data && mkdir lib

echo "Moving libraries"
mv ./app.so ./lib/libapp.so
mv ./libflutter_engine.so ./lib/
rm ./flutter-pi

for file in *; do
    if [[ "$file" != "data" && "$file" != "lib" ]]; then
        mv "$file" ./data
    fi
done

cd ./data
mkdir flutter_assets

for file in *; do
    if [[ "$file" != "icudtl.dat" && "$file" != "flutter_assets" ]]; then
        mv "$file" ./flutter_assets
    fi
done

echo "Done"
exit 0