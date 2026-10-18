# pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the build-validation branch policies of the repository, optionally for one branch.

### description

Queries the ADO Policy Configurations REST API and returns one object per build-validation policy (policy type 'Build') scoped to the
repository — the server-side pre-commit gates ([ADR-FLOW-CD-TYPE-PRECOMMITBUDGET](../../../adr/flow/pipeline-types.md#rule-adr-flow-cd-type-precommitbudget)). Each
result carries the policy id, display name, the guarded branch, the path filters (a globset-tied policy filters on its native path
projection, [ADR-FLOW-CD-GLOBS](../../../adr/flow/durable-sha-globs.md)), the pipeline definition id it queues, the blocking/enabled bits,
and the raw configuration.

Read-only — registering and removing policies is Register-AdoBuildValidation / Unregister-AdoBuildValidation.

### parameter `Branch`

Return only the policies guarding this branch (e.g. 'main'). Omit for every branch.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### example 1

```powershell
Get-AdoBuildValidations
```

### example 2

```powershell
Get-AdoBuildValidations -Branch main | Where-Object Blocking
```
