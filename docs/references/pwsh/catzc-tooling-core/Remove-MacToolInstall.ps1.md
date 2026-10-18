# pwsh/Catzc.Tooling.Core/Remove-MacToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Evicts an off-config macOS install of a tool so the managed build can win — the macOS platform core of the tool-removal lifecycle.

### description

The macOS counterpart to Remove-SystemInstallation (Windows) and Remove-LinuxToolInstall (Linux)
([ADR-AUTO-REMOVE-THREEPLATFORMCORES](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-threeplatformcores)). In precedence order:

1. a Homebrew-owned binary -> brew uninstall `<owning formula>` (user-space)
2. a uv-managed-Python package -> uv pip uninstall --system (user-space)
3. a stray binary on PATH -> delete the file (user-space)

The brew owner is resolved by locating the on-PATH binary under 'brew --prefix' and reading its Cellar symlink target for the formula name —
so a brew 'azure-cli' is caught even though az_cli's configured manager is uv. Every macOS mechanism is user-space; nothing here asserts
elevation ([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)). Steps 2 and 3 are the shared Unix
tail (Remove-UvPipOrStrayInstall), identical to Linux.

This is invoked from the Unix branch of a `Remove-<Tool>`, which owns the -Force dry-run guard and the managed-install refusal
(Test-ExpectedPackageManager) — so this core is only ever reached for an off-config install, and just evicts it.

### parameter `Config`

The tool's parsed tools.yml entry (from Get-ToolConfig).

### outputs

`[bool]` — $true when an off-config install was removed, $false when there was nothing to remove.

## comment:1

Above `if (Test-Command brew) {`, written with `#`.

```text
1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
   carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
```
