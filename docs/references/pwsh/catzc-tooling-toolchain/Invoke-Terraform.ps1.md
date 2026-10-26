# pwsh/Tooling.Toolchain/Invoke-Terraform.ps1

The way to run terraform: the command checks the installed Terraform against the locked version first, then runs it with the arguments
given.

## help

### synopsis

Runs terraform with the given arguments.

### description

Asserts that the installed Terraform version matches the locked version in Get-ToolConfig before executing the command.

### parameter `Arguments`

Arguments to pass to terraform.

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
Invoke-Terraform 'plan'
```

### example 2

```powershell
Invoke-Terraform 'plan' -DryRun
```
