# pwsh/Tooling.Toolchain/Invoke-Go.ps1

The way to run go: the command checks the installed Go against the locked version first, then runs it with the arguments given.

## help

### synopsis

Runs go with the given arguments.

### description

Asserts that the installed Go matches the locked version in Get-ToolConfig, then runs the executable the check located (Test-Tool -PassThru:
the managed home first, then PATH), so the asserted Go is the one that runs.

### parameter `Arguments`

Arguments to pass to go.

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
Invoke-Go 'version'
```

### example 2

```powershell
Invoke-Go 'env GOROOT' -PassThru
```
