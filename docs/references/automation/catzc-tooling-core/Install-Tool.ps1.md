---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Install-Tool.ps1.md
    kind: comment-page
    body_sha: dfcbfdb0270f
    adrs: []
---

# automation/Catzc.Tooling.Core/Install-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Uses winget on Windows, brew on macOS, and apt-get on Linux.
Idempotent — skips if already installed at the correct version.
If the wrong version is found, -Force uninstalls and reinstalls.
Without -Force, throws with instructions.
```

## comment:2

Above `if ($config.npm_package) {`.

```text
npm-managed tools (cspell, prettier, markdownlint) are installed with npm, not a platform package
manager, so Install-Tool cannot handle them. Fail here — before the -Force path routes into
Uninstall-Tool — so the message names Install-$command (what the caller wanted), not a stray winget
detail from deeper in the chain. Bulk provisioning already dispatches these to Install-$command.
```

## comment:3

Above `if ($config.winget_scope -eq 'user') {`.

```text
--force: winget may see a Store stub or stale alias and report "already installed"
even though no real installation exists. Force ensures it always installs.
```

## comment:4

Above `Assert-IsAdministrator -ErrorText "Install-$command on Linux requires root...`.

```text
Linux package installation via apt-get requires root. The user-space uv family never routes here:
Install-Uv bootstraps uv from Astral's standalone release, and the Python-based CLIs install
through uv ([ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)).
```

## comment:5

Above `if ($IsWindows -and -not (Get-Command $config.command -CommandType...`.

```text
winget portable packages resolve through a symlink in WinGet\Links that must be on PATH; creating that
symlink needs Developer Mode (or admin), so on a plain user account the command lands under WinGet\Packages
on no PATH at all. When it is still unresolved after the registry sync, recover it: find the command in the
Packages tree and prepend its directory to the session PATH. (Enabling Developer Mode lets winget do this
itself and is the cleaner fix.)
```
