# pwsh/Tooling.Core/Install-Tool.ps1

The installer of one tool of `tools.yml` through the platform package manager: winget on Windows, brew on macOS, apt-get on Linux. It is
idempotent and asserts the installed version afterwards.

## help

### synopsis

Installs a tool using the platform package manager.

### description

Uses winget on Windows, brew on macOS, and apt-get on Linux. Idempotent — skips if already installed at the correct version. If the wrong
version is found, -Force uninstalls and reinstalls. Without -Force, throws with instructions.

### parameter `Tool`

The snake_case tool key as defined in tools.yml.

### parameter `Version`

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter `Force`

Automatically uninstall the wrong version before installing the correct one.

## npm-managed tools

npm-managed tools (cspell, prettier, markdownlint) are installed with npm, not a platform package manager, so `Install-Tool` cannot handle
them. It fails before the `-Force` path routes into `Uninstall-Tool`, so the message names `Install-<command>`, what the caller wanted, and
not a stray winget detail from deeper in the chain. Bulk provisioning already dispatches these to their own command.

## winget

The install passes `--force`: winget may see a Store stub or a stale alias and report "already installed" although no real installation
exists, and `--force` makes it always install.

A winget portable package resolves through a symlink in `WinGet\Links`, which must be on PATH. Creating that symlink needs Developer Mode or
admin, so on a plain user account the command lands under `WinGet\Packages`, on no PATH at all. When the command is still unresolved after
the registry sync, the install finds it in the Packages tree, at most three levels below the packages folder, and prepends its directory to
the session PATH. Enabling Developer Mode lets winget do this itself and is the cleaner fix.

## Linux

Package installation through apt-get requires root. The user-space uv family never routes here: `Install-Uv` bootstraps uv from Astral's
standalone release, and the Python-based CLIs install through uv ([ADR-AUTO-UVPY](../../../drs/automation/uv-python-handler.md)).
