---
catzc:
  immutable:
    with_body_sha: "1d9f2c7ed0c7"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.grid.md
    source: docs/explanation/.assets/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One flattened scan program is rendered exactly for GitHub and by last select for Azure DevOps: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-GLOBS sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 74 files.
```

![The world-map minimap of One flattened scan program is rendered exactly for GitHub and by last select for Azure DevOps](adr-flow-cd-globs--one-program-two-vendor-dialects--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [One flattened scan program is rendered exactly for GitHub and by last
select for Azure DevOps][78], which explains [ADR-FLOW-CD-GLOBS][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 289 files
- automation × powershell: 5 lit of 1629 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 62 lit of 2742 files
- github-workflows × yaml: 1 lit of 2 files, touched
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][5]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 23 (text), line 27 (text),
  line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][6]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 54 (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][7]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 73 (text), line 136 (text),
  line 140 (text) and line 154 (text).

### automation × powershell (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][8]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][9]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (text)
  and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][10]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][11]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][12]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 53 (text),
  line 66 (text), line 77 (text) and line 89 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][13]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][14]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1216 (text).

### docs × markdown (62 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/dora-explains.md][15]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][1]: selected by [ADR-FLOW-CD-GLOBS][1]: the ADR's own file.
- [docs/adr/index.md][16]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 133 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][17]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][18]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][19]: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][20]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][21]: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][22]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][23]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][24]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-globs.md][25]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][26]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][27]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][28]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][29]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][30]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][31]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][32]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][33]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 58
  (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][34]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][35]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][36]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][37]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17
  (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][38]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][39]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][40]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text),
  line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][41]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][42]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][43]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][44]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][45]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 33 (text) and line 108 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][46]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][47]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][48]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][49]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][50]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][51]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][52]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][53]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][54]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][55]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][56]: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][57]: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][58]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][59]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][60]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][61]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][62]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 11
  (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][63]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17
  (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][64]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text),
  line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line 47 (text), line 65
  (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][65]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13
  (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][66]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][67]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][68]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][69]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 17 (text).
- [docs/references/pipelines/cd-apex.yaml.md][70]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][71]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][72]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][73]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][74]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][75]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.github/workflows/ci-automation.yml][76]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][77]: selected by [ADR-FLOW-CD-GLOBS][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`
  line 42 (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 4 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line
  58 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1`
  line 53 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line
  89 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 23 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 31 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text),
  `pwsh/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1216 (text).

## Keywords

- [world map][79]
- [track][80]
- [file language][81]
- [cell][82]
- [lit cell][83]
- [automation][84]: a track
- [docs][84]: a track
- [github-workflows][84]: a track
- [pipelines][84]: a track
- [csharp][85]: a file language
- [markdown][85]: a file language
- [pipeline-yaml][85]: a file language
- [powershell][85]: a file language
- [yaml][85]: a file language

[1]: ../../../adr/flow/durable-sha-globs.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[6]: ../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[7]: ../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[8]: ../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[9]: ../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[10]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[11]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[12]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[13]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[15]: ../../../adr/flow/dora-explains.md
[16]: ../../../adr/index.md
[17]: ../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[18]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[19]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[20]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[21]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[22]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[23]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[24]: ../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[25]: ../../../references/pwsh/catzc-base-globs.md
[26]: ../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[27]: ../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[28]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[29]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[30]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[31]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[32]: ../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[33]: ../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[34]: ../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[35]: ../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[36]: ../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[37]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[38]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[39]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[40]: ../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[41]: ../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[42]: ../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[43]: ../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[44]: ../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[45]: ../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[46]: ../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[47]: ../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[48]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[49]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[50]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[51]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[52]: ../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[53]: ../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[54]: ../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[55]: ../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[56]: ../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[57]: ../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[58]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[59]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[60]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[61]: ../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[62]: ../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[63]: ../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[64]: ../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[65]: ../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[66]: ../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[67]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[68]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[69]: ../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[70]: ../../../references/pipelines/cd-apex.yaml.md
[71]: ../../../references/pipelines/cd-flux.yaml.md
[72]: ../../../references/pipelines/cd-nova.yaml.md
[73]: ../../../references/pipelines/cd-shared.yaml.md
[74]: ../../../references/pipelines/ci-automation.yaml.md
[75]: ../../../references/pipelines/ci-infrastructure.yaml.md
[76]: ../../../../.github/workflows/ci-automation.yml
[77]: ../../../../pipelines/ci-automation.yaml
[78]: ../../flow/one-program-two-vendor-dialects.md
[79]: ../../../adr/glossary.md#world-map
[80]: ../../../adr/glossary.md#track
[81]: ../../../adr/glossary.md#file-language
[82]: ../../../adr/glossary.md#cell
[83]: ../../../adr/glossary.md#lit-cell
[84]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[85]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
