---
catzc:
  derived:
    path: docs/explanation/flow/gates-check-source-and-trigger.md
    kind: explanation
    body_sha: "162cf941ab68"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#{1-10}
      - ADR-REPO-PROTGLOB#5
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png
      - docs/adr/automation/test-automation.md
      - docs/adr/flow/durable-sha-globs.md
      - docs/adr/repository/protected-globs.md
      - docs/explanation/flow/edit-globs-yml-then-read-the-output.md
      - docs/explanation/flow/globs-module-owns-config-and-types.md
      - docs/explanation/flow/index.md
      - docs/explanation/flow/one-scan-program-feeds-three-roles.md
      - docs/explanation/flow/three-views-derived-live-from-one-program.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Gates check the source of each globset and the trigger, but not the git reflection or the identity

```text
Gates check the source of each globset and the trigger, but not the git reflection or the identity.

1  Registry                  globs.yml, the one source of truth; every set carries a layer
2  Test-GlobSetIndependence  quality gate: same-layer sets never overlap on own contribution
3  Config load               rejects malformed patterns and bad compose when the config loads
4  Scan program              the dialect, the ordered program, compose with own rules last
5  Native projection         what pipelines, workflows and policies trigger on
6  Trigger gates             three quality gates that check the projection
7  Git reflection            the change check from git at real refs; no gate checks it
8  Live identity             the durable SHA, never committed; no gate checks it

Supports ADR-FLOW-CD-GLOBS#1 to #10 and ADR-AUTO-TEST#35 (governance lens).
```

The globset rules in cats are checked by four quality gates plus the config load, and those checks reach the registry, the program and the
trigger. Every globset flows from one registry through a validated load into a flattened scan program, and from there into three roles, and
the ADR rules constrain each stage. The git reflection and the live identity are held by ADR rules alone: no gate checks them, which is
worth knowing before relying on either.

![Gates check the source of each globset and the trigger only](../../.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md).

## Walkthrough

1. **Registry.** `globs.yml` is the one source of truth (#1). Every set carries a layer (#7), and same-layer sets never overlap on their own
   contribution (#10).
2. **Test-GlobSetIndependence.** This quality gate checks #10 over the declared registry and the derived module sets together. A violation
   names both sets and a shared file.
3. **Config load.** `GlobsConfig` rejects malformed patterns (#3) and self-referencing, unknown or cyclic compose (#8) when the config is
   loaded, and throws once with every error. It is a load-time check, not a quality gate.
4. **Scan program.** The dialect (#2), the ordered last-match-wins program over tracked files (#4), and compose with the set's own rules
   last (#8) define what the program is.
5. **Native projection.** Pipelines, workflows and build-validation policies trigger on the projection of the program into each vendor's
   path-filter dialect (#6).
6. **`Trigger gates`.** Three quality gates check the projection: `Test-AdoPipelineTriggerGlob` and `Test-GitHubWorkflowTriggerGlob` report
   one issue per drifted or missing pipeline or workflow, and `Test-GlobSetTriggerCoverage` confirms every member of a pipeline-bound set is
   covered by an ADO include. Their integrity tests require zero issues, so a drifted filter fails `Test-Automation` locally and in CI.
7. **Git reflection.** Whether a change touches a set is computed from git at real refs and fails open on any doubt (#9). No gate checks
   this, and no pipeline calls `Test-GlobSetAffected` today.
8. **Live identity.** The durable SHA is computed live, never committed, and keys the session-memory protection map (#5). No gate checks
   that it stays uncommitted.

## Why it holds

- One registry in `globs.yml` maps every area-of-control, and its three roles are derived (ADR-FLOW-CD-GLOBS#1).
- A pattern is repo-relative and `/`-separated, with `**` as the only cross-segment operator (ADR-FLOW-CD-GLOBS#2), and malformed patterns
  are rejected at config load (ADR-FLOW-CD-GLOBS#3).
- Membership is an ordered scan program over tracked files, evaluated last-match-wins (ADR-FLOW-CD-GLOBS#4), and compose puts the base first
  and the set's own rules last (ADR-FLOW-CD-GLOBS#8).
- The identity is live and never committed (ADR-FLOW-CD-GLOBS#5); triggers are the native projection (ADR-FLOW-CD-GLOBS#6); the change check
  reflects git (ADR-FLOW-CD-GLOBS#9).
- Every set carries a layer (ADR-FLOW-CD-GLOBS#7), and sets in one layer never overlap on their own contribution (ADR-FLOW-CD-GLOBS#10).
- A quality gate checks one property of the whole repository, collects every issue and throws once (ADR-AUTO-TEST#35).
- The projected filters are generated from `globs.yml`, never hand-authored (ADR-FLOW-CD-GLOBS#6); this part is held by the ADR alone, since
  the gates check equality with the projection but nothing writes the YAML.

## Where the code and the ADR differ

- The ADR calls `Test-GlobSetAffected` "the in-pipeline check", but no pipeline or workflow invokes it; `cd-shared.yaml` names it only in a
  comment.
- The ADR says the filters are generated into the YAML and that an ADO projection that cannot reproduce exact membership is caught at
  generation time. No generator writes the YAML, `Get-GlobSetTrigger` defers that case to the superset integrity test, and `cd-shared.yaml`
  documents exactly such a case, which `Test-GlobSetTriggerCoverage`, checking ADO includes only, passes.
- `Test-GlobSetAffected` and `Get-GlobSetChangeRange` cite fail-open as ADR-REPO-PROTGLOB#5; for the change check the ADR states it in
  ADR-FLOW-CD-GLOBS#9.

## See also

- [Globset triggers](../../adr/flow/durable-sha-globs.md) — the decision this article explains, with
  [test automation](../../adr/automation/test-automation.md) and [protected globs](../../adr/repository/protected-globs.md).
- The other lenses on the same globset roles: [meta](three-views-derived-live-from-one-program.md),
  [architecture](globs-module-owns-config-and-types.md), [implementation](one-scan-program-feeds-three-roles.md) and
  [operations](edit-globs-yml-then-read-the-output.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
