# pwsh/Tooling.KeyHandler/Save-PsReadLineKeyHandlerSet.ps1

The authoring step that captures the session's bound PSReadLine handlers into the committed `configs/key-handler-bindings.yml`. Without
`-Path` it asserts the source tree and writes the module's own config, never the loaded copy, and it rewrites the file only when the content
changed.

## help

### synopsis

Captures the current session's PSReadLine key bindings to configs/key-handler-bindings.yml.

### description

The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function only — the pair
Import-PsReadLineKeyHandlerSet consumes) as YAML so they can be replayed on Linux. Run it in a Windows session whose editing experience is
the one to replicate, then commit the regenerated config. Writes canonically (UTF-8, LF, one trailing newline) through Write-FileIfChanged,
so re-capturing an unchanged session is a no-op.

### parameter `Path`

Target file. Defaults to the catzc source tree's pwsh/Tooling.KeyHandler/configs/key-handler-bindings.yml — the authored config that
Import-PsReadLineKeyHandlerSet reads back once loaded. The default needs a session running the source tree (Assert-SourceTree), so a capture
is never written into a built package.

### example 1

```powershell
Save-PsReadLineKeyHandlerSet
```

### example 2

```powershell
Save-PsReadLineKeyHandlerSet -Path ./key-handler-bindings.yml
```
