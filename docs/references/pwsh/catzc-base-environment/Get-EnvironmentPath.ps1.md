# pwsh/Base.Environment/Get-EnvironmentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
