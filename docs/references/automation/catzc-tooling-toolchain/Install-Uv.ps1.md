---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md
    kind: comment-page
    body_sha: "716ebb9e1efe"
---

# automation/Catzc.Tooling.Toolchain/Install-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `if (-not (Test-Command 'uv')) {`.

```text
Fresh machine: bootstrap per platform — winget on Windows and brew on macOS (both via Install-Tool);
Astral's standalone release on Linux (user-space, ~/.local/bin — there is no uv apt package).
```

## comment:7

Above `if ($IsLinux) {`.

```text
Upgrade through the configured install source, not a blanket `uv self update`. The Linux bootstrap
extracts the standalone tarball into ~/.local/bin (no self-update receipt) and winget/brew are
package-manager-managed, so `uv self update` refuses all three ("installed via pip/brew/another package
manager"). Re-asserting the configured install upgrades in place.
```

## comment:8

Above `Install-UvStandalone -Version $Version`.

```text
Re-download the pinned, verified standalone build over ~/.local/bin — this also replaces an off-config
uv (e.g. a leftover pip-installed one) that happens to sit in the tool-bin.
```

## comment:9

Above `$wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'`.

```text
Windows: a winget-managed uv upgrades through winget; a uv installed by Astral's own script (on PATH
outside the winget package root) carries a self-update receipt and upgrades in place.
```
