# automation/Catzc.Base.Writers/Write-Exception.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
