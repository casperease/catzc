# automation/Catzc.Tooling.Python/Invoke-PySpark.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs pyspark with the given arguments.

### description

Asserts that the installed PySpark version matches the locked version in Get-ToolConfig before executing the command. Also asserts Java is
available (DependsOn in tools.yml).

### parameter `Arguments`

Arguments to pass to pyspark.

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
Invoke-PySpark '--version'
```

### example 2

```powershell
Invoke-PySpark '--version' -DryRun
```
