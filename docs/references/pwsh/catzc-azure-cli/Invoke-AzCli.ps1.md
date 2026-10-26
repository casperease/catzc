# pwsh/Azure.Cli/Invoke-AzCli.ps1

The command every az call goes through. It checks the installed az against the locked version, runs the arguments, and asserts the exit code
unless told not to.

## help

### synopsis

Runs az with the given arguments.

### description

Asserts that the installed Azure CLI version matches the locked version in Get-ToolConfig before executing the command.

Dynamic extension install is disabled for the duration of the call (AZURE_EXTENSION_USE_DYNAMIC_INSTALL=no), so a command that requires an
uninstalled extension fails with a non-zero exit code instead of blocking on an interactive "(Y/n)" install prompt that captured stdin would
hide. That failure surfaces through the usual exit-code assertion as a throw.

### parameter `Arguments`

Arguments to pass to az.

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
Invoke-AzCli 'account show'
```

### example 2

```powershell
Invoke-AzCli 'group list' -PassThru
```

### example 3

```powershell
Invoke-AzCli 'version' -DryRun
```

## Dynamic extension install

Around the call the command sets `AZURE_EXTENSION_USE_DYNAMIC_INSTALL` to `no`. A command that needs an uninstalled extension then exits
non-zero instead of blocking on an invisible "(Y/n)" prompt, and `Invoke-Executable`'s exit-code assertion turns that exit into a throw.

The setting is scoped to the process and restored afterwards; a variable that was unset is restored to unset, not to empty. A dry run never
launches az, so it skips the setting.
