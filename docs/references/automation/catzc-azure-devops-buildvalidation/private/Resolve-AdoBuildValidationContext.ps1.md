# automation/Catzc.Azure.DevOps.BuildValidation/private/Resolve-AdoBuildValidationContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the ADO coordinates every build-validation call needs — org, project, repository id, API base.

### description

Defaults organization/project from ado.yml and the repository name from Get-AdoRepositoryName (the same default as Register-AdoPipeline and
the public build-validation functions), resolves the repository to its GUID via the Git repositories API, and returns one context object the
public functions share — including the well-known Build policy type id, so the constant lives in exactly one place.

### parameter Project

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter Organization

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter RepositoryName

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### example 1

```powershell
$context = Resolve-AdoBuildValidationContext
```
