# automation/Catzc.Azure.DevOps.BuildValidation/Sync-AdoBuildValidations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Registers every build-validation branch policy declared in build-validation.yml. Idempotent.

### description

The config-driven reconcile: for each entry under 'validations' in build-validation.yml, runs Register-AdoBuildValidation — creating missing
policies, updating drifted ones, and leaving current ones alone — and emits each result. This is the everything-as-code path for the
server-side policies: the local config is the source of truth, and this function converges the ADO project to it.

### parameter `Branch`

Override the branch for every policy. Defaults from build-validation.yml 'branch'.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter `DryRun`

Return every entry's planned action (Create/Update/Unchanged) without touching the server.

### example 1

```powershell
Sync-AdoBuildValidations -DryRun
```

### example 2

```powershell
Sync-AdoBuildValidations
```
