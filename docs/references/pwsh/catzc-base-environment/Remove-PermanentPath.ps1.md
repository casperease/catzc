# pwsh/Catzc.Base.Environment/Remove-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes a directory from PATH persistently and in the current session.

### description

Cross-platform PATH removal:

- Windows: removes from the User-scope registry PATH.
- Linux/macOS: removes the marked block from the PowerShell profile.
- Always: removes from $env:PATH for the current session.

Idempotent — no error if the path is not present.

### parameter `Path`

The directory to remove.

### parameter `Label`

Identity marker for Unix profile blocks. Must match the label used when Add-PermanentPath was called. Defaults to the leaf folder name.

### parameter `Sync`

After removing, call Sync-SessionPath to refresh the session PATH from the registry (Windows only).

### example 1

```powershell
Remove-PermanentPath '/usr/local/go/bin'
```

### example 2

```powershell
Remove-PermanentPath $installDir -Label 'Install-Dotnet'
```

## comment:1

Above `if ($IsWindows) {`, written with `#`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```

## comment:2

Above `if ($IsWindows) {`, written with `#`.

```text
The persistent PATH goes through a thin read and write seam, so a test can stand in for it and never touch the
machine's.
```
