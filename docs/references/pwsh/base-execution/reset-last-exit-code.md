# pwsh/Base.Execution/Reset-LastExitCode.ps1

Removes the global `$LASTEXITCODE`, so the exit code of one external command never leaks into the check of the next. `Invoke-Executable`
calls it before and after every run.

## help

### synopsis

Removes the global $LASTEXITCODE variable.

### example 1

```powershell
Reset-LastExitCode
```
