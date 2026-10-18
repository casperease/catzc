# automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The Azure DevOps repository this checkout is: the sensible default for every -RepositoryName.

### description

In a pipeline, the agent's own repository ($env:BUILD_REPOSITORY_NAME); on a devbox, the checkout folder's
name (the leaf of Get-RepositoryRoot), which is the repository's name in a default clone. The one place the
ADO functions derive the name, declared as their -RepositoryName default
([ADR-PWSH-PARAM#4](../../../adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)), so an
explicit argument always wins and Get-Help shows where the default comes from.

### outputs

`[string]` The repository name.

### example 1

```powershell
Get-AdoRepositoryName
```
