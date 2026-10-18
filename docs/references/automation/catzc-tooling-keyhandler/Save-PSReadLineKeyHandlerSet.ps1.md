# automation/Catzc.Tooling.KeyHandler/Save-PSReadLineKeyHandlerSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Captures the current session's PSReadLine key bindings to configs/key-handler-bindings.yml.

### description

The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function
only — the pair Import-PSReadLineKeyHandlerSet consumes) as YAML so they can be replayed on Linux. Run it
in a Windows session whose editing experience is the one to replicate, then commit the regenerated config.
Writes canonically (UTF-8, LF, one trailing newline) through Write-FileIfChanged, so re-capturing an
unchanged session is a no-op.

### parameter Path

Target file. Defaults to the catzc source tree's
automation/Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml — the authored config that
Import-PSReadLineKeyHandlerSet reads back once loaded. The default needs a session running the source tree
(Assert-SourceTree), so a capture is never written into a built package.

### example 1

```powershell
Save-PSReadLineKeyHandlerSet
```

### example 2

```powershell
Save-PSReadLineKeyHandlerSet -Path ./key-handler-bindings.yml
```
