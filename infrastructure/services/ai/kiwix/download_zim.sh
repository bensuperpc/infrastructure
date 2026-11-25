#!/bin/sh
# ZIM files, in /data, saved without their date. Already downloaded ones are kept: works offline.
set -eu

download() {
    name=$(basename "$1")
    zim=/data/${name%_*}.zim
    [ -f "$zim" ] && return
    wget -q -c -O "$zim.part" "https://download.kiwix.org/zim/$1.zim"
    mv "$zim.part" "$zim"
}

# devdocs: /data/devdocs_en_<name>.zim
for name in c cpp cmake gcc qt vulkan opengl gnu-make docker python pytest numpy git bash man \
    jq graphviz javascript markdown; do
    download "devdocs/devdocs_en_${name}_2026-10"
done

# Arch Wiki (37 MB), Wikipedia computing (490 MB)
download other/archlinux_en_all_maxi_2026-10
download wikipedia/wikipedia_en_computer_nopic_2026-09
# Q&A on shell and Linux (1.2 GB) and on code reviews (530 MB)
# download stack_exchange/unix.stackexchange.com_en_all_2026-10
# download stack_exchange/codereview.stackexchange.com_en_all_2026-10
# Electronics and embedded Q&A (4 GB)
# download stack_exchange/electronics.stackexchange.com_en_all_2026-10
