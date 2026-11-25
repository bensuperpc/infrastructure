---
name: Shell scripts
description: Write and check bash or sh scripts with shellcheck. Load for any shell script.
---

- Start with `#!/usr/bin/env bash` and `set -euo pipefail`. Quote every variable.
- Check every script with `shellcheck script.sh` and fix all warnings.
- More than about 100 lines, or data structures: write it in Python (`python` skill).
- Docs: ZIM files `/data/devdocs_en_bash.zim` (Bash manual) and `/data/devdocs_en_man.zim` (man pages of commands and system calls), `/data/devdocs_en_jq.zim` (jq manual).
