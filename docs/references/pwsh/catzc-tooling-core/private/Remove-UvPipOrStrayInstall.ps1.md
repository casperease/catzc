# pwsh/Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Shared tail of the Unix off-config removers: evict a uv-managed-Python pip package, else delete a stray on-PATH binary. Both steps are
user-space.

### description

Called by Remove-LinuxToolInstall and Remove-MacToolInstall after each has tried its native package manager (apt on Linux, brew on macOS).
Neither step here needs elevation
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)):
the pip removal is the uv-scoped 'uv pip uninstall --system' (never a foreign system pip), and the stray delete removes only the resolved
binary. Private to Catzc.Tooling.Core.

### parameter `Config`

The tool's parsed tools.yml entry (from Get-ToolConfig).

### parameter `Source`

The resolved path of the tool's on-PATH binary (from Get-Command) — the caller resolves it once and passes it in.

### outputs

`[bool]` — $true when an off-config install was removed, $false when there was nothing to remove.

## comment:1

Above `if ([System.IO.File]::Exists($Source)) {`, written with `#`.

```text
Stray binary no manager owns — delete just the resolved file (a root-owned path fails the delete loudly
rather than being force-removed silently).
```
