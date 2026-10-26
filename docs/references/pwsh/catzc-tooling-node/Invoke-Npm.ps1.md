# pwsh/Tooling.Node/Invoke-Npm.ps1

The way to run npm: the command checks the installed npm against the locked version first, then runs it with the arguments given.

## help

### synopsis

Runs npm with the given arguments.

### description

Asserts that the installed npm version matches the locked version in Get-ToolConfig before executing the command.

### parameter `Arguments`

Arguments to pass to npm.

### parameter `PassThru`

Return a CliResult object with Output, Errors, Full, and ExitCode.

### parameter `NoAssert`

Skip exit code assertion.

### parameter `Silent`

Suppress the command log line.

### parameter `DryRun`

Return the command string without executing.

### example 1

```powershell
Invoke-Npm 'install'
```

### example 2

```powershell
Invoke-Npm 'run build' -PassThru
```
