# pwsh/Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1

The command that creates or updates the build-validation branch policy tied to a globset. It is idempotent, and every value defaults from
`build-validation.yml`, `globs.yml` and `ado.yml`.

## help

### synopsis

Registers (creates or updates) the build-validation branch policy tied to a globset. Idempotent.

### description

Binds the globset's native path projection (Get-GlobSetTrigger, [FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)) as the path filter of
an ADO build-validation policy that queues the resolved pipeline on the guarded branch — the server-side pre-commit half of the unit's CI
binding ([FDR-TYPE-PRECOMMITBUDGET](../../../drs/flow/pipeline-types.md#rule-fdr-type-precommitbudget)). Everything defaults from local
config: the pipeline resolves -Pipeline, then the globset's build-validation.yml entry, then the globset's own 'pipeline:' annotation in
globs.yml; the branch resolves -Branch, then build-validation.yml 'branch'; blocking and the display name come from the entry (defaults:
blocking, 'Build validation - `<globset>`'). The policy is Azure DevOps configuration, an adjacent store
([TDR-ONETRUTH-REPOSITORYISRECORD](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-repositoryisrecord)), driven one way from
the repository and never edited beside the trunk.

Idempotent ([ADR-AUTO-IDEM](../../../drs/automation/idempotent-state-functions.md)): an existing policy for the same pipeline on the same
branch is updated when it differs and left alone when current; the resulting policy configuration is returned either way. The matching
existing policy is found by pipeline definition + branch, so a marker-path or display-name change updates the policy in place instead of
creating a duplicate.

### parameter `GlobSet`

The declared globset the policy is tied to (a name in globs.yml).

### parameter `Pipeline`

The pipeline (build definition) name to queue. Defaults from the globset's build-validation.yml entry, then its globs.yml 'pipeline:'
annotation.

### parameter `Branch`

The branch the policy guards. Defaults from build-validation.yml 'branch'.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter `DryRun`

Return the planned action (Create/Update/Unchanged with the resolved pipeline, branch, and path filter) without touching the server.

### example 1

```powershell
Register-AdoBuildValidation automation
```

### example 2

```powershell
Register-AdoBuildValidation nova -Branch main -DryRun
```

## The path filter

The server-side pre-commit trigger filters on the globset's native path projection (`Get-BuildValidationPathFilter`, which reads
`Get-GlobSetTrigger`; [FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)). These are the same globs the pipeline triggers on, never a
committed marker.
