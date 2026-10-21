# pwsh/Catzc.Tooling.Core/Install-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `if ($config.npm_package) {`, written with `#`.

```text
npm-managed tools (cspell, prettier, markdownlint) are installed with npm, not a platform package
manager, so Install-Tool cannot handle them. Fail here — before the -Force path routes into
Uninstall-Tool — so the message names Install-$command (what the caller wanted), not a stray winget
detail from deeper in the chain. Bulk provisioning already dispatches these to Install-$command.
```

## comment:2

Above `if ($config.winget_scope -eq 'user') {`, written with `#`.

```text
--force: winget may see a Store stub or stale alias and report "already installed"
even though no real installation exists. Force ensures it always installs.
```

## comment:3

Above `Assert-IsAdministrator -ErrorText "Install-$command on Linux requires root...`, written with `#`.

```text
Linux package installation via apt-get requires root. The user-space uv family never routes here:
Install-Uv bootstraps uv from Astral's standalone release, and the Python-based CLIs install
through uv ([ADR-AUTO-UVPY](/docs/drs/automation/uv-python-handler.md)).
```

## comment:4

Above `if ($IsWindows -and -not (Get-Command $config.command -CommandType...`, written with `#`.

```text
winget portable packages resolve through a symlink in WinGet\Links that must be on PATH; creating that
symlink needs Developer Mode (or admin), so on a plain user account the command lands under WinGet\Packages
on no PATH at all. When it is still unresolved after the registry sync, recover it: find the command in the
Packages tree and prepend its directory to the session PATH. (Enabling Developer Mode lets winget do this
itself and is the cleaner fix.)
```
