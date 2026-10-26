# pwsh/Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1

The private shared tail of the Unix off-config removers, run after each has tried its native package manager. It evicts a pip package of the
uv-managed Python, or else deletes a stray binary found on PATH.

## help

### synopsis

Shared tail of the Unix off-config removers: evict a uv-managed-Python pip package, else delete a stray on-PATH binary. Both steps are
user-space.

### description

Called by Remove-LinuxToolInstall and Remove-MacToolInstall after each has tried its native package manager (apt on Linux, brew on macOS).
Neither step here needs elevation
([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)):
the pip removal is the uv-scoped 'uv pip uninstall --system' (never a foreign system pip), and the stray delete removes only the resolved
binary. Private to Catzc.Tooling.Core.

### parameter `Config`

The tool's parsed tools.yml entry (from Get-ToolConfig).

### parameter `Source`

The resolved path of the tool's on-PATH binary (from Get-Command) — the caller resolves it once and passes it in.

### outputs

`[bool]` — $true when an off-config install was removed, $false when there was nothing to remove.

## Stray binary

A binary no package manager owns is deleted as just the resolved file. A root-owned path fails the delete loudly rather than being
force-removed silently.
