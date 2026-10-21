# Print the projection, and a drifted pipeline fails naming the filter that differs

```text
Print the projection, then a drifted pipeline fails naming the filter that differs.

1  globs.yml                    the file you edit to recompose a unit
2  Get-GlobSetTrigger           prints GitHub, AdoInclude and AdoExclude for a set
3  .ado/pipelines/cd-apex.yaml  where you paste the ADO lists, under trigger: and pr:
4  Test-GlobSetTriggerCoverage  every member of a pipeline-bound set hits an ADO include
5  matches no ADO include       the uncovered member, named in the issue
6  Test-AdoPipelineTriggerGlob  the file's four lists against the projection, as sets
7  trigger drifted              the issue names the filters that differ
8  pipeline file not found      the issue names the missing .ado/pipelines/<pipeline>.yaml

Supports FDR-CD-GLOBS-NATIVEPATHFILTER (operations lens).
```

Recomposing a deployable unit in cats is an edit to `globs.yml`, and a developer reads what the edit means for the triggers with one
command, `Get-GlobSetTrigger -Name <set>`. The Azure DevOps lists it prints go into the bound pipeline file by hand, and two quality gates
then say whether the registry and the pipelines agree: one names the pipeline and the path filter that drifted, or the file that is missing,
and the other names any member file an include pattern would miss.

![Print the projection, then drift names the filter](.assets/print-projection-then-drift-names-the-filter/diagram.drawio.png)

## Walkthrough

1. **globs.yml.** Adding or removing files from a unit, or adding a whole customer, is an edit to this file: its `include:`, `exclude:` and
   `compose:` lists, and the `pipeline:` the unit binds.
2. **Get-GlobSetTrigger.** `Get-GlobSetTrigger -Name apex` prints one object: `Name`, the ordered `GitHub` list, and the `AdoInclude` and
   `AdoExclude` lists. The set name completes from the registry, and `-GlobSet` takes a set object instead.
3. **.ado/pipelines/cd-apex.yaml.** The ado pipeline bound by `pipeline: cd-apex` declares `AdoInclude` and `AdoExclude` under both
   `trigger.paths` and `pr.paths`. No command writes them: you paste the printed lists, and the gate below tells you when they fall out of
   step.
4. **Test-GlobSetTriggerCoverage.** Run on its own or by `Test-Automation` at level 2, this quality gate takes every pipeline-bound set,
   projects it, and matches each member file against the set's `AdoInclude` patterns.
5. **Matches no ADO include.** An uncovered member is one issue:
   `<set>: member <file> matches no ADO include pattern — the include-only trigger would miss it`. Today the gate reports 0 issues over 6
   sets.
6. **Test-AdoPipelineTriggerGlob.** For every pipeline-bound set, or the one given with `-Name`, this quality gate recomputes the
   projection, reads `.ado/pipelines/<pipeline>.yaml`, and compares the file's four lists with the projection as sets.
7. **Trigger drifted.** A mismatch is one issue naming the pipeline and the lists that differ:
   `<set>: .ado/pipelines/<pipeline>.yaml trigger drifted from the globset projection on <filters>`, where the filters are any of
   `trigger.paths.include`, `trigger.paths.exclude`, `pr.paths.include` and `pr.paths.exclude`. The fix is to regenerate the pipeline
   trigger from `globs.yml`.
8. **Pipeline file not found.** A bound pipeline whose file is absent is one issue:
   `<set>: pipeline file not found: .ado/pipelines/<pipeline>.yaml`. Either gate writes its report under `out/test-<subject>/` and throws
   once, `<gate> failed: N issue(s)`, listing every issue; with `-PassThru` it returns the result instead. Today both report 0 issues over 6
   pipelines.

The GitHub side has the same gate, `Test-GitHubWorkflowTriggerGlob`, which takes the pairing explicitly, for example
`-Name pwsh -WorkflowPath .github/workflows/ci-pwsh.yml`, and compares `on.push.paths` and `on.pull_request.paths` element by element, since
GitHub paths are ordered.

## Why it holds

- A pipeline, workflow or build-validation policy triggers on the globset's native projection, and the drift quality gates report one issue
  per pipeline whose declared trigger no longer equals its projection, or whose file is missing (FDR-CD-GLOBS-NATIVEPATHFILTER).
- An include-only projection is a safe superset that can never under-trigger, which the coverage check confirms for every member of a
  pipeline-bound set (FDR-CD-GLOBS, "How this is enforced").

## Where the code and the decision record differ

- The ADR says the projected filters are generated from `globs.yml` into the YAML and never hand-authored. No command writes them; the
  developer pastes the printed lists into the pipeline file, and the gate catches a mismatch.

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same projection: [meta](one-program-two-vendor-dialects.md),
  [architecture](globs-projects-and-three-consumers-read.md), [implementation](apex-thirteen-rules-seven-includes-six-excludes.md) and
  [governance](drift-is-gated-generation-is-adr-only.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
