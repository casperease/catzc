# pwsh/Base.Asserts/Assert-PsModule.ps1

The throwing check that a PowerShell module is available to the session.

## help

### synopsis

Asserts that a PowerShell module is available.

### parameter `Module`

The module name to look up via Get-Module -ListAvailable.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-PsModule 'Pester'
```
