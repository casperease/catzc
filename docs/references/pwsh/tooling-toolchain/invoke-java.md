# pwsh/Tooling.Toolchain/Invoke-Java.ps1

The way to run java: the command checks the installed Java against the locked version first, then runs it with the arguments given.

## help

### synopsis

Runs java with the given arguments.

### description

Asserts that the installed Java version matches the locked version in Get-ToolConfig before executing the command.

### parameter `Arguments`

Arguments to pass to java.

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
Invoke-Java '--version'
```

### example 2

```powershell
Invoke-Java '--version' -DryRun
```
