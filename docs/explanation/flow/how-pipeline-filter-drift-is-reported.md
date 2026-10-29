# How pipeline filter drift is reported

```text
How pipeline filter drift is reported.

1  globs.yml                    the file you edit to recompose a unit
2  Get-GlobSetTrigger           prints GitHub, AdoInclude and AdoExclude for a set
3  .ado/pipelines/cd-apex.yaml  where you paste the ADO lists, under trigger: and pr:
4  Test-GlobSetTriggerCoverage  every member of a pipeline-bound set hits an ADO include
5  matches no ADO include       the uncovered member, named in the issue
6  Test-AdoPipelineTriggerGlob  the file's four lists against the projection, as sets
7  trigger drifted              the issue names the filters that differ
8  pipeline file not found      the issue names the missing .ado/pipelines/<pipeline>.yaml

Supports FDR-GLOBS-NATIVEPATHFILTER (operations lens).
```

Recomposing a deployable unit in cats is an edit to `globs.yml`, and a developer reads what the edit means for the triggers with one
command, `Get-GlobSetTrigger -Name <set>`. The Azure DevOps lists it prints go into the bound pipeline file by hand, and two quality gates
then say whether the registry and the pipelines agree: one names the pipeline and the path filter that drifted, or the file that is missing,
and the other names any member file an include pattern would miss.

```yml drawio
description:
  "The operator's path through a unit's triggers: edit globs.yml, print the projection with Get-GlobSetTrigger, paste the Azure DevOps lists
  into the pipeline file, and two gates fail naming the missing include, the drifted filter or the missing file."
about:
  rules: [FDR-GLOBS-NATIVEPATHFILTER]
  lens: operations
content:
  title: How pipeline filter drift is reported
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-compose, label: COMPOSE }
    - { id: band-projection, label: PROJECTION }
    - { id: band-checked, label: CHECKED BY }
  glyphs:
    - { id: f-globs-yml, kind: file, label: globs.yml, in: band-compose }
    - { id: c-trigger, kind: code, label: Get-GlobSetTrigger, in: band-projection }
    - { id: f-cd-apex, kind: file, label: .ado/pipelines/cd-apex.yaml, in: band-projection }
    - { id: g-coverage, kind: gate, label: Test-GlobSetTriggerCoverage, in: band-checked }
    - { id: x-no-include, kind: failure, label: matches no ADO include, in: band-checked }
    - { id: g-trigger-glob, kind: gate, label: Test-AdoPipelineTriggerGlob, in: band-checked }
    - { id: x-drifted, kind: failure, label: trigger drifted, in: band-checked }
    - { id: x-not-found, kind: failure, label: pipeline file not found, in: band-checked }
  edges:
    - { from: c-trigger, to: f-globs-yml, kind: flow, label: reads }
    - { from: c-trigger, to: f-cd-apex, kind: record, label: "" }
    - { from: c-trigger, to: g-coverage, kind: flow, label: "" }
    - { from: c-trigger, to: g-trigger-glob, kind: flow, label: "" }
    - { from: f-cd-apex, to: g-trigger-glob, kind: flow, label: "" }
    - { from: g-coverage, to: x-no-include, kind: fail, label: "" }
    - { from: g-trigger-glob, to: x-drifted, kind: fail, label: "" }
    - { from: g-trigger-glob, to: x-not-found, kind: fail, label: "" }
  markers:
    - { at: f-globs-yml, number: 1 }
    - { at: c-trigger, number: 2 }
    - { at: f-cd-apex, number: 3 }
    - { at: g-coverage, number: 4 }
    - { at: x-no-include, number: 5 }
    - { at: g-trigger-glob, number: 6 }
    - { at: x-drifted, number: 7 }
    - { at: x-not-found, number: 8 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-compose: { x: 20, y: 84, w: 1260, h: 120 }
  band-projection: { x: 20, y: 224, w: 1260, h: 120 }
  band-checked: { x: 20, y: 364, w: 1260, h: 210 }
  f-globs-yml: { x: 160, y: 124, w: 140, h: 56 }
  c-trigger: { x: 130, y: 262, w: 510, h: 44 }
  f-cd-apex: { x: 720, y: 258, w: 200, h: 56 }
  g-coverage: { x: 110, y: 404, w: 240, h: 80 }
  x-no-include: { x: 140, y: 514, w: 180, h: 44 }
  g-trigger-glob: { x: 600, y: 404, w: 240, h: 80 }
  x-drifted: { x: 920, y: 400, w: 180, h: 44 }
  x-not-found: { x: 920, y: 462, w: 180, h: 44 }
```

![How pipeline filter drift is reported](.assets/how-pipeline-filter-drift-is-reported.drawio.png)

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
  per pipeline whose declared trigger no longer equals its projection, or whose file is missing (FDR-GLOBS-NATIVEPATHFILTER).
- An include-only projection is a safe superset that can never under-trigger, which the coverage check confirms for every member of a
  pipeline-bound set (FDR-GLOBS, "How this is enforced").

## Where the code and the decision record differ

- The FDR says the projected filters are generated from `globs.yml` into the YAML and never hand-authored. No command writes them; the
  developer pastes the printed lists into the pipeline file, and the gate catches a mismatch.

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same projection: [meta](one-program-two-vendor-dialects.md),
  [architecture](globs-projects-and-three-consumers-read.md), [implementation](how-the-apex-unit-flattens-into-path-filters.md) and
  [governance](which-gates-check-the-generated-projection.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
