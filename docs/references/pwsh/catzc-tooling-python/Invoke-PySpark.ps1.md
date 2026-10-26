# pwsh/Tooling.Python/Invoke-PySpark.ps1

The way to run pyspark: the command checks the installed PySpark against the locked version and asserts that Java, its runtime dependency, is
available, then runs it.

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
