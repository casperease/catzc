# pwsh/Base.Repository/Get-OutputRoot.ps1

The resolver of the output directory for the current context: the pipeline's staging directory, or `out/` under the repository root on a
devbox.

## help

### synopsis

Returns the path to the output directory for the current execution context.

### description

In an Azure DevOps pipeline, returns $env:BUILD_ARTIFACTSTAGINGDIRECTORY. Locally on DevBox, returns {RepositoryRoot}/out.

With -EnsureExists, creates the directory if it does not exist.

### parameter `EnsureExists`

Create the output directory if it does not exist.

### example 1

```powershell
$outDir = Get-OutputRoot
```

### example 2

```powershell
$outDir = Get-OutputRoot -EnsureExists
```
