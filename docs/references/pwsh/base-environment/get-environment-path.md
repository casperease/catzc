# pwsh/Base.Environment/Get-EnvironmentPath.ps1

The read half of the persistent PATH seam: a thin reader of the PATH at one scope, which tests mock instead of reading the machine.

## help

### synopsis

Reads the PATH environment variable at the scope given (the Windows registry for User/Machine).

### description

The single seam through which the PATH helpers (Add-/Remove-PermanentPath, Sync-SessionPath, the tooling uninstallers) READ the persistent
PATH, so tests can Mock the registry boundary (`Mock Get-EnvironmentPath -ModuleName <module>`) instead of reading the real machine. Paired
with Set-EnvironmentPath for writes. User/Machine scopes are a Windows concept; callers guard Windows-only use with $IsWindows. This is the
deliberately thin, un-mockable I/O boundary, so it has no unit test of its own.

### parameter `Scope`

Which environment scope to read: User (default), Machine, or Process.

### example 1

```powershell
Get-EnvironmentPath                 # User-scope PATH
```

### example 2

```powershell
Get-EnvironmentPath -Scope Machine
```
