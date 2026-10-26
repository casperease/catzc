# pwsh/Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1

The gate over the dev box: it turns `Get-ToolsStatus` into a pass or a throw, so a pipeline or a session stops when a locked tool is missing
or at the wrong version.

## help

### synopsis

Asserts all tools are available at the correct version.

### description

Calls Get-ToolsStatus and throws if any tool is Missing or WrongVersion. Tools with status OK or Usable pass — the tool works regardless of
how it was installed. Chocolatey status is ignored.

### example 1

```powershell
Assert-DevBoxToolsStatus
```
