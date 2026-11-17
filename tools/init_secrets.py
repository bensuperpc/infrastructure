#!/usr/bin/env python3

from pathlib import Path
import re
import secrets
from string import Template
import subprocess
import sys

PROJECT_DIR = Path(__file__).resolve().parent.parent / "infrastructure"
EXAMPLE, ENV = PROJECT_DIR / ".env.example", PROJECT_DIR / ".env"
USERS_DATABASE = PROJECT_DIR / "services/infra/authelia/config/users_database.yml"
USERS_EXAMPLE = USERS_DATABASE.with_name("users_database.yml.example")
LINE_RE = re.compile(r"^([A-Za-z_]\w*)=(.*)$", re.M)


def read_env(path: Path) -> dict:
    return dict(LINE_RE.findall(path.read_text())) if path.exists() else {}


# __GENERATE__: 48 hexadecimal characters, __GENERATE_<N>__: N characters (N even)
def fill(line: str) -> str:
    return re.sub(r"=__GENERATE(?:_(\d+))?__$",
                  lambda m: "=" + secrets.token_hex(int(m[1] or 48) // 2), line)

existing = read_env(ENV)
added = [fill(line) for line in EXAMPLE.read_text().splitlines()
         if not existing or ((match := LINE_RE.match(line)) and match[1] not in existing)]
if added:
    text = ENV.read_text() if ENV.exists() else ""
    ENV.write_text(text + ("\n" if text and not text.endswith("\n") else "") + "\n".join(added) + "\n")
ENV.chmod(0o600)
print(f"infrastructure/.env: {sum(bool(LINE_RE.match(line)) for line in added)} key(s) added.")

env = {**read_env(PROJECT_DIR / "versions.env"), **read_env(ENV)}
if not USERS_DATABASE.exists():
    digest = subprocess.run(
        ["docker", "run", "--rm", f"authelia/authelia:{env['AUTHELIA_DOCKER_TAG']}", "authelia", "crypto", "hash",
         "generate", "argon2", "--password", env["AUTHELIA_ADMIN_PASSWORD"]],
        check=True, capture_output=True, text=True,
    ).stdout.strip().removeprefix("Digest: ")
    USERS_DATABASE.write_text(Template(USERS_EXAMPLE.read_text()).substitute(env, AUTHELIA_ADMIN_PASSWORD_DIGEST=digest))
    USERS_DATABASE.chmod(0o600)
    print(f"Created {USERS_DATABASE.relative_to(PROJECT_DIR.parent)} with user {env['AUTHELIA_ADMIN_USER']} "
          "(password: AUTHELIA_ADMIN_PASSWORD in infrastructure/.env).")

if todo := [key for key, value in env.items() if value.startswith("CHANGEME_")]:
    print("\nStill to fill in by hand in infrastructure/.env: " + ", ".join(todo))
