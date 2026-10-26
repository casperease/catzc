# pwsh/Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1

The command that prints a whitelist of environment variables for pipeline diagnostics.

## help

### synopsis

Displays whitelisted environment variables for pipeline diagnostics.

### description

Reads the whitelist from configs/pipeline-env.yml and displays only those environment variables. Variables that are not set are shown as
empty. Designed for the top of every Invoke-AdoScript run so operators see build context, paths, and agent info at a glance.

### example 1

```powershell
Write-AdoEnvironmentDiagnostic
```
