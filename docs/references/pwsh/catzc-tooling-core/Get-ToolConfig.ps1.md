# pwsh/Catzc.Tooling.Core/Get-ToolConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
