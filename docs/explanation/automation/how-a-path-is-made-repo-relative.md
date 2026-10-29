# How a path is made repo-relative

```text
How a path is made repo-relative.

 1  out/template/sample/main.json  a path under the output root: out/ plus the remainder
 2  pwsh/mod/file.ps1              a path under the repository root: repo-relative
 3  D:\a\1\ws\sample\main.json     a path under neither root: the normalized absolute, unchanged
 4  Resolve-RepoPath               out/ onto Get-OutputRoot, a rooted path unchanged, else onto Get-RepositoryRoot
 5  Get-OutputRoot                 the staging directory in a pipeline, else {root}/out
 6  Reads, writes, tool calls      the side-effect lines that take the absolute result
 7  ConvertTo-RepoRelativePath     GetFullPath, then the output root, then the repository root, else absolute
 8  ArtifactRef.Materialize        the factory: a raw path plus the artifact root; throws outside the root
 9  ArtifactRef                    relative and absolute, immutable
10  ResolveAt / ExistsAt           the consumer's re-resolve and existence check

Supports ADR-AUTO-PATH-CENTRALNORMALIZATION, ADR-AUTO-PATH-FOREIGNPATHS, ADR-AUTO-PATH-OUTANCHOR
and ADR-AUTO-PATH-PUBLISHEDARTIFACT (implementation lens).
```

`ConvertTo-RepoRelativePath` and `Resolve-RepoPath`, both in `Catzc.Base.Repository`, are the two boundary crossers of cats, and the order
of their tests is the whole contract. Converting a path tries the output root before the repository root and keeps a normalized absolute
path when neither applies; resolving a path re-anchors `out/` on `Get-OutputRoot`, passes a rooted path through and joins everything else
onto the repository root. Across a stage boundary `ArtifactRef` does the same job against the artifact root.

```yml drawio
description:
  A path is converted under the output root first, then the repository root, else kept absolute; Resolve-RepoPath re-anchors out/ on the
  output root, and an artifact reference carries the relative and absolute forms across stages.
about:
  rules: [ADR-AUTO-PATH-CENTRALNORMALIZATION, ADR-AUTO-PATH-FOREIGNPATHS, ADR-AUTO-PATH-OUTANCHOR, ADR-AUTO-PATH-PUBLISHEDARTIFACT]
  lens: implementation
content:
  title: How a path is made repo-relative
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-communication, label: COMMUNICATION FORM }
    - { id: band-crossers, label: THE TWO CROSSERS }
    - { id: band-binding, label: BINDING FORM }
    - { id: band-stage, label: CROSS-STAGE }
  groups:
    - { id: grp-paths, label: communicated paths, in: band-communication }
  glyphs:
    - { id: r-out, kind: result, label: out/template/.../main.json, in: grp-paths }
    - { id: r-repository, kind: result, label: pwsh/mod/file.ps1, in: grp-paths }
    - { id: r-foreign, kind: result, label: 'D:\a\1\ws\sample\main.json', in: grp-paths }
    - { id: g-resolve, kind: code, label: Resolve-RepoPath, in: band-crossers }
    - { id: g-output-root, kind: code, label: Get-OutputRoot, in: band-crossers }
    - { id: g-convert, kind: code, label: ConvertTo-RepoRelativePath, in: band-crossers }
    - { id: s-effects, kind: set, label: "Reads, writes, tool calls", in: band-binding }
    - { id: g-materialize, kind: code, label: ArtifactRef.Materialize, in: band-stage }
    - { id: g-reference, kind: code, label: ArtifactRef, in: band-stage }
    - { id: g-resolve-at, kind: code, label: ResolveAt / ExistsAt, in: band-stage }
  edges:
    - { from: g-resolve, to: grp-paths, kind: flow, label: reads }
    - { from: g-resolve, to: s-effects, kind: flow, label: "" }
    - { from: g-output-root, to: g-resolve, kind: flow, label: calls }
    - { from: g-output-root, to: g-convert, kind: flow, label: calls }
    - { from: g-convert, to: grp-paths, kind: flow, label: "" }
    - { from: g-materialize, to: g-reference, kind: flow, label: calls }
    - { from: g-reference, to: g-resolve-at, kind: flow, label: calls }
  markers:
    - { at: r-out, number: 1 }
    - { at: r-repository, number: 2 }
    - { at: r-foreign, number: 3 }
    - { at: g-resolve, number: 4 }
    - { at: g-output-root, number: 5 }
    - { at: s-effects, number: 6 }
    - { at: g-convert, number: 7 }
    - { at: g-materialize, number: 8 }
    - { at: g-reference, number: 9 }
    - { at: g-resolve-at, number: 10 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-communication: { x: 20, y: 84, w: 380, h: 300 }
  band-crossers: { x: 420, y: 84, w: 440, h: 300 }
  band-binding: { x: 880, y: 84, w: 400, h: 300 }
  band-stage: { x: 20, y: 404, w: 1260, h: 130 }
  grp-paths: { x: 40, y: 118, w: 340, h: 250 }
  r-out: { x: 60, y: 162, w: 300, h: 44 }
  r-repository: { x: 60, y: 230, w: 300, h: 44 }
  r-foreign: { x: 60, y: 298, w: 300, h: 44 }
  g-resolve: { x: 510, y: 138, w: 240, h: 52 }
  g-output-root: { x: 510, y: 228, w: 240, h: 44 }
  g-convert: { x: 510, y: 304, w: 240, h: 52 }
  s-effects: { x: 920, y: 138, w: 300, h: 52 }
  g-materialize: { x: 70, y: 452, w: 280, h: 52 }
  g-reference: { x: 510, y: 452, w: 240, h: 52 }
  g-resolve-at: { x: 920, y: 452, w: 300, h: 52 }
```

![How a path is made repo-relative](.assets/how-a-path-is-made-repo-relative.drawio.png)

## Walkthrough

1. **out/template/sample/main.json.** The first test in `ConvertTo-RepoRelativePath`: after `[IO.Path]::GetFullPath`, a path under
   `Get-OutputRoot` comes back as `out/` plus the remainder with forward slashes, and the output root itself comes back as `out`. The input
   need not exist.
2. **pwsh/mod/file.ps1.** The second test: a path under `Get-RepositoryRoot` comes back repo-relative with forward slashes.
3. **D:\a\1\ws\sample\main.json.** A path under neither root comes back as the normalized absolute path, the honest answer when no relative
   form exists.
4. **Resolve-RepoPath.** Backslashes become forward slashes; `out` and `out/...` are joined onto `Get-OutputRoot` and passed through
   `GetFullPath`; a rooted path is returned as given; any other relative path is joined onto `Get-RepositoryRoot` and passed through
   `GetFullPath`. `Get-RepositoryFile` and `Get-RepositoryFolder` are one call to this function each.
5. **Get-OutputRoot.** When `Test-IsRunningInPipeline` is true and `BUILD_ARTIFACTSTAGINGDIRECTORY` is set, the staging directory, asserted
   to exist; otherwise `{root}/out`. Both crossers ask it, so the `out/` sentinel means the same place on both ways across the boundary.
6. **Reads, writes, tool calls.** The absolute result goes straight into `Get-Content`, `Import-Module`, `Test-Path` or the tool call, and
   is never stored, returned or logged.
7. **ConvertTo-RepoRelativePath.** The path in hand on the binding side, absolute, `.\` or `..`, goes through the three tests above and
   lands in communication form.
8. **ArtifactRef.Materialize.** The controlled factory takes the raw path and the artifact root, resolves the raw path against the root when
   it is relative, relativizes it, and throws when the file does not live under the root.
9. **ArtifactRef.** The immutable result: `relative`, artifact-internal with forward slashes, and `absolute`, resolved in the producing
   context for audit. The constructor rejects a rooted or escaping relative, so a deserialized manifest cannot smuggle one in.
10. **ResolveAt / ExistsAt.** The consumer combines its own artifact root with `relative` and asks whether a file or folder exists there
    before binding.

## Why it holds

- Normalization lives in the two crossers, so a `.\` or a backslash cannot leak downstream (ADR-AUTO-PATH-CENTRALNORMALIZATION).
- A path under neither root degrades to a normalized absolute path, never to a hybrid (ADR-AUTO-PATH-FOREIGNPATHS).
- `out/` is a reserved anchor, re-anchored on `Get-OutputRoot` rather than the repository root, so one stored string resolves right on a
  devbox and in a pipeline (ADR-AUTO-PATH-OUTANCHOR).
- A published artifact is created by `ArtifactRef.Materialize`, carries both forms, and is re-resolved and checked at the consumer with
  `ResolveAt` and `ExistsAt` (ADR-AUTO-PATH-PUBLISHEDARTIFACT).

## See also

- [Path representation](../../drs/automation/path-representation.md) — the decision this article explains.
- The other views of the same boundary: [meta](two-forms-never-a-third.md), [architecture](two-crossers-and-three-anchors.md),
  [operations](one-out-string-two-places.md) and [governance](types-check-forms-review-checks-crossers.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
