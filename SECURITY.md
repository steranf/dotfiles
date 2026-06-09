# Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| latest (main) | ✅ |
| < v1.0.0 | ❌ |

## Reporting a vulnerability

**Do not open a public issue.** Use one of these private channels:

- **GitHub (preferred):** [Report a vulnerability](https://github.com/steranf/dotfiles/security/advisories/new) via the Security tab
- **Email:** ipodnero2010@gmail.com

Include in your report:
- Description of the vulnerability and its potential impact
- Steps to reproduce or proof-of-concept
- Affected file(s) and line numbers if known

## What to expect

| Timeline | Action |
|----------|--------|
| 48 hours | Acknowledgement of your report |
| 7 days | Initial assessment and severity classification |
| 30 days | Fix released (critical/high) or mitigation documented |

Once a fix is released, the vulnerability will be disclosed publicly via a GitHub Security Advisory.

## Scope

This repo installs software and copies config files. The main attack surfaces are:

- **Download integrity** — binaries fetched from GitHub Releases are SHA256-verified and pinned to specific versions
- **Script injection** — inputs validated before use in shell commands and config files
- **Privilege escalation** — `sudo` is used only where strictly necessary (binary installation to `/usr/local/bin`)

Reports outside this scope (e.g. vulnerabilities in upstream tools like Neovim or Oh My Posh) should be reported directly to those projects.
