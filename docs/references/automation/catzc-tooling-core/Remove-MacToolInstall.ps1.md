---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md
    kind: comment-page
    body_sha: "325366c3d5a5"
    adrs:
      - ADR-AUTO-REMOVE#6
      - ADR-AUTO-REMOVE#7
---

# automation/Catzc.Tooling.Core/Remove-MacToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The macOS counterpart to Remove-SystemInstallation (Windows) and Remove-LinuxToolInstall (Linux)
([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)). In precedence order:

  1. a Homebrew-owned binary -> brew uninstall <owning formula>   (user-space)
  2. a uv-managed-Python package -> uv pip uninstall --system      (user-space)
  3. a stray binary on PATH      -> delete the file                (user-space)

The brew owner is resolved by locating the on-PATH binary under 'brew --prefix' and reading its Cellar
symlink target for the formula name — so a brew 'azure-cli' is caught even though az_cli's configured
manager is uv. Every macOS mechanism is user-space; nothing here asserts elevation
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)). Steps 2
and 3 are the shared Unix tail (Remove-UvPipOrStrayInstall), identical to Linux.

This is invoked from the Unix branch of a Remove-<Tool>, which owns the -Force dry-run guard and the
managed-install refusal (Test-ExpectedPackageManager) — so this core is only ever reached for an off-config
install, and just evicts it.
```

## comment:2

Above `if (Test-Command brew) {`.

```text
1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
   carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
```

## comment:3

Above `if (Test-Command brew) {`.

```text
1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
   carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
```
