# pwsh/Tooling.KeyHandler/Import-PsReadLineKeyHandlerSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
