# automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes the build-validation branch policy tied to a globset. Idempotent — a no-op when none exists.

### description

Finds the build-validation policy whose path filter is the globset's native projection
(Get-GlobSetTrigger, [ADR-FLOW-CD-GLOBS](../../../adr/flow/durable-sha-globs.md) — the tie between policy and globset)
on the guarded branch and deletes
it. When no such policy exists the function reports and returns without error
([ADR-AUTO-IDEM#2](../../../adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)).

### parameter GlobSet

The declared globset whose policy to remove (a name in globs.yml).

### parameter Branch

The branch the policy guards. Defaults from build-validation.yml 'branch'.

### parameter Project

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter Organization

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter RepositoryName

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter DryRun

Return the planned removal (the matched policy id) without touching the server.

### example 1

```powershell
Unregister-AdoBuildValidation nova
```

### example 2

```powershell
Unregister-AdoBuildValidation nova -DryRun
```
