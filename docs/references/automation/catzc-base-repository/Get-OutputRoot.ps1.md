# automation/Catzc.Base.Repository/Get-OutputRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
