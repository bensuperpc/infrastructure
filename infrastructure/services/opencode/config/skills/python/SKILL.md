---
name: Python
description: Write, test, format, and type-check Python 3 scripts and packages.
---

Python 3.13. No internet: `pip install` fails. Installed: pytest, numpy, black, mypy, OpenCV (`cv2`), protobuf.

- Virtual environment that keeps the installed packages: `python3 -m venv --system-site-packages .venv`.
- Scripts: `#!/usr/bin/env python3`, a `main()` called under `if __name__ == "__main__":`, `argparse` for options, `pathlib` for paths, `subprocess.run([...], check=True)` for commands.
- Tests: `python3 -m pytest -q`, in `test_*.py` files with plain `assert`. Useful fixtures: `tmp_path`, `monkeypatch`, `capsys`; parameters with `@pytest.mark.parametrize`.
- Format: `black .`. Types: `mypy --strict file.py` on new code.
- Dependencies: list them in `pyproject.toml` or `requirements.txt`, but only use what is installed here.

## Docs

ZIM files `/data/devdocs_en_python.zim`, `/data/devdocs_en_pytest.zim`, `/data/devdocs_en_numpy.zim`.
