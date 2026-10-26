# pwsh/Azure.Cli/Invoke-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'`, written with `#`.

```text
Disable az dynamic extension install for this call: a command needing an uninstalled extension
then exits non-zero instead of blocking on an invisible "(Y/n)" prompt, which Invoke-Executable's
exit-code assertion turns into a throw. Scoped to the process and restored afterwards; skipped on
a dry run, which never launches az. $null restores an unset variable to unset (not empty).
```
