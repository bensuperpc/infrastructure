#!/usr/bin/env python3

from pathlib import Path
import secrets
import re

ROOT_DIR = Path(__file__).resolve().parent.parent
SERVICES_DIR = ROOT_DIR / "infrastructure"

# Exemples :
# __GENERATE_32__ -> 32 caractères
# __GENERATE_64__ -> 64 caractères
TOKEN_RE = re.compile(r"__GENERATE_(\d+)__")

CHANGE_ME = "CHANGEME_"
ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

created = 0
skipped = 0


def generate_token(length: int) -> str:
    """Generate an alphanumeric token of exactly `length` characters."""
    return "".join(secrets.choice(ALPHABET) for _ in range(length))


# Create .env files from .env.example
for example in sorted(SERVICES_DIR.rglob("*.env.example")):
    target = Path(str(example)[:-len(".example")])

    if target.exists():
        skipped += 1
        continue

    target.write_bytes(example.read_bytes())
    created += 1


# Find all .env files
targets = list(SERVICES_DIR.rglob("*.env"))

# Generate one value per unique token
generated = {}

for path in targets:
    content = path.read_text()

    for token, length in set(TOKEN_RE.findall(content)):
        token_name = f"__GENERATE_{length}__"

        if token_name not in generated:
            generated[token_name] = generate_token(int(length))


# Replace generated tokens
for path in targets:
    content = path.read_text()

    for token, value in generated.items():
        content = content.replace(token, value)

    path.write_text(content)


print(f"Created {created} env file(s), left {skipped} existing one(s) untouched.")


# Find files that still contain CHANGEME_
remaining = [
    path for path in targets
    if CHANGE_ME in path.read_text()
]

if remaining:
    print("\nThese files still need a value you must fill in by hand:")
    for path in remaining:
        print(path)