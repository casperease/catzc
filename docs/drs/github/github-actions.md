# ADR: GitHub Actions — the run mark and the path-filter triggers of a workflow

## Rules: ADR-GH-ACTIONS

### Rule ADR-GH-ACTIONS-RUNNERRUNMARK

`GITHUB_ACTIONS` is the GitHub run mark: the runner sets it on every workflow run and never interactively, and the one detection point reads
it ([FDR-PIPELINE-CONTEXTDETECTEDONCE](../flow/pipeline-concept.md#rule-fdr-pipeline-contextdetectedonce)).

- [The runner's run mark](#the-runners-run-mark)

### Rule ADR-GH-ACTIONS-ONPATHSPROJECTION

A workflow triggers on its globset's projection into `on.*.paths`
([FDR-GLOBS-NATIVEPATHFILTER](../flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter)): the flattened scan program in order, each `-`
rule rendered as a `!` negation. GitHub paths are ordered and last-match-wins, the same evaluator as `GlobSet.Matches`, so the projection is
exact.

- [The on.\*.paths projection](#the-onpaths-projection)

### Rule ADR-GH-ACTIONS-ONPATHSDRIFTGATE

`Test-GitHubWorkflowTriggerGlob` recomputes the projection of every workflow-bound globset and reports one issue per workflow whose declared
`paths:` no longer equals its projection, or whose file is missing; its integrity test requires zero issues.

- [How this is enforced](#how-this-is-enforced)

## Context

The flow domain decides that a pipeline knows its context from one detection point and that it triggers on its unit's globset projected into
the vendor's own path-filter dialect. GitHub Actions supplies the two vendor facts those rules need: the variable that marks a workflow run,
and the `on.*.paths` dialect a workflow filters on.

## Decision

### The runner's run mark

The GitHub Actions runner sets `GITHUB_ACTIONS=true` on every run, so the detection point treats it as the GitHub run mark. Nothing else
reads it.

### The on.\*.paths projection

`Get-GlobSetTrigger` renders the program into the workflow's `push` and `pull_request` filters, generated from `globs.yml` and never
hand-authored. GitHub accepts wildcards anywhere in a path filter and evaluates the list in order, so the projection is a true no-start
trigger with exact membership:

```yaml
on:
  push:
    branches: [main]
    paths: [pwsh/**]
  pull_request:
    branches: [main]
    paths: [pwsh/**]
```

### How this is enforced

- `Test-GitHubWorkflowTriggerGlob` is a quality gate: a hand-edited or drifted `paths:` filter under `.github/workflows/` fails
  `Test-Automation` locally and in CI (ADR-GH-ACTIONS-ONPATHSDRIFTGATE).
- The analyzer rule that guards the one detection function flags a raw read of `GITHUB_ACTIONS` (ADR-GH-ACTIONS-RUNNERRUNMARK).

## Consequences

- A workflow's trigger is its unit's real path filter, renames and moves included, and it cannot drift from `globs.yml` unseen.
- The GitHub-specific facts sit in one record, so the flow model stays vendor-neutral.
