# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Tree minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 305 files in 39 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 40 lit files
- Docs (automation/Catzc.Base.Docs): 30 lit files
- adr/pwsh (docs/adr/pwsh): 26 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 20 lit files
- Maps (automation/Catzc.Base.Maps): 16 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 16 lit files
- adr/repo (docs/adr/repository): 16 lit files
- Languages (automation/Catzc.Base.Languages): 12 lit files
- VSCode (automation/Catzc.Base.VSCode): 12 lit files
- Exporter (automation/Catzc.Base.Exporter): 11 lit files
- Azure (automation/Catzc.Azure): 9 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 8 lit files
- adr/prin (docs/adr/principles): 7 lit files
- docs (docs/ outside docs/adr/): 7 lit files
- Contracts (automation/Catzc.Base.Contracts): 6 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 5 lit files
- Repository (automation/Catzc.Base.Repository): 5 lit files
- .internal (automation/.internal): 4 lit files
- Reports (automation/Catzc.Base.Reports): 4 lit files
- Root files: 3 lit files
- Git (automation/Catzc.Base.Git): 3 lit files
- Variants (automation/Catzc.Base.Variants): 3 lit files
- Vendor (automation/Catzc.Base.Vendor): 3 lit files
- .claude: 2 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 2 lit files
- Files (automation/Catzc.Base.Files): 2 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 2 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 2 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 2 lit files
- .github: 1 lit file
- .scriptanalyzer (automation/.scriptanalyzer): 1 lit file
- Az.DevOps (automation/Catzc.Azure.DevOps): 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (40 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/BCL/native-csharp-types.md][2], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][8], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][9], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/index.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/caching.md][11], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/consumer-overlay.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/dry-run.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/environment-variables.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/idempotent-state-functions.md][26], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][27], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][28], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/never-depend-on-pwd.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/path-representation.md][32], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/python/index.md][33], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][34], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][35], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][36], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][37], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][38], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/test-automation.md][39], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][40], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][41], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][42], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][43], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][44], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.

### Docs (30 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][45], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1][46], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1][47], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 3 (header) and line 24 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][48], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 101 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 192 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 314 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][50], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][51], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][52], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 1 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][53], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]:
  the file cites it at line 4 (text).
- [automation/Catzc.Base.Docs/types/AdrCheck.cs][54], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][55], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChange.cs][56], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs][57], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationMap.cs][58], in the cell automation × csharp: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs][59], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][60], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/AdrDomainEdge.cs][61], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrDoraCheck.cs][62], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrNeutralityCheck.cs][63], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs][64], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][65], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][66], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Docs/types/AgentEntry.cs][67], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][68], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 8 (header).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][69], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][4]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryAvoid.cs][70], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][71], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.Docs/types/GlossaryEntry.cs][72], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryOptions.cs][73], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryRealization.cs][74], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).

### adr/pwsh (26 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/announce-state-changes.md][75], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/assert-idioms.md][76], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][77], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][78], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/cross-platform-powershell.md][79], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dora-explains.md][80], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][81], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][82], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/error-handling.md][5], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][83], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/identifier-names.md][84], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][85], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][86], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/one-function-per-file.md][87], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/parameter-design.md][88], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][89], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][90], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][91], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][92], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][93], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pwsh-engine.md][94], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][95], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/script-scope-caching.md][96], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][97], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][98], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][99], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.

### QualityGates (20 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][100], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the
  file cites it at line 65 (header), line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][101], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][102], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][103], in the cell automation × yaml: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 18 (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][104], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 596 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 576 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 616 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][105], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][106], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 7 (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][107], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][108], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][110], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][111], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.QualityGates/types/GuidsConfig.cs][112], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][113], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs][114], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][115], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][116], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][117], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.QualityGates/types/SpellingOracle.cs][118], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][119], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).

### Maps (16 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/CitationSite.cs][120], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/HighlightReason.cs][121], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/HighlightedCell.cs][122], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Maps/types/MapPlacement.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][126], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 9 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][127], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPin.cs][130], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Maps/types/TreemapRect.cs][131], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][132], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][133], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][134], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 27 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][135], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 10 (header).

### ModuleSystem (16 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][136], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 29 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][137], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][138], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][139], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][140], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][141], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][142], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 23 (header) and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][143], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][144], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 35 (text) and line 113 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][145], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs][146], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/BaseModule.cs][147], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][148], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs][149], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs][150], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs][151], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header).

### adr/repo (16 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][152], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][153], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][154], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][155], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][156], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][157], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][158], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][159], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][160], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][6], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][161], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][162], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][163], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][164], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][165], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][166], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Languages (12 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][167], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 25 (header).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][168], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][169], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][170], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FormatterEngine.cs][171], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][172], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][173], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][174], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 2 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][175], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][176], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][177], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][178], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).

### VSCode (12 lit files)

The group holds the files of automation/Catzc.Base.VSCode; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][179], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][180], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][181], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 18 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][182], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][183], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][184], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][185], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][186], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][187], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][188], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 2 (header).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][189], in the cell automation × csharp: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][190], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 9 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### Exporter (11 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][191], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][192], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][193], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][194], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][195], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][196], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][197], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][198], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][199], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][200], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterPackage.cs][201], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Azure (9 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][202], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Azure/types/AzureCustomer.cs][203], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][204], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][205], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][206], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/types/CustomerConfig.cs][207], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/NetworkConfig.cs][208], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Azure/types/NetworkEnvironment.cs][209], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/NetworkSubscription.cs][210], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).

### TypesSystem (9 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][211], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][212], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][213], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 12 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][214], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][215], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][216], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 19 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][217], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][218], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][219], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][220], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][221], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][222], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][3], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][223], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][224], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][225], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][226], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][227], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### RootConfig (8 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][228], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 24 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][229], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][230], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][231], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][232], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][233], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][234], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][235], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 6 (header).

### adr/prin (7 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/configure-not-program.md][236], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/dora-explains.md][237], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/everything-as-code.md][238], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/one-living-version.md][4], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/poka-yoke.md][239], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles`
  ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-variability.md][240], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-waste.md][241], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.

### docs (7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][242], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 30 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][243], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][244], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 111 (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][245], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][246], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 43 (text) and line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][247], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][248], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 36 (text).

### Contracts (6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][249], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).
- [automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1][250], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header) and line 23 (text).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][251], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractCheckResult.cs][252], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractManifest.cs][253], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][254], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).

### Az.Templates (5 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][255], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 103 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][256], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 133 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepParameter.cs][257], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header) and line 8 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameterModel.cs][258], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][259], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).

### Repository (5 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][260], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][261], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][262], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][263], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][264], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 1 (text).

### .internal (4 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][265], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1][266], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header) and line 9 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][267], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][268], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 2 (header), line 17 (text), line 38 (text) and line 75 (text).

### Reports (4 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/types/OutputFormat.cs][269], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs][270], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/types/OutputPattern.cs][271], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 67 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][272], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][273], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][274], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [importer.ps1][275], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1` line 4 (header), `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1`
  line 9 (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 2 (header),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 17 (text),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 38 (text) and
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 75 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Git (3 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/New-GitIgnore.ps1][276], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][277], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][278], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 6 (header).

### Variants (3 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantAspect.cs][279], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][280], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][281], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Vendor (3 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][282], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][283], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Vendor/types/VendorConfig.cs][284], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][285], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 57 (text) and line
  122 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 30 (text).
- [.claude/agents/build-inspiration-module.md][286], in the cell .claude × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 25 (text).

### Az.DevOps.BuildValidation (2 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][287], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][288], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).

### Files (2 lit files)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/Set-FileLink.ps1][289], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][290], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 20 (header).

### Objects (2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][291], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][292], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (text).

### Timeouts (2 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][293], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][294], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Tool.Inspiration (2 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][295], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs][296], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 4 (header).

### Tool.KeyHandler (2 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs][297], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs][298], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][299], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .scriptanalyzer (1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1][300], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 3 (text).

### Az.DevOps (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/types/AdoConfig.cs][301], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][302], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).

### Engines (1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][303], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][304], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 29 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][305], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15
  (text) and line 178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).

## Keywords

- [world map][306]
- [track][307]
- [file language][308]
- [cell][309]
- [lit cell][310]
- [root file][311]
- [unlisted file][312]
- [.claude][313]: a track
- [.github][313]: a track
- [automation][313]: a track
- [docs][313]: a track
- [csharp][314]: a file language
- [markdown][314]: a file language
- [powershell][314]: a file language
- [yaml][314]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/repository/generated-root-configs.md
[7]: ../../adr/automation/BCL/index.md
[8]: ../../adr/automation/avoid-deep-nesting.md
[9]: ../../adr/automation/bash/bash-test-artifacts.md
[10]: ../../adr/automation/bash/index.md
[11]: ../../adr/automation/caching.md
[12]: ../../adr/automation/console-output-matters.md
[13]: ../../adr/automation/consumer-overlay.md
[14]: ../../adr/automation/controlling-module-dependencies.md
[15]: ../../adr/automation/controlling-systemwide-deps.md
[16]: ../../adr/automation/cross-platform.md
[17]: ../../adr/automation/devbox-pipeline-parity.md
[18]: ../../adr/automation/dora-explains.md
[19]: ../../adr/automation/dry-run.md
[20]: ../../adr/automation/effective-in-enterprises.md
[21]: ../../adr/automation/environment-variables.md
[22]: ../../adr/automation/execution-engines.md
[23]: ../../adr/automation/fail-fast-with-asserts.md
[24]: ../../adr/automation/go/go-test-artifacts.md
[25]: ../../adr/automation/go/index.md
[26]: ../../adr/automation/idempotent-state-functions.md
[27]: ../../adr/automation/internal-asset-dependencies.md
[28]: ../../adr/automation/log-before-invoke.md
[29]: ../../adr/automation/managed-guids.md
[30]: ../../adr/automation/never-depend-on-pwd.md
[31]: ../../adr/automation/open-closed-architecture.md
[32]: ../../adr/automation/path-representation.md
[33]: ../../adr/automation/python/index.md
[34]: ../../adr/automation/python/python-test-artifacts.md
[35]: ../../adr/automation/retry-as-last-resort.md
[36]: ../../adr/automation/sensible-defaults.md
[37]: ../../adr/automation/single-responsibility-functions.md
[38]: ../../adr/automation/spell-out-names.md
[39]: ../../adr/automation/test-automation.md
[40]: ../../adr/automation/tool-removal-lifecycle.md
[41]: ../../adr/automation/tracked-files-from-the-index.md
[42]: ../../adr/automation/use-proper-package-managers.md
[43]: ../../adr/automation/uv-python-handler.md
[44]: ../../adr/automation/zero-ceremony-poka-yoke.md
[45]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[46]: ../../../automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
[47]: ../../../automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
[48]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[49]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[50]: ../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[51]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[52]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[53]: ../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[54]: ../../../automation/Catzc.Base.Docs/types/AdrCheck.cs
[55]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[56]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChange.cs
[57]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
[58]: ../../../automation/Catzc.Base.Docs/types/AdrCitationMap.cs
[59]: ../../../automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
[60]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[61]: ../../../automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
[62]: ../../../automation/Catzc.Base.Docs/types/AdrDoraCheck.cs
[63]: ../../../automation/Catzc.Base.Docs/types/AdrNeutralityCheck.cs
[64]: ../../../automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs
[65]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[66]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[67]: ../../../automation/Catzc.Base.Docs/types/AgentEntry.cs
[68]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[69]: ../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[70]: ../../../automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
[71]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[72]: ../../../automation/Catzc.Base.Docs/types/GlossaryEntry.cs
[73]: ../../../automation/Catzc.Base.Docs/types/GlossaryOptions.cs
[74]: ../../../automation/Catzc.Base.Docs/types/GlossaryRealization.cs
[75]: ../../adr/pwsh/announce-state-changes.md
[76]: ../../adr/pwsh/assert-idioms.md
[77]: ../../adr/pwsh/automatic-variable-pitfalls.md
[78]: ../../adr/pwsh/avoid-using-semicolons.md
[79]: ../../adr/pwsh/cross-platform-powershell.md
[80]: ../../adr/pwsh/dora-explains.md
[81]: ../../adr/pwsh/dynamic-module-manifests.md
[82]: ../../adr/pwsh/environment-variable-mechanics.md
[83]: ../../adr/pwsh/hosting-csharp-types.md
[84]: ../../adr/pwsh/identifier-names.md
[85]: ../../adr/pwsh/index.md
[86]: ../../adr/pwsh/module-path-hygiene.md
[87]: ../../adr/pwsh/one-function-per-file.md
[88]: ../../adr/pwsh/parameter-design.md
[89]: ../../adr/pwsh/pester-testing.md
[90]: ../../adr/pwsh/powershell-formatting.md
[91]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[92]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[93]: ../../adr/pwsh/prepost-extension-modules.md
[94]: ../../adr/pwsh/pwsh-engine.md
[95]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[96]: ../../adr/pwsh/script-scope-caching.md
[97]: ../../adr/pwsh/use-ps1-not-psm1.md
[98]: ../../adr/pwsh/vendor-toolset-dependencies.md
[99]: ../../adr/pwsh/working-directory-mechanics.md
[100]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[101]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[102]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[103]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[104]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[105]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[106]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[107]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[108]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[109]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[110]: ../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[111]: ../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[112]: ../../../automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
[113]: ../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[114]: ../../../automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
[115]: ../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[116]: ../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[117]: ../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[118]: ../../../automation/Catzc.Base.QualityGates/types/SpellingOracle.cs
[119]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[120]: ../../../automation/Catzc.Base.Maps/types/CitationSite.cs
[121]: ../../../automation/Catzc.Base.Maps/types/HighlightReason.cs
[122]: ../../../automation/Catzc.Base.Maps/types/HighlightedCell.cs
[123]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[124]: ../../../automation/Catzc.Base.Maps/types/MapPlacement.cs
[125]: ../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[126]: ../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[127]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[128]: ../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[129]: ../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[130]: ../../../automation/Catzc.Base.Maps/types/MapsPin.cs
[131]: ../../../automation/Catzc.Base.Maps/types/TreemapRect.cs
[132]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[133]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[134]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[135]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[136]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[137]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[138]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[139]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[140]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[141]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[142]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[143]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[144]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[145]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[146]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
[147]: ../../../automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
[148]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[149]: ../../../automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs
[150]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
[151]: ../../../automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
[152]: ../../adr/repository/agent-definitions.md
[153]: ../../adr/repository/api-contracts.md
[154]: ../../adr/repository/controlled-vocabulary.md
[155]: ../../adr/repository/conventional-folders.md
[156]: ../../adr/repository/dedicated-output-directory.md
[157]: ../../adr/repository/documentation-examples.md
[158]: ../../adr/repository/domain-language-separation.md
[159]: ../../adr/repository/dora-explains.md
[160]: ../../adr/repository/generated-readmes.md
[161]: ../../adr/repository/inspiration.md
[162]: ../../adr/repository/markdown-links.md
[163]: ../../adr/repository/output-formats.md
[164]: ../../adr/repository/protected-globs.md
[165]: ../../adr/repository/repo-variants.md
[166]: ../../adr/repository/uniform-formatting.md
[167]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[168]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[169]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[170]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[171]: ../../../automation/Catzc.Base.Languages/types/FormatterEngine.cs
[172]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[173]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[174]: ../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[175]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[176]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[177]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[178]: ../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[179]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[180]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[181]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[182]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[183]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[184]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[185]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[186]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[187]: ../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[188]: ../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[189]: ../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[190]: ../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[191]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[192]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[193]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[194]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[195]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[196]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[197]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[198]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[199]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[200]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[201]: ../../../automation/Catzc.Base.Exporter/types/ExporterPackage.cs
[202]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[203]: ../../../automation/Catzc.Azure/types/AzureCustomer.cs
[204]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[205]: ../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[206]: ../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[207]: ../../../automation/Catzc.Azure/types/CustomerConfig.cs
[208]: ../../../automation/Catzc.Azure/types/NetworkConfig.cs
[209]: ../../../automation/Catzc.Azure/types/NetworkEnvironment.cs
[210]: ../../../automation/Catzc.Azure/types/NetworkSubscription.cs
[211]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[212]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[213]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[214]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[215]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[216]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[217]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[218]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[219]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[220]: ../../adr/design/commit-lifecycle.md
[221]: ../../adr/design/dora-explains.md
[222]: ../../adr/design/module-aspects.md
[223]: ../../adr/design/self-service.md
[224]: ../../adr/design/server-remote-integration.md
[225]: ../../adr/design/thin-platforms.md
[226]: ../../adr/design/tracks.md
[227]: ../../adr/design/visual-design.md
[228]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[229]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[230]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[231]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[232]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[233]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[234]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[235]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[236]: ../../adr/principles/configure-not-program.md
[237]: ../../adr/principles/dora-explains.md
[238]: ../../adr/principles/everything-as-code.md
[239]: ../../adr/principles/poka-yoke.md
[240]: ../../adr/principles/reduce-variability.md
[241]: ../../adr/principles/reduce-waste.md
[242]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[243]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[244]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[245]: ../../references/automation/catzc-base-languages.md
[246]: ../../references/automation/catzc-base-rootconfig.md
[247]: ../../references/automation/catzc-base-typessystem.md
[248]: ../../references/automation/internal/catzc-internal-importer.md
[249]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[250]: ../../../automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
[251]: ../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[252]: ../../../automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
[253]: ../../../automation/Catzc.Base.Contracts/types/ContractManifest.cs
[254]: ../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[255]: ../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[256]: ../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[257]: ../../../automation/Catzc.Azure.Templates/types/BicepParameter.cs
[258]: ../../../automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
[259]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[260]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[261]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[262]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[263]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[264]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[265]: ../../../automation/.internal/assets/Import-Catzc.ps1
[266]: ../../../automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
[267]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[268]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[269]: ../../../automation/Catzc.Base.Reports/types/OutputFormat.cs
[270]: ../../../automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs
[271]: ../../../automation/Catzc.Base.Reports/types/OutputPattern.cs
[272]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[273]: ../../../.gitattributes
[274]: ../../../.gitignore
[275]: ../../../importer.ps1
[276]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[277]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[278]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[279]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[280]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[281]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[282]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[283]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[284]: ../../../automation/Catzc.Base.Vendor/types/VendorConfig.cs
[285]: ../../../.claude/CLAUDE.md
[286]: ../../../.claude/agents/build-inspiration-module.md
[287]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[288]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[289]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[290]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[291]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[292]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[293]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[294]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[295]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[296]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
[297]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
[298]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
[299]: ../../../.github/workflows/ci-automation.yml
[300]: ../../../automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
[301]: ../../../automation/Catzc.Azure.DevOps/types/AdoConfig.cs
[302]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[303]: ../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[304]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[305]: ../../adr/index.md
[306]: ../../adr/glossary.md#world-map
[307]: ../../adr/glossary.md#track
[308]: ../../adr/glossary.md#file-language
[309]: ../../adr/glossary.md#cell
[310]: ../../adr/glossary.md#lit-cell
[311]: ../../adr/glossary.md#root-file
[312]: ../../adr/glossary.md#unlisted-file
[313]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[314]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
