# pwsh/Catzc.Tooling.Python/Invoke-Poetry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs poetry with the given arguments.

### description

Asserts that the installed Poetry version matches the locked version in Get-ToolConfig before executing the command.

### parameter `Arguments`

Arguments to pass to poetry.

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
Invoke-Poetry 'install'
```

### example 2

```powershell
Invoke-Poetry 'version' -PassThru
```
