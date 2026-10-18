---
catzc:
  immutable:
    with_body_sha: "50c174fff6f9"
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
    folder: docs/references/automation/catzc-azure-devops-buildvalidation
    name: register-ado-build-validation-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Registers (creates or updates) the build-validation branch policy tied to a globset. Idempotent.

### description

Binds the globset's native path projection (Get-GlobSetTrigger, [ADR-FLOW-CD-GLOBS](../../../adr/flow/durable-sha-globs.md)) as the path
filter of an ADO build-validation policy that queues the resolved pipeline on the guarded branch — the server-side pre-commit half of the
unit's CI binding ([ADR-FLOW-CD-TYPE#4](../../../adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Everything defaults from local config:
the pipeline resolves -Pipeline, then the globset's build-validation.yml entry, then the globset's own 'pipeline:' annotation in globs.yml;
the branch resolves -Branch, then build-validation.yml 'branch'; blocking and the display name come from the entry (defaults: blocking,
'Build validation - `<globset>`').

Idempotent ([ADR-AUTO-IDEM](../../../adr/automation/idempotent-state-functions.md)): an existing policy for the same pipeline on the same
branch is updated when it differs and left alone when current; the resulting policy configuration is returned either way. The matching
existing policy is found by pipeline definition + branch, so a marker-path or display-name change updates the policy in place instead of
creating a duplicate.

### parameter GlobSet

The declared globset the policy is tied to (a name in globs.yml).

### parameter Pipeline

The pipeline (build definition) name to queue. Defaults from the globset's build-validation.yml entry, then its globs.yml 'pipeline:'
annotation.

### parameter Branch

The branch the policy guards. Defaults from build-validation.yml 'branch'.

### parameter Project

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter Organization

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter RepositoryName

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter DryRun

Return the planned action (Create/Update/Unchanged with the resolved pipeline, branch, and path filter) without touching the server.

### example 1

```powershell
Register-AdoBuildValidation automation
```

### example 2

```powershell
Register-AdoBuildValidation nova -Branch main -DryRun
```

## comment:1

Above `$pathFilters = Get-BuildValidationPathFilter -GlobSet $set`, written with `#`.

```text
The server-side pre-commit trigger filters on the globset's native path projection
(Get-BuildValidationPathFilter -> Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) — the same globs the pipeline
triggers on — never a committed marker.
```
