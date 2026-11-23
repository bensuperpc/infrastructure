#!/usr/bin/env python3
"""Create infrastructure/.env and Authelia's users database from their examples.

Safe to re-run: existing values are never overwritten, only missing keys are added.
"""

from pathlib import Path
import re
import secrets
from string import Template
import subprocess
import sys

PROJECT_DIR = Path(__file__).resolve().parent.parent / "infrastructure"

KEY_RE = re.compile(r"^([A-Za-z_]\w*)=(.*)$", re.M)
# __GENERATE__: 48 hexadecimal characters, __GENERATE_<N>__: N characters (N even)
GENERATE_RE = re.compile(r"=__GENERATE(?:_(\d+))?__$")


def read_env(path: Path) -> dict[str, str]:
    return dict(KEY_RE.findall(path.read_text())) if path.exists() else {}


def generate(line: str) -> str:
    return GENERATE_RE.sub(lambda m: "=" + secrets.token_hex(int(m[1] or 48) // 2), line)


class SecretsInit:
    def __init__(self, project_dir: Path):
        self.root = project_dir.parent
        self.env_file = project_dir / ".env"
        self.env_example = project_dir / ".env.example"
        self.authelia_compose = project_dir / "services/infra/authelia/docker-compose.authelia.yml"
        self.users_db = project_dir / "services/infra/authelia/config/users_database.yml"
        self.users_example = self.users_db.with_name("users_database.yml.example")

    def run(self) -> None:
        self.update_env()
        env = read_env(self.env_file)
        if not self.users_db.exists():
            self.create_users_db(env)
        self.print_todo(env)

    def update_env(self) -> None:
        """First run: copy the whole example. Later runs: append only the missing keys."""
        existing = read_env(self.env_file)
        lines = self.env_example.read_text().splitlines()
        if existing:
            lines = [line for line in lines if (m := KEY_RE.match(line)) and m[1] not in existing]
        lines = [generate(line) for line in lines]

        if lines:
            text = self.env_file.read_text() if self.env_file.exists() else ""
            if text and not text.endswith("\n"):
                text += "\n"
            self.env_file.write_text(text + "\n".join(lines) + "\n")
        self.env_file.chmod(0o600)

        added = sum(bool(KEY_RE.match(line)) for line in lines)
        print(f"{self.rel(self.env_file)}: {added} key(s) added.")

    def create_users_db(self, env: dict[str, str]) -> None:
        digest = self.hash_password(self.authelia_image(), env["AUTHELIA_ADMIN_PASSWORD"])
        template = Template(self.users_example.read_text())
        self.users_db.write_text(template.substitute(env, AUTHELIA_ADMIN_PASSWORD_DIGEST=digest))
        self.users_db.chmod(0o600)
        print(f"Created {self.rel(self.users_db)} with user {env['AUTHELIA_ADMIN_USER']} "
              f"(password: AUTHELIA_ADMIN_PASSWORD in {self.rel(self.env_file)}).")

    def authelia_image(self) -> str:
        """The Authelia image pinned in its compose file."""
        return re.search(r"image:\s*(\S*authelia/authelia:\S+)", self.authelia_compose.read_text())[1]

    @staticmethod
    def hash_password(authelia_image: str, password: str) -> str:
        """Argon2 digest computed by Authelia itself, in a throwaway container."""
        cmd = ["docker", "run", "--rm", authelia_image,
               "authelia", "crypto", "hash", "generate", "argon2", "--password", password]
        try:
            result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        except subprocess.CalledProcessError as e:
            sys.exit(f"Authelia password hashing failed:\n{e.stderr.strip()}")
        return result.stdout.strip().removeprefix("Digest: ")

    def print_todo(self, env: dict[str, str]) -> None:
        if todo := [key for key, value in env.items() if value.startswith("CHANGEME_")]:
            print(f"\nStill to fill in by hand in {self.rel(self.env_file)}: " + ", ".join(todo))

    def rel(self, path: Path) -> Path:
        return path.relative_to(self.root)


if __name__ == "__main__":
    SecretsInit(PROJECT_DIR).run()
