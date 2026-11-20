#!/usr/bin/env python3
"""Register Caddy's account on acme-dns and write it to infrastructure/.env (TLS=acme-dns).

Safe to re-run: an existing account is kept. Prints the CNAME record to create at the DNS provider.
"""

import json
import os
from pathlib import Path
import re
import subprocess
import sys

ENV_FILE = Path(__file__).resolve().parent.parent / "infrastructure" / ".env"
KEY_RE = re.compile(r"^([A-Za-z_]\w*)=(.*)$", re.M)


def register() -> dict[str, str]:
    """POST /register to the API, from inside the acme-dns container (the API is not published)."""
    cmd = ["docker", "exec", "acme-dns", "wget", "-q", "-O", "-", "--post-data", "", "http://127.0.0.1/register"]
    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as e:
        sys.exit(f"acme-dns registration failed (is the acme-dns container running?):\n{e.stderr.strip()}")
    return json.loads(result.stdout)


def write_env(values: dict[str, str]) -> None:
    """Set each key in .env: replace its line, or append it."""
    text = ENV_FILE.read_text()
    for key, value in values.items():
        line = f"{key}={value}"
        text, found = re.subn(rf"^{key}=.*$", lambda _: line, text, flags=re.M)
        if not found:
            text += ("" if text.endswith("\n") else "\n") + line + "\n"
    ENV_FILE.write_text(text)
    ENV_FILE.chmod(0o600)


def main() -> None:
    env = dict(KEY_RE.findall(ENV_FILE.read_text()))
    if env.get("ACME_DNS_SUBDOMAIN"):
        print(f"Already registered: ACME_DNS_* are set in {ENV_FILE.name}.")
    else:
        account = register()
        write_env({
            "ACME_DNS_USERNAME": account["username"],
            "ACME_DNS_PASSWORD": account["password"],
            "ACME_DNS_SUBDOMAIN": account["subdomain"],
        })
        env["ACME_DNS_SUBDOMAIN"] = account["subdomain"]
        print(f"Registered on acme-dns, account written to {ENV_FILE.name}.")

    domain = os.environ.get("DOMAIN") or env["DOMAIN"]
    print(f"\nCreate this record once at the DNS provider of {domain}, then run make up:\n"
          f"  _acme-challenge.{domain}.  CNAME  {env['ACME_DNS_SUBDOMAIN']}.acme.{domain}.")


if __name__ == "__main__":
    main()
