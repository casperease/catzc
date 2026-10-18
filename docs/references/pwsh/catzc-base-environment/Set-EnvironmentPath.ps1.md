# pwsh/Catzc.Base.Environment/Set-EnvironmentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the PATH environment variable at the scope given (the Windows registry for User/Machine).

### description

The single seam through which the PATH helpers (Add-/Remove-PermanentPath, the tooling uninstallers) WRITE the persistent PATH, so tests can
Mock the registry boundary (`Mock Set-EnvironmentPath -ModuleName <module>`) instead of mutating the real machine PATH (which also
broadcasts WM_SETTINGCHANGE). User/Machine scopes are a Windows concept; callers guard Windows-only use with $IsWindows. This is the
deliberately thin, un-mockable I/O boundary, so it has no unit test of its own.

Because every persistent PATH write passes through here, this is also where it is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../adr/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)): one line names the scope and the entries
added and removed. Writing the value the scope already holds is a no-op, so it neither writes nor announces.

### parameter `Value`

The full PATH string to persist.

### parameter `Scope`

Which environment scope to write: User (default) or Machine.

### example 1

```powershell
Set-EnvironmentPath 'C:\foo;C:\bar'
```
