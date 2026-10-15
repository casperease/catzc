---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md
    kind: comment-page
    body_sha: "23522969bf24"
---

# automation/Catzc.Tooling.Toolchain/Install-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (-not (Test-Command 'uv')) {`, written with `#`.

```text
Fresh machine: bootstrap per platform — winget on Windows and brew on macOS (both via Install-Tool);
Astral's standalone release on Linux (user-space, ~/.local/bin — there is no uv apt package).
```

## comment:2

Above `if ($IsLinux) {` (occurrence 2), written with `#`.

```text
Upgrade through the configured install source, not a blanket `uv self update`. The Linux bootstrap
extracts the standalone tarball into ~/.local/bin (no self-update receipt) and winget/brew are
package-manager-managed, so `uv self update` refuses all three ("installed via pip/brew/another package
manager"). Re-asserting the configured install upgrades in place.
```

## comment:3

Above `Install-UvStandalone -Version $Version` (occurrence 2), written with `#`.

```text
Re-download the pinned, verified standalone build over ~/.local/bin — this also replaces an off-config
uv (e.g. a leftover pip-installed one) that happens to sit in the tool-bin.
```

## comment:4

Above `$wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'`, written with `#`.

```text
Windows: a winget-managed uv upgrades through winget; a uv installed by Astral's own script (on PATH
outside the winget package root) carries a self-update receipt and upgrades in place.
```
