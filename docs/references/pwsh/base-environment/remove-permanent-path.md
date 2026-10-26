# pwsh/Base.Environment/Remove-PermanentPath.ps1

The counterpart of `Add-PermanentPath`: it takes a directory out of PATH for good, in the registry or the profile, and in the current
session.

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

## Persistent PATH seam

The persistent PATH goes through `Get-EnvironmentPath` and `Set-EnvironmentPath`, a thin read and write seam over the registry. A test mocks
them and never touches the machine's PATH.
