# pwsh/Base.Writers/Write-Exception.ps1

The writer for a catch block: it prints an exception's type, message, stack trace and inner exceptions.

## help

### synopsis

Displays exception details for use in catch blocks.

### description

Prints exception type, message, script stack trace, and any inner exceptions. Falls back to $global:Error if no ErrorRecord is provided.

### parameter `ErrorRecord`

The ErrorRecord to display. If omitted, uses $global:Error.

### parameter `GlobalErrorIndex`

Index into $global:Error when no ErrorRecord is given. Defaults to 0 (most recent).

### example 1

```powershell
try { Get-Item C:\no } catch { Write-Exception $_ }
```

### example 2

```powershell
Write-Exception -GlobalErrorIndex 2
```
