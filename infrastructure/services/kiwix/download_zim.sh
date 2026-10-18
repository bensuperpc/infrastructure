#!/bin/sh
# devdocs ZIM files, in /data. Already downloaded ones are kept: works offline.
set -eu

ZIM_DATE=2026-10
for name in c cpp cmake gcc qt vulkan opengl gnu-make docker python pytest numpy git bash man; do
    zim=/data/devdocs_en_$name.zim
    [ -f "$zim" ] && continue
    wget -q -c -O "$zim.part" "https://download.kiwix.org/zim/devdocs/devdocs_en_${name}_$ZIM_DATE.zim"
    mv "$zim.part" "$zim"
done
