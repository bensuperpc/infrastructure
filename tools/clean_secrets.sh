#!/usr/bin/env bash
set -euo pipefail

find . -type f -path "*/env/*.env" -delete
