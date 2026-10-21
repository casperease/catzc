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

Supports FDR-CD-GLOBS-NAMEDGLOBSETS, FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS, FDR-CD-GLOBS-MALFORMEDPATTERNREJECTED, FDR-CD-GLOBS-TRACKEDFILESONLY, FDR-CD-GLOBS-DURABLESHAIDENTITY, FDR-CD-GLOBS-NATIVEPATHFILTER, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER and ADR-AUTO-TEST-QUALITYGATE (governance lens).
```

The globset rules in cats are checked by four quality gates plus the config load, and those checks reach the registry, the program and the
trigger. Every globset flows from one registry through a validated load into a flattened scan program, and from there into three roles, and
the DRS rules constrain each stage. The git reflection and the live identity are held by DRS rules alone: no gate checks them, which is
worth knowing before relying on either.

![Gates check the source of each globset and the trigger only](.assets/gates-check-source-and-trigger/diagram.drawio.png)

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

- One registry in `globs.yml` maps every area-of-control, and its three roles are derived (FDR-CD-GLOBS-NAMEDGLOBSETS).
- A pattern is repo-relative and `/`-separated, with `**` as the only cross-segment operator (FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS), and
  malformed patterns are rejected at config load (FDR-CD-GLOBS-MALFORMEDPATTERNREJECTED).
- Membership is an ordered scan program over tracked files, evaluated last-match-wins (FDR-CD-GLOBS-TRACKEDFILESONLY), and compose puts the
  base first and the set's own rules last (FDR-CD-GLOBS-COMPOSESETS).
- The identity is live and never committed (FDR-CD-GLOBS-DURABLESHAIDENTITY); triggers are the native projection
  (FDR-CD-GLOBS-NATIVEPATHFILTER); the change check reflects git (FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT).
- Every set carries a layer (FDR-CD-GLOBS-EVERYSETHASLAYER), and sets in one layer never overlap on their own contribution
  (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER).
- A quality gate checks one property of the whole repository, collects every issue and throws once (ADR-AUTO-TEST-QUALITYGATE).
- The projected filters are generated from `globs.yml`, never hand-authored (FDR-CD-GLOBS-NATIVEPATHFILTER); this part is held by the FDR
  alone, since the gates check equality with the projection but nothing writes the YAML.

## Where the code and the decision record differ

The FDR says the filters are generated into the YAML and that an ADO projection that cannot reproduce exact membership is caught at
generation time. No generator writes the YAML, `Get-GlobSetTrigger` defers that case to the superset integrity test, and `cd-shared.yaml`
documents exactly such a case, which `Test-GlobSetTriggerCoverage`, checking ADO includes only, passes.

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains, with
  [test automation](../../drs/automation/test-automation.md) and [protected globs](../../drs/repository/protected-globs.md).
- The other lenses on the same globset roles: [meta](three-views-derived-live-from-one-program.md),
  [architecture](globs-module-owns-config-and-types.md), [implementation](one-scan-program-feeds-three-roles.md) and
  [operations](edit-globs-yml-then-read-the-output.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
