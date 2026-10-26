# pwsh/Tooling.Provisioning/Uninstall-DevBoxTools.ps1

The remover of the whole dev box: it walks the locked tools in reverse dependency order and runs each tool's own `Uninstall-*` command.

## help

### synopsis

Removes all tools installed by Install-DevBoxTools.

### description

Uninstalls tools in reverse dependency order (derived from depends_on in tools.yml). Tools that depend on others are removed first so their
uninstallers can still use the dependency (e.g., az_cli is removed before uv). OS-provided prerequisites (winget) are never uninstalled, and
Windows-only tools are skipped off Windows. Idempotent — skips tools that are not installed.

### example 1

```powershell
Uninstall-DevBoxTools
```

## The order

The install order is reversed. `@()` around the order guards the empty case: `[array]::Reverse` throws on `$null`, and a single-element
result would otherwise unwrap to a scalar.

## Elevation

An elevation-bound tool (`admin_only` machine scope, or an apt-get-routed Linux install) needs the same elevation to uninstall, so a
non-elevated run skips it and reports it.

## Finding each uninstaller

The snake_case `tools.yml` key is mapped to its PascalCase command suffix with `Get-ToolCommandSuffix`, exactly as `Install-DevBoxTools`
does: `node_js` becomes `Uninstall-NodeJs`, `az_cli` becomes `Uninstall-AzCli`, `py_spark` becomes `Uninstall-PySpark`. Building the name
from the raw key works only for single-word tools, by PowerShell's case-insensitive command resolution; a multi-word key never resolves and
was once skipped silently. A missing uninstaller throws, as in `Install-DevBoxTools`: a locked tool must have one, so its absence is a
defect to surface.
