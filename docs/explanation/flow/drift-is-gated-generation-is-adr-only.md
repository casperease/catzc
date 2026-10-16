---
catzc:
  immutable:
    with_body_sha: "37f8531166d7"
    repo_status: clean
    path: docs/explanation/flow/drift-is-gated-generation-is-adr-only.md
    folder: docs/explanation/flow
    name: drift-is-gated-generation-is-adr-only
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#{1,4,6,8}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.md
      - docs/.assets/explanation/adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.png
      - docs/adr/automation/test-automation.md
      - docs/adr/flow/durable-sha-globs.md
      - docs/explanation/flow/apex-thirteen-rules-seven-includes-six-excludes.md
      - docs/explanation/flow/globs-projects-and-three-consumers-read.md
      - docs/explanation/flow/index.md
      - docs/explanation/flow/one-program-two-vendor-dialects.md
      - docs/explanation/flow/print-projection-then-drift-names-the-filter.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Three gates check the projection, while generation and the in-pipeline backstop are held by the ADR alone

```text
Three gates check the projection; generation and the in-pipeline backstop are ADR-only.

1  flattened scan program         #8 checked at config load; #4 held by no gate
2  GitHub paths                   #6: exact, ordered, ! negation
3  ADO include and exclude        #6: each pattern's last select
4  generated YAML filters         #6 says generated, never hand-authored; no code writes them
5  Test-GitHubWorkflowTriggerGlob quality gate: the workflow's ordered paths equal the projection
6  Test-AdoPipelineTriggerGlob    quality gate: the pipeline's four lists equal the projection
7  Test-GlobSetTriggerCoverage    quality gate: every member hits an ADO include
8  in-pipeline exact backstop     the ADR's Test-GlobSetAffected step; no pipeline calls it

Supports ADR-FLOW-CD-GLOBS#4, #6 and #8, and ADR-AUTO-TEST#35 (governance lens).
```

The projection of a globset into vendor path filters is the stage of the globset rules in cats that quality gates cover best: three gates
check that every bound workflow and pipeline declares its projection and that the Azure DevOps includes cover every member. Two things the
ADR states around the projection have no code behind them: that the YAML filters are generated rather than written by hand, and that
`Test-GlobSetAffected` runs first in every pipeline as the exact backstop. Both are worth knowing before relying on them.

![Three gates check the projection; generation and the backstop are ADR-only](../../.assets/explanation/adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.md).

## Walkthrough

1. **Flattened scan program.** Compose puts the base first and the set's own rules last (#8); `GlobsConfig` rejects a self-reference, an
   unknown reference or a cycle when the config loads, a load-time check rather than a quality gate. The last-match-wins evaluation of the
   program (#4) is held by no gate: it is the mechanism every gate relies on.
2. **GitHub paths.** The program in order with `!` negation (#6), exact by construction. The build-validation policy's `filenamePatterns`
   also take this list, anchored with `/`, where the ADR names the Azure DevOps lists.
3. **ADO include and exclude.** Each pattern's last select (#6). The lists lose the order, and the ADR's own safety argument for them is
   that Azure DevOps keeps a deeper-folder include over a broader exclude.
4. **Generated YAML filters.** The ADR says the filters are generated from `globs.yml` into the orchestration YAML and never hand-authored,
   and that a set whose Azure DevOps projection cannot reproduce exact membership is caught at generation time. No code in the tree writes a
   `paths:` filter, and `Get-GlobSetTrigger` defers that case to the coverage check.
5. **Test-GitHubWorkflowTriggerGlob.** A quality gate: it recomputes the ordered GitHub list and compares it element by element with
   `on.push.paths` and `on.pull_request.paths` of the workflow it is given, one issue per drifted or missing workflow.
6. **Test-AdoPipelineTriggerGlob.** A quality gate: for every pipeline-bound set it compares the `trigger:` and `pr:` include and exclude
   lists of `pipelines/<pipeline>.yaml` with the projection as sets, one issue per drifted or missing pipeline.
7. **Test-GlobSetTriggerCoverage.** A quality gate: every member of a pipeline-bound set matches one of its Azure DevOps include patterns,
   so an include-only trigger is a superset that never under-triggers. It checks includes only, so a set whose root `.yml` an equal-depth
   exclude may drop passes it; `cd-shared.yaml` documents such a set.
8. **In-pipeline exact backstop.** The ADR has `Test-GlobSetAffected` run first in the pipeline to supply exactness on top of the superset.
   The function exists and fails open, but no pipeline or workflow step calls it; `cd-shared.yaml` names it only in a comment.

The three gates each collect every issue, write a report through `Write-QualityGateReport` and throw once, and an L2 integrity test of each
requires zero issues, so a drifted filter fails `Test-Automation` locally and in CI.

## Why it holds

- Membership is the ordered scan program evaluated last-match-wins, with precedence by position (ADR-FLOW-CD-GLOBS#4).
- A pipeline, workflow or build-validation policy triggers on the native projection, generated from `globs.yml`, and the drift quality gates
  report one issue per pipeline whose declared trigger no longer equals its projection or whose file is missing (ADR-FLOW-CD-GLOBS#6).
- A composing set's program is the composed programs first and its own rules last, validated at config load (ADR-FLOW-CD-GLOBS#8).
- A quality gate is one `Test-<subject>` function that checks one property of the whole repository, collects every issue, writes its report
  and throws once, and an integrity test runs it at its tier (ADR-AUTO-TEST#35).

## Where the code and the ADR differ

- The ADR says the projected filters are generated from `globs.yml` into the YAML; nothing in the tree writes them, so they are kept by hand
  and only compared.
- The ADR says a set whose Azure DevOps projection cannot reproduce exact membership is caught at generation time; `Get-GlobSetTrigger`
  defers it to `Test-GlobSetTriggerCoverage`, which checks includes only, and `cd-shared.yaml` documents a set where Azure DevOps may drop a
  root `.yml`.
- The ADR calls `Test-GlobSetAffected` the exact backstop the pipeline runs first; no pipeline or workflow step calls it.
- The ADR says branch-policy `filenamePatterns` use the Azure DevOps projection; `Get-BuildValidationPathFilter` anchors the GitHub list
  instead.
- `Get-GlobSetTrigger` and the three gates cite ADR-FLOW-CD-GLOBS#1 in their help, where #6 defines the projection and its gates.

## See also

- [Globset triggers](../../adr/flow/durable-sha-globs.md) — the decision this article explains, with
  [test automation](../../adr/automation/test-automation.md).
- The other lenses on the same projection: [meta](one-program-two-vendor-dialects.md),
  [architecture](globs-projects-and-three-consumers-read.md), [implementation](apex-thirteen-rules-seven-includes-six-excludes.md) and
  [operations](print-projection-then-drift-names-the-filter.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
