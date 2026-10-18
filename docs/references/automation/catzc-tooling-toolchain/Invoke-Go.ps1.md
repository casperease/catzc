# automation/Catzc.Tooling.Toolchain/Invoke-Go.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
