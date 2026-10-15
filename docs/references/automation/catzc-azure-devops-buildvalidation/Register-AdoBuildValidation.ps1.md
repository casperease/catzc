---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
    kind: comment-page
    body_sha: ee8acc1a45e6
    adrs:
      - ADR-FLOW-CD-TYPE#4
---

# automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Binds the globset's native path projection (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) as the path filter of an
ADO build-validation policy that queues the resolved pipeline on the guarded branch — the server-side
pre-commit half of the unit's CI binding
([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Everything defaults from local
config: the
pipeline resolves -Pipeline, then the globset's build-validation.yml entry, then the globset's own
'pipeline:' annotation in globs.yml; the branch resolves -Branch, then build-validation.yml 'branch';
blocking and the display name come from the entry (defaults: blocking, 'Build validation - <globset>').

Idempotent ([ADR-AUTO-IDEM](/docs/adr/automation/idempotent-state-functions.md)): an existing policy for the same
pipeline on the same branch is updated when it
differs and left alone when current; the resulting policy configuration is returned either way. The
matching existing policy is found by pipeline definition + branch, so a marker-path or display-name
change updates the policy in place instead of creating a duplicate.
```

## comment:2

Section `.PARAMETER Pipeline` of the comment-based help.

```text
The pipeline (build definition) name to queue. Defaults from the globset's build-validation.yml entry,
then its globs.yml 'pipeline:' annotation.
```

## comment:3

Section `.PARAMETER DryRun` of the comment-based help.

```text
Return the planned action (Create/Update/Unchanged with the resolved pipeline, branch, and path
filter) without touching the server.
```

## comment:4

Above `$pathFilters = Get-BuildValidationPathFilter -GlobSet $set`.

```text
The server-side pre-commit trigger filters on the globset's native path projection
(Get-BuildValidationPathFilter -> Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) — the same globs the pipeline
triggers on — never a committed marker.
```
