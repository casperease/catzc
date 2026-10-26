# pwsh/Base.Environment/Add-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Adds a directory to PATH persistently and in the current session.

### description

Cross-platform PATH persistence:

- Windows: writes to the User-scope registry PATH.
- Linux/macOS: appends a marked block to the PowerShell profile.
- Always: updates $env:PATH for the current session.

Idempotent — skips if the path is already present.

### parameter `Path`

The directory to add. Must exist.

### parameter `Prepend`

Place the path at the beginning instead of the end.

### parameter `Label`

Identity marker for Unix profile blocks. Defaults to the leaf folder name. Must match when calling Remove-PermanentPath.

### parameter `Sync`

After adding, call Sync-SessionPath to merge any other new registry entries into the current session (Windows only).

### example 1

```powershell
Add-PermanentPath '/usr/local/go/bin'
```

### example 2

```powershell
Add-PermanentPath $installDir -Prepend -Label 'Install-Dotnet'
```

### example 3

```powershell
Add-PermanentPath $toolDir -Sync
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
