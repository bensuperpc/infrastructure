#!/usr/bin/env python3

from pathlib import Path
import re
import secrets
import subprocess
import sys

PROJECT_DIR = Path(__file__).resolve().parent.parent / "infrastructure"
EXAMPLE, ENV = PROJECT_DIR / ".env.example", PROJECT_DIR / ".env"
USERS_DATABASE = PROJECT_DIR / "services/authelia/config/users_database.yml"
LINE_RE = re.compile(r"^([A-Za-z_]\w*)=(.*)$", re.M)


def read_env(path: Path) -> dict:
    return dict(LINE_RE.findall(path.read_text())) if path.exists() else {}


def fill(line: str) -> str:
    return re.sub(r"=__GENERATE__$", lambda _: "=" + secrets.token_hex(24), line)

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
    user = env["AUTHELIA_ADMIN_USER"]
    USERS_DATABASE.write_text(
        "users:\n"
        f"  {user}:\n"
        f'    displayname: "{user}"\n'
        f'    password: "{digest}"\n'
        f'    email: "{env["AUTHELIA_ADMIN_EMAIL"]}"\n'
        "    groups:\n"
        "      - admins\n"
        "      - users\n"
    )
    USERS_DATABASE.chmod(0o600)
    print(f"Created {USERS_DATABASE.relative_to(PROJECT_DIR.parent)} with user {user} "
          "(password: AUTHELIA_ADMIN_PASSWORD in infrastructure/.env).")

if todo := [key for key, value in env.items() if value.startswith("CHANGEME_")]:
    print("\nStill to fill in by hand in infrastructure/.env: " + ", ".join(todo))
