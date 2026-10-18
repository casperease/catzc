# automation/Catzc.Base.Execution/Get-LastExitCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the current $LASTEXITCODE value, or warns if none exists.

### example 1

```powershell
Get-LastExitCode
# Returns the exit code from the last native command
```
