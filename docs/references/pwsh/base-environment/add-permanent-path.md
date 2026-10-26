# pwsh/Base.Environment/Add-PermanentPath.ps1

The command that makes a directory part of PATH for good: in the registry or the profile, and in the current session.

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

## Persistent PATH seam

The persistent PATH goes through `Get-EnvironmentPath` and `Set-EnvironmentPath`, a thin read and write seam over the registry. A test mocks
them and never touches the machine's PATH.
