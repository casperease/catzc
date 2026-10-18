---
catzc:
  immutable:
    with_body_sha: "482e0b7be88b"
    repo_status: locked
    path: docs/explanation/design/.assets/ingress-gated-the-rest-by-review/tree.md
    source: docs/explanation/design/.assets/ingress-gated-the-rest-by-review/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only ingress is checked by gates; the source-of-truth and integration rules rest on code review: the tree minimap

```text
Which files cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE and ADR-REPO-VARIANT: every file of the world map is a tile, grouped by top-level folder.
26 files lit in 8 groups.
```

![The tree minimap of Only ingress is checked by gates; the source-of-truth and integration rules rest on code review](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Only ingress is checked by gates; the source-of-truth and integration
rules rest on code review][27], which explains [ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]. It lights every file that
cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 26 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 8 lit files
- docs (docs/ outside docs/adr/): 6 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 2 lit files
- pipelines: 1 lit file

## Why each group is lit

### .claude (8 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][4], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at
  line 125 (text).
- [.claude/plans/plan-fast-push-followups.md][5], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][6], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12
  (text), line 34 (text) and line 82 (text).
- [.claude/plans/prompt-drift-gaps-1-aspect-move.md][7], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 13 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][8], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 20 (text).
- [.claude/plans/task-explanation-drift-gaps.md][9], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at
  line 35 (text).
- [.claude/plans/task-loose-ends.md][10], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55
  (text).
- [.claude/plans/value-of-plan.md][11], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 36 (text)
  and line 43 (text).

### docs (docs/ outside docs/adr/, 6 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 39 (text).
- [docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][16], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][17], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 11 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 103 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][19], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 345
  (text).
- [docs/adr/index.md][20], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 113 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 327 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][21], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 165
  (text).
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][22], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 79 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 303
  (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][23], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484
  (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][24], in the cell pwsh × powershell: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 44 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][25], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 49 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][26], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text);
  selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text); selected by [ADR-REPO-VARIANT][3]: a pipeline that cites nothing itself carries
  its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text) and
  `pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 44 (text).

## Keywords

- [world map][28]
- [track][29]
- [file language][30]
- [cell][31]
- [lit cell][32]
- [.claude][33]: a track
- [docs][33]: a track
- [pipelines][33]: a track
- [pwsh][33]: a track
- [markdown][34]: a file language
- [pipeline-yaml][34]: a file language
- [powershell][34]: a file language
- [yaml][34]: a file language

Terms the cited ADRs define:

- [occupant][35], defined by [ADR-DSGN-LIFE#5][36]
- [staging slot][37], defined by [ADR-DSGN-LIFE#5][36]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/server-remote-integration.md
[3]: ../../../../adr/repository/repo-variants.md
[4]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[5]: ../../../../../.claude/plans/plan-fast-push-followups.md
[6]: ../../../../../.claude/plans/plan-promotion-ladder.md
[7]: ../../../../../.claude/plans/prompt-drift-gaps-1-aspect-move.md
[8]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[9]: ../../../../../.claude/plans/task-explanation-drift-gaps.md
[10]: ../../../../../.claude/plans/task-loose-ends.md
[11]: ../../../../../.claude/plans/value-of-plan.md
[12]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[13]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[14]: ../../../../references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
[15]: ../../../../references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
[16]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[17]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[18]: ../../../../adr/design/dora-explains.md
[19]: ../../../../adr/glossary.md
[20]: ../../../../adr/index.md
[21]: ../../../../adr/repository/dora-explains.md
[22]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[24]: ../../../../../pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[25]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[26]: ../../../../../pipelines/ci-automation.yaml
[27]: ../../ingress-gated-the-rest-by-review.md
[28]: ../../../../adr/glossary.md#world-map
[29]: ../../../../adr/glossary.md#track
[30]: ../../../../adr/glossary.md#file-language
[31]: ../../../../adr/glossary.md#cell
[32]: ../../../../adr/glossary.md#lit-cell
[33]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[34]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[35]: ../../../../adr/glossary.md#occupant
[36]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[37]: ../../../../adr/glossary.md#staging-slot
