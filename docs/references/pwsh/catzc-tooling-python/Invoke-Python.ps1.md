# pwsh/Tooling.Python/Invoke-Python.ps1

The way to run Python: the command checks the installed Python against the locked version first, then runs it with the arguments given.

## help

### synopsis

Runs python with the given arguments.

### description

Asserts that the installed Python version matches the locked version in Get-ToolConfig before executing the command.

### parameter `Arguments`

Arguments to pass to python.

### parameter `PassThru`

Return a CliResult object with Output, Errors, Full, and ExitCode.

### parameter `NoAssert`

Skip exit code assertion.

### parameter `Silent`

Suppress the command log line.

### parameter `DryRun`

Return the command string without executing. Used for testing.

### example 1

```powershell
Invoke-Python '--version'
```

### example 2

```powershell
Invoke-Python '--version' -DryRun
```
