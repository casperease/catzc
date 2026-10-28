# Azure DevOps: Pipeline triggers — the ado path filters, build validation, schedules and parameters

## Rules: ADR-ADO-TRIGGER

### Rule ADR-ADO-TRIGGER-PATHSPROJECTION

A root pipeline triggers on its globset's projection into `trigger.paths.include`/`exclude`
([FDR-GLOBS-NATIVEPATHFILTER](../flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter)). Azure DevOps path filters are
order-independent (union include minus union exclude), so each pattern is collapsed to its last select in the scan program, and a compose
re-add becomes a deeper-folder include, which Azure DevOps keeps over a broader exclude.

- [The trigger.paths projection](#the-triggerpaths-projection)

### Rule ADR-ADO-TRIGGER-BUILDVALIDATION

The pre-commit run of the CI engine is a build-validation policy on the pull request's target branch, and its `filenamePatterns` path filter
is the same projection, `/`-anchored (`Get-BuildValidationPathFilter`). The policy lives server-side, so the unit's composition still lives
only in `globs.yml`.

- [Build validation](#build-validation)

### Rule ADR-ADO-TRIGGER-PATHSDRIFTGATE

`Test-AdoPipelineTriggerGlob` recomputes the projection of every pipeline-bound globset and reports one issue per pipeline whose declared
`trigger.paths` no longer equals its projection, or whose file is missing; `Test-GlobSetTriggerCoverage` confirms every member of a bound
set is covered by an include pattern.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-ADO-TRIGGER-PARAMETERSONINPUT

Runtime pipeline `parameters:` are an INPUT pipeline's intake and a DEPLOY pipeline's commit and target selection; a CRON pipeline carries a
`schedules:` trigger and no parameters, or a bounded set with defaults that select a control
([FDR-TYPE-CONFIGENTERSTHROUGHINPUT](../flow/pipeline-types.md#rule-fdr-type-configentersthroughinput)).

- [Schedules and parameters](#schedules-and-parameters)

## Context

The flow domain decides that a pipeline triggers on its unit's globset projected into the vendor's path-filter dialect, that the CI engine
runs before and after the merge, and that configuration enters only through INPUT. Azure DevOps spells each of these in its own constructs:
`trigger:` and `pr:` path filters at a pipeline's root, build-validation branch policies, `schedules:`, and runtime `parameters:`.

## Decision

### The trigger.paths projection

`Get-GlobSetTrigger` renders the program into the root pipeline's `trigger.paths`, generated from `globs.yml` and never hand-authored; the
`trigger:` and `pr:` keys are honoured only at the pipeline root, never inside a template. The one semantic seam, Azure DevOps'
order-independence against the positional last-match-wins of the scan program, coincides for every folder-shaped set, and a set whose
projection cannot reproduce exact membership is caught at generation time, not silently mis-triggered. Azure DevOps Services and Server
2022+ accept wildcards anywhere in a path filter, so the projection is a real no-start trigger, not a start-then-bail:

```yaml
trigger:
  branches:
    include: [main]
  paths:
    include:
      - infrastructure/templates/discovery/**
      - infrastructure/modules/**
      - infrastructure/templates/discovery/configuration/contoso/**
    exclude:
      - infrastructure/templates/discovery/configuration/*.yml
      - infrastructure/templates/discovery/configuration/*/**
```

### Build validation

The CI engine's pre-commit run is an Azure DevOps build validation on the PR branch, and its post-commit run is the `main` trigger above;
both register on the same projection, so the policy and the pipeline select the same files.

### Schedules and parameters

A CRON pipeline is the ado pipeline mechanism used as a scheduler: a `schedules:` cron entry and one `RunCommand`. An INPUT pipeline takes
its user input as ado runtime `parameters:`, the one legitimate home for parameters that carry values, because those values are written into
version control before anything deploys. A DEPLOY pipeline's parameters name a commit and a governed target, never configuration.

### How this is enforced

- `Test-AdoPipelineTriggerGlob` is a quality gate; its integrity test requires zero issues, so a hand-edited or drifted `paths:` filter in
  `.ado/pipelines/*.yaml` fails `Test-Automation` locally and in CI (ADR-ADO-TRIGGER-PATHSDRIFTGATE).
- `Test-GlobSetTriggerCoverage` proves the include-only projection is a safe superset that never under-triggers; `Test-GlobSetAffected` adds
  exactness inside the run.

## Consequences

- One edit to `globs.yml` regenerates every ado trigger and build-validation filter; no pipeline is filtered by hand.
- The Azure DevOps spellings of the flow model sit in one record, so the flow records stay vendor-neutral.
