#!/bin/bash
# 21/12/09 using for testing control panel in Testing Machine Environment.
dir="$HOME/workspace/testbuild/bin/"
echo $dir

export LD_LIBRARY_PATH=$dir/../lib:$dir/../lib/vtk
export QT_PLUGIN_PATH=$dir/../lib
export QML2_IMPORT_PATH=$dir/qml
echo ${QML2_IMPORT_PATH}

./controlpanelNewLayout
