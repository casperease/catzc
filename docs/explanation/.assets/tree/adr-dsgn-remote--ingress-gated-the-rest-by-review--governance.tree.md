---
catzc:
  immutable:
    with_body_sha: dc44b2b88912
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
    source: docs/explanation/.assets/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only ingress is checked by gates; the source-of-truth and integration rules rest on code review: the tree minimap

```text
Which files cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE and ADR-REPO-VARIANT: every file of the world map is a tile, grouped by top-level folder.
18 files lit in 8 groups.
```

![The tree minimap of Only ingress is checked by gates; the source-of-truth and integration rules rest on code review](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Only ingress is checked by gates; the source-of-truth and integration
rules rest on code review][19], which explains [ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]. It lights every file that
cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 18 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 4 lit files
- .claude: 3 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 4 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 39 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][6], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the
  file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 11 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-fast-push-followups.md][8], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  12 (text) and line 37 (text).
- [.claude/plans/plan-module-kinds-tracks.md][9], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at
  line 877 (text) and line 931 (text).
- [.claude/plans/value-of-plan.md][10], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 44 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 103 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][12], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]: the
  file cites it at line 44 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][13], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 49 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][14], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text).
- [docs/adr/index.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 113 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 327 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 165
  (text).
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][17], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78
  (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 79 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at
  line 303 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][18], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text); selected by
  [ADR-REPO-VARIANT][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text) and `pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 44 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [powershell][26]: a file language
- [yaml][26]: a file language

Terms the cited ADRs define:

- [occupant][27], defined by [ADR-DSGN-LIFE#5][28]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/server-remote-integration.md
[3]: ../../../adr/repository/repo-variants.md
[4]: ../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[5]: ../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[6]: ../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[7]: ../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[8]: ../../../../.claude/plans/plan-fast-push-followups.md
[9]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[10]: ../../../../.claude/plans/value-of-plan.md
[11]: ../../../adr/design/dora-explains.md
[12]: ../../../../pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[13]: ../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[14]: ../../../adr/glossary.md
[15]: ../../../adr/index.md
[16]: ../../../adr/repository/dora-explains.md
[17]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../../pipelines/ci-automation.yaml
[19]: ../../design/ingress-gated-the-rest-by-review.md
[20]: ../../../adr/glossary.md#world-map
[21]: ../../../adr/glossary.md#track
[22]: ../../../adr/glossary.md#file-language
[23]: ../../../adr/glossary.md#cell
[24]: ../../../adr/glossary.md#lit-cell
[25]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[27]: ../../../adr/glossary.md#occupant
[28]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
