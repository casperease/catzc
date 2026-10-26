# pwsh/Tooling.KeyHandler/Import-PsReadLineKeyHandlerSet.ps1

The command that replays the captured Windows PSReadLine key bindings on Linux. It plans each binding with `Select-SupportedKeyHandler`,
skips the ones whose function is not on the allow-list, and refuses to apply anything on Windows, where it would clobber the native
handlers; `-DryRun` returns the plan on any platform.

## help

### synopsis

Applies the captured Windows PSReadLine key bindings on Linux, filtered to Linux-supported functions.

### description

PSReadLine on Linux defaults to bash-style editing; this replicates the Windows editing experience by applying the captured bindings
(configs/key-handler-bindings.yml) through Set-PSReadLineKeyHandler, skipping any function the Linux build does not support
(configs/key-handler-supported.yml) so an unsupported binding is dropped rather than throwing. Runs on Linux only — applying Windows
bindings on a Windows session would clobber its native handlers, so the real apply path asserts $IsLinux. Use -DryRun to see the plan (which
bindings apply, which are skipped) on any platform without changing the session.

### parameter `DryRun`

Return the classified plan (one record per binding with Key, Function, Supported) and change nothing.

### example 1

```powershell
Import-PsReadLineKeyHandlerSet
```

### example 2

```powershell
Import-PsReadLineKeyHandlerSet -DryRun | Where-Object { -not $_.Supported }
```
