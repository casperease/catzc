# pwsh/Tooling.Core/Get-ToolConfig.ps1

The lookup of one tool's locked definition in `configs/tools.yml`, returned as a validated `ToolConfig`. The whole file is built and cached
once per session by `Get-Config`, so repeated calls return the same instance.

## help

### synopsis

Returns the locked configuration for a CLI tool as a validated ToolConfig.

### description

Looks one tool's locked definition up in configs/tools.yml, read through Get-Config — which constructs the typed
Catzc.Base.Execution.ToolsConfig once per session (validating every entry) and caches it, so repeated calls return the same ToolConfig
instance.

### parameter `Tool`

The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').

### example 1

```powershell
$config = Get-ToolConfig -Tool 'python'
```
