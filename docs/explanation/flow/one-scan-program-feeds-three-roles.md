# What the scan program feeds

```text
What the scan program feeds.

1  globs.yml               the globsets map, read by Get-Config -Config globs
2  GlobsConfig             validates the registry at load and throws once with every error
3  GlobSet.ScanProgram()   composed programs first, own rules last, deduped, cached
4  Get-GlobSetTrigger      projects the program into GitHub and Azure DevOps path filters
5  Get-ChangedGlobSet      matches git's changed paths against every set
6  Get-GlobSetHash         folds the members' CR-stripped SHA-256 digests into one identity
7  Trigger gates           compare the projection with what pipelines and workflows declare
8  Test-GlobSetAffected    answers "is this set touched?", failing open on doubt
9  Test-GlobSetProtection  compares the live identity with the recorded one

Supports FDR-GLOBS-TRACKEDFILESONLY, FDR-GLOBS-DURABLESHAIDENTITY, FDR-GLOBS-NATIVEPATHFILTER
and FDR-GLOBS-CHANGECOMPUTEDFROMGIT (implementation lens).
```

`GlobSet.ScanProgram()` is the one method behind a globset's membership, its trigger and its identity in cats. The code runs from
`globs.yml` through the validating load to that method, then to the three role functions and the function that reads each one's output.
Knowing that one method sits behind all three roles tells a reader where a change to the dialect or to compose lands.

```yml drawio
description:
  "The code path behind a globset: globs.yml through the validating load to GlobSet.ScanProgram(), then to the three role functions and the
  callers that read each one's output."
about:
  rules: [FDR-GLOBS-TRACKEDFILESONLY, FDR-GLOBS-DURABLESHAIDENTITY, FDR-GLOBS-NATIVEPATHFILTER, FDR-GLOBS-CHANGECOMPUTEDFROMGIT]
  lens: implementation
content:
  title: What the scan program feeds
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-config, label: CONFIG }
    - { id: band-program, label: PROGRAM }
    - { id: band-functions, label: FUNCTIONS }
    - { id: band-callers, label: CALLERS }
  glyphs:
    - { id: f-globs-yml, kind: file, label: globs.yml, in: band-config }
    - { id: c-globs-config, kind: type, label: GlobsConfig, in: band-config }
    - { id: x-validation, kind: failure, label: validation failed, in: band-config }
    - { id: c-scan-program, kind: code, label: GlobSet.ScanProgram(), in: band-program }
    - { id: c-trigger, kind: code, label: Get-GlobSetTrigger, in: band-functions }
    - { id: c-changed, kind: code, label: Get-ChangedGlobSet, in: band-functions }
    - { id: c-hash, kind: code, label: Get-GlobSetHash, in: band-functions }
    - { id: g-trigger-gates, kind: gate, label: Trigger gates, in: band-callers }
    - { id: c-affected, kind: code, label: Test-GlobSetAffected, in: band-callers }
    - { id: c-protection, kind: code, label: Test-GlobSetProtection, in: band-callers }
  edges:
    - { from: c-globs-config, to: f-globs-yml, kind: flow }
    - { from: c-globs-config, to: x-validation, kind: fail }
    - { from: c-globs-config, to: c-scan-program, kind: flow, label: then }
    - { from: c-trigger, to: c-scan-program, kind: flow, label: calls }
    - { from: c-changed, to: c-scan-program, kind: flow, label: calls }
    - { from: c-hash, to: c-scan-program, kind: flow, label: calls }
    - { from: g-trigger-gates, to: c-trigger, kind: flow, label: calls }
    - { from: c-affected, to: c-changed, kind: flow, label: calls }
    - { from: c-protection, to: c-hash, kind: flow, label: calls }
  markers:
    - { at: f-globs-yml, number: 1 }
    - { at: c-globs-config, number: 2 }
    - { at: c-scan-program, number: 3 }
    - { at: c-trigger, number: 4 }
    - { at: c-changed, number: 5 }
    - { at: c-hash, number: 6 }
    - { at: g-trigger-gates, number: 7 }
    - { at: c-affected, number: 8 }
    - { at: c-protection, number: 9 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-config: { x: 20, y: 84, w: 220, h: 330 }
  band-program: { x: 260, y: 84, w: 240, h: 330 }
  band-functions: { x: 520, y: 84, w: 400, h: 330 }
  band-callers: { x: 940, y: 84, w: 340, h: 330 }
  f-globs-yml: { x: 40, y: 128, w: 180, h: 64 }
  c-globs-config: { x: 40, y: 232, w: 180, h: 56 }
  x-validation: { x: 40, y: 332, w: 180, h: 44 }
  c-scan-program: { x: 280, y: 132, w: 200, h: 256 }
  c-trigger: { x: 540, y: 132, w: 360, h: 56 }
  c-changed: { x: 540, y: 232, w: 360, h: 56 }
  c-hash: { x: 540, y: 332, w: 360, h: 56 }
  g-trigger-gates: { x: 960, y: 120, w: 300, h: 80 }
  c-affected: { x: 960, y: 232, w: 300, h: 56 }
  c-protection: { x: 960, y: 332, w: 300, h: 56 }
```

![What the scan program feeds](.assets/one-scan-program-feeds-three-roles.drawio.png)

## Walkthrough

1. **globs.yml.** The `globsets:` map is read by `Get-Config -Config globs`, which returns a validated `[GlobsConfig]`.
2. **GlobsConfig.** The type validates the whole registry at load: unknown keys, malformed patterns, compose references and compose cycles.
   It collects every error and throws once with `globs config validation failed`, so a bad registry never reaches the program.
3. **GlobSet.ScanProgram().** The composed sets' programs come first, deepest base first, then the set's own `+` includes and `-` excludes
   last; identical rules are deduped keeping the last. The program is built lazily and cached, and `Matches()` evaluates it last-match-wins
   with a default of not-selected.
4. **Get-GlobSetTrigger.** Given `-Name`, it walks `ScanProgram()` once and returns `.GitHub` (the program in order, each `-` rendered as
   `!`) and `.AdoInclude` and `.AdoExclude` (each pattern collapsed to its last select).
5. **Get-ChangedGlobSet.** Given `-Range`, it takes the changed paths from `Get-ChangedFile` (`git diff --name-only --no-renames`) and
   returns every set whose `Matches()` selects one of them; `-IncludeModules` adds the derived module sets.
6. **Get-GlobSetHash.** Given `-Name`, it selects the members through `GlobSet.SelectMembers` over `git ls-files`, hashes each with
   `DurableHash.HashFile` (a CR-stripped SHA-256), and folds the `path|digest` lines with `DurableHash.HashFold`.
7. **`Trigger gates`.** `Test-AdoPipelineTriggerGlob`, `Test-GitHubWorkflowTriggerGlob` and `Test-GlobSetTriggerCoverage` call
   `Get-GlobSetTrigger` and compare its output with the filters the pipelines and workflows declare.
8. **Test-GlobSetAffected.** Given `-Name`, it resolves the range with `Get-GlobSetChangeRange`, then calls `Get-ChangedGlobSet`. It returns
   `$true` when the range is indeterminate or the diff fails, so it fails open, and it throws on an undeclared name.
9. **Test-GlobSetProtection.** It calls `Get-GlobSetHash` unless a hash is passed in, compares it with the recorded identity, and stores it
   as pending; `Protect-GlobSet` promotes it after a green scan. Both are no-ops in a pipeline.

## Why it holds

- A globset's membership is an ordered scan program evaluated last-match-wins over tracked files (FDR-GLOBS-TRACKEDFILESONLY).
- The identity is the durable SHA, computed live per member file and folded into one SHA-256 (FDR-GLOBS-DURABLESHAIDENTITY).
- The trigger is the program projected into each vendor's native path-filter dialect (FDR-GLOBS-NATIVEPATHFILTER).
- Whether a change touches a set is computed from git at real refs, failing open on any doubt (FDR-GLOBS-CHANGECOMPUTEDFROMGIT).

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same globset roles: [meta](how-the-three-views-of-a-globset-are-derived.md),
  [architecture](what-the-globs-module-owns.md), [operations](how-a-globs-yml-edit-shows-in-the-output.md) and
  [governance](what-the-globset-gates-check.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
