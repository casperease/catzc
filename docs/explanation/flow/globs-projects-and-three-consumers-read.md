# Catzc.Base.Globs projects the program, and workflows, pipelines and the branch policy only read it

```text
Catzc.Base.Globs projects the program; workflows, pipelines and the branch policy only read it.

1  globs.yml                      the registry: every globset, owned by Catzc.Base.Globs
2  GlobSet                        the typed set; holds the flattened scan program
3  Get-GlobSetTrigger             projects the program into both vendor dialects
4  ordered GitHub paths           the program in order, with ! negation
5  ADO include and exclude        each pattern's last select, as two lists
6  Get-BuildValidationPathFilter  the branch policy: the GitHub list, anchored with /
7  .github/workflows/*.yml        a workflow declares the GitHub list by hand
8  .ado/pipelines/*.yaml          an ado pipeline declares the ADO lists by hand

Supports FDR-GLOBS-NATIVEPATHFILTER and FDR-GLOBS-COMPOSESETS (architecture lens).
```

One module of cats, `Catzc.Base.Globs`, owns the globset registry, the dialect, the flattened scan program and the native projection, and
nothing else parses the registry. Everything that triggers on a globset sits outside that boundary and only reads the projection: the GitHub
workflows, the Azure DevOps pipelines, and the build-validation policy that `Catzc.Azure.DevOps.BuildValidation` registers on the server.
The two YAML consumers are kept in step by hand and checked by quality gates; the branch policy is the one consumer the code fills in
itself, and it reads the GitHub list rather than the Azure DevOps lists.

```yml drawio
description:
  The globs module projects the flattened scan program into a GitHub list and an Azure DevOps include and exclude pair; the branch policy
  reads the GitHub list in code, while workflows and pipelines declare the lists by hand, drawn dashed.
about:
  rules: [FDR-GLOBS-NATIVEPATHFILTER, FDR-GLOBS-COMPOSESETS]
  lens: architecture
content:
  title: Catzc.Base.Globs projects the program, and workflows, pipelines and the branch policy only read it
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-compose, label: COMPOSE }
    - { id: band-projection, label: PROJECTION }
    - { id: band-trigger, label: TRIGGER }
  glyphs:
    - { id: f-globs, kind: file, label: globs.yml, in: band-compose }
    - { id: g-globset, kind: code, label: GlobSet, in: band-compose }
    - { id: g-trigger, kind: code, label: Get-GlobSetTrigger, in: band-projection }
    - { id: r-github, kind: result, label: ordered GitHub paths, in: band-projection }
    - { id: r-ado, kind: result, label: ADO include and exclude, in: band-projection }
    - { id: g-path-filter, kind: code, label: Get-BuildValidationPathFilter, in: band-trigger }
    - { id: f-workflows, kind: file, label: .github/workflows/*.yml, in: band-trigger }
    - { id: f-pipelines, kind: file, label: .ado/pipelines/*.yaml, in: band-trigger }
  edges:
    - { from: g-globset, to: f-globs, kind: flow, label: reads }
    - { from: g-trigger, to: g-globset, kind: flow, label: calls }
    - { from: g-trigger, to: r-github, kind: flow, label: "" }
    - { from: g-trigger, to: r-ado, kind: flow, label: "" }
    - { from: g-path-filter, to: r-github, kind: flow, label: reads }
    - { from: r-github, to: f-workflows, kind: record, label: "" }
    - { from: r-ado, to: f-pipelines, kind: record, label: "" }
  markers:
    - { at: f-globs, number: 1 }
    - { at: g-globset, number: 2 }
    - { at: g-trigger, number: 3 }
    - { at: r-github, number: 4 }
    - { at: r-ado, number: 5 }
    - { at: g-path-filter, number: 6 }
    - { at: f-workflows, number: 7 }
    - { at: f-pipelines, number: 8 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-compose: { x: 20, y: 84, w: 1260, h: 120 }
  band-projection: { x: 20, y: 224, w: 1260, h: 130 }
  band-trigger: { x: 20, y: 374, w: 1260, h: 130 }
  f-globs: { x: 440, y: 118, w: 140, h: 56 }
  g-globset: { x: 720, y: 122, w: 200, h: 48 }
  g-trigger: { x: 720, y: 262, w: 200, h: 48 }
  r-github: { x: 440, y: 262, w: 200, h: 44 }
  r-ado: { x: 1000, y: 262, w: 200, h: 44 }
  g-path-filter: { x: 60, y: 412, w: 320, h: 48 }
  f-workflows: { x: 440, y: 408, w: 220, h: 56 }
  f-pipelines: { x: 1000, y: 408, w: 220, h: 56 }
```

![Catzc.Base.Globs projects, three consumers read](.assets/globs-projects-and-three-consumers-read.drawio.png)

## Walkthrough

1. **globs.yml.** The registry holds every globset: its name, layer, `include:` and `exclude:` patterns, optional `compose:` references and,
   on a configured unit, the `pipeline:` it binds. `Catzc.Base.Globs` owns the file, and `GlobsConfig` validates it strictly on load.
2. **GlobSet.** Each entry loads as a typed `GlobSet`. After the loader resolves its compose references, the set holds its flattened scan
   program: the composed sets' rules first, its own rules last, built once and cached.
3. **Get-GlobSetTrigger.** The projection reads the flattened program once and renders it into both vendor dialects, returning one object
   with the `GitHub`, `AdoInclude` and `AdoExclude` lists.
4. **Ordered GitHub paths.** The GitHub list is the program in order, each drop rendered as a `!` negation, so it is exact.
5. **ADO include and exclude.** The Azure DevOps lists collapse each pattern to its last select in the program, because Azure DevOps path
   filters are order-independent.
6. **Get-BuildValidationPathFilter.** The build-validation policy lives server-side. `Register-AdoBuildValidation` fills its
   `filenamePatterns` from this function, which takes the ordered GitHub list and anchors every pattern with a leading `/`.
7. **.github/workflows/\*.yml.** A workflow declares the GitHub list in `on.push.paths` and `on.pull_request.paths`. Today one workflow,
   `ci-pwsh.yml`, binds the `pwsh` set with `pwsh/**`. No code writes the workflow; the pairing is kept by hand.
8. **.ado/pipelines/\*.yaml.** Each pipeline-bound globset names its `.ado/pipelines/<pipeline>.yaml`, whose `trigger:` and `pr:` path
   filters declare the Azure DevOps lists. Six sets bind a pipeline today, and no code writes the pipeline file either.

## Why it holds

- A pipeline, workflow or build-validation policy triggers on the globset's native path-filter projection, rendered by `Get-GlobSetTrigger`
  from the flattened program: exact for GitHub, last select per pattern for Azure DevOps (FDR-GLOBS-NATIVEPATHFILTER).
- The flattened program is what the projection is computed from, with no reference-chasing at trigger time (FDR-GLOBS-COMPOSESETS).
- `Catzc.Base.Globs` owns the file, the dialect, the durable SHA, the native projection and the git-reflection query; nothing else parses
  the config (FDR-GLOBS, "One configuration point").

## Where the code and the decision record differ

- The FDR says branch-policy `filenamePatterns` use the order-independent Azure DevOps projection. `Get-BuildValidationPathFilter` uses the
  ordered GitHub list with `!` negation, anchored with `/`.
- The FDR says the projected filters are generated from `globs.yml` into the orchestration YAML and never hand-authored. No code in the tree
  writes `paths:` into a pipeline or a workflow; the files are kept in step by hand and the drift quality gates compare them.

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same projection: [meta](one-program-two-vendor-dialects.md),
  [implementation](apex-thirteen-rules-seven-includes-six-excludes.md), [operations](print-projection-then-drift-names-the-filter.md) and
  [governance](drift-is-gated-generation-is-drs-only.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
