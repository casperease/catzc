# pwsh/Azure.DevOps.BuildValidation/private/Resolve-AdoBuildValidationContext.ps1

The private function that resolves the ADO coordinates every build-validation call needs: organization, project, repository id and the API
base.

## help

### synopsis

Resolves the ADO coordinates every build-validation call needs — org, project, repository id, API base.

### description

Defaults organization/project from ado.yml and the repository name from Get-AdoRepositoryName (the same default as Register-AdoPipeline and
the public build-validation functions), resolves the repository to its GUID via the Git repositories API, and returns one context object the
public functions share — including the well-known Build policy type id, so the constant lives in exactly one place.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### example 1

```powershell
$context = Resolve-AdoBuildValidationContext
```
