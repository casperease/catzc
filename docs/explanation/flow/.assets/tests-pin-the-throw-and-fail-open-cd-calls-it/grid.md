---
catzc:
  immutable:
    with_body_sha: "99b1e5e77f77"
    repo_status: locked
    path: docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it/grid.md
    source: docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tests pin the throw and the fail-open, a rule pins detection, and the CD stages call it ungated: the world-map minimap

```text
Where the files that cite ADR-AUTO-FAILFAST, ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 61 files.
```

![The world-map minimap of Tests pin the throw and the fail-open, a rule pins detection, and the CD stages call it ungated](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Tests pin the throw and the fail-open, a rule pins detection, and
the CD stages call it ungated][65], which explains [ADR-AUTO-FAILFAST][1], [ADR-FLOW-CD-DETECT][2] and [ADR-FLOW-CD-GLOBS][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 9 lit of 89 files
- docs × markdown: 47 lit of 2763 files
- pipelines × pipeline-yaml: 3 lit of 14 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (9 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/CLAUDE.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/decisions-2026-10-16.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 39 (text), line 39 (text), line
  161 (text) and line 168 (text).
- [.claude/plans/plan-adr-code-language.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 31 (text), line 37 (text),
  line 39 (text), line 89 (text), line 89 (text), line 90 (text), line 92 (text), line 93 (text), line 105 (text) and line 108 (text).
- [.claude/plans/plan-assert-wait.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (text), line 33 (text), line 41
  (text), line 86 (text), line 88 (text), line 89 (text), line 131 (text) and line 140 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 51 (text), line 65
  (text) and line 106 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 60 (text), line 97 (text) and line 109 (text).
- [.claude/plans/prompt-assert-wait-1-watch-blocking.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 18 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 17
  (text).
- [.claude/plans/questionnaire-2026-10-16.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 59 (text).

### docs × markdown (47 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/automation/dora-explains.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][17]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 49 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][3]: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][2]: selected by [ADR-FLOW-CD-DETECT][2]: the ADR's own file.
- [docs/adr/index.md][18]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 165 (text); selected by [ADR-FLOW-CD-DETECT][2]:
  the file cites it at line 133 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 135 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][19]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][20]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 62 (text).
- [docs/references/pipelines/cd-apex.yaml.md][21]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][22]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][23]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][24]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][25]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][26]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][27]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][28]: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][29]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][30]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][31]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][32]: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][33]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][34]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][35]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][37]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][38]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][39]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][40]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][41]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][42]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][43]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][44]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][45]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][46]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][47]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][48]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][49]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][50]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][51]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][52]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][53]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][54]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23
  (text) and line 24 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][55]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][56]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][57]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][58]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][59]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text) and line 39 (text).

### pipelines × pipeline-yaml (3 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/cd-shared.yaml][60]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 45 (body comment) (a passing mention only).
- [pipelines/ci-automation.yaml][61]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text); selected by [ADR-FLOW-CD-DETECT][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).
- [pipelines/extends/cd-customer.yaml][62]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (body comment) (a passing
  mention only).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][63]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 132 (text); selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 99 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][64]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1076 (text).

## Keywords

- [world map][66]
- [track][67]
- [file language][68]
- [cell][69]
- [lit cell][70]
- [.claude][71]: a track
- [docs][71]: a track
- [pipelines][71]: a track
- [pwsh][71]: a track
- [markdown][72]: a file language
- [pipeline-yaml][72]: a file language
- [yaml][72]: a file language

[1]: ../../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../adr/flow/pipeline-detection.md
[3]: ../../../../adr/flow/durable-sha-globs.md
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../../.claude/CLAUDE.md
[8]: ../../../../../.claude/plans/decisions-2026-10-16.md
[9]: ../../../../../.claude/plans/plan-adr-code-language.md
[10]: ../../../../../.claude/plans/plan-assert-wait.md
[11]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[12]: ../../../../../.claude/plans/prompt-assert-wait-1-watch-blocking.md
[13]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[14]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[15]: ../../../../../.claude/plans/task-assert-wait.md
[16]: ../../../../adr/automation/dora-explains.md
[17]: ../../../../adr/flow/dora-explains.md
[18]: ../../../../adr/index.md
[19]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[20]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[21]: ../../../../references/pipelines/cd-apex.yaml.md
[22]: ../../../../references/pipelines/cd-flux.yaml.md
[23]: ../../../../references/pipelines/cd-nova.yaml.md
[24]: ../../../../references/pipelines/cd-shared.yaml.md
[25]: ../../../../references/pipelines/ci-automation.yaml.md
[26]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[27]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[28]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[30]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[33]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[34]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[35]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[36]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[37]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[38]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[39]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[40]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[41]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[42]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[43]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[44]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[45]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[46]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[47]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[48]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[49]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[50]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[51]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[52]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[53]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[54]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[55]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[56]: ../../../../references/pwsh/catzc-base-typessystem.md
[57]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[58]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[59]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[60]: ../../../../../pipelines/cd-shared.yaml
[61]: ../../../../../pipelines/ci-automation.yaml
[62]: ../../../../../pipelines/extends/cd-customer.yaml
[63]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[64]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[65]: ../../tests-pin-the-throw-and-fail-open-cd-calls-it.md
[66]: ../../../../adr/glossary.md#world-map
[67]: ../../../../adr/glossary.md#track
[68]: ../../../../adr/glossary.md#file-language
[69]: ../../../../adr/glossary.md#cell
[70]: ../../../../adr/glossary.md#lit-cell
[71]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[72]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
