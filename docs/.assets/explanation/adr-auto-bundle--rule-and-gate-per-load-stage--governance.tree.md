# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Tree minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 326 files in 39 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- adr/auto (docs/adr/automation): 39 lit files
- docs (docs/ outside docs/adr/): 39 lit files
- adr/pwsh (docs/adr/pwsh): 26 lit files
- Docs (automation/Catzc.Base.Docs): 22 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 20 lit files
- Maps (automation/Catzc.Base.Maps): 16 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 16 lit files
- adr/repo (docs/adr/repository): 15 lit files
- Languages (automation/Catzc.Base.Languages): 12 lit files
- VSCode (automation/Catzc.Base.VSCode): 12 lit files
- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- Azure (automation/Catzc.Azure): 9 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 8 lit files
- adr/prin (docs/adr/principles): 7 lit files
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

### adr/auto (39 lit files)

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
- [docs/adr/automation/caching.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][11], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/dry-run.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/environment-variables.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/go/test-artifacts.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][26], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][27], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/never-depend-on-pwd.md][28], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/path-representation.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/protected-globs.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/python/index.md][32], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][33], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][34], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][35], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][36], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][37], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/test-automation.md][38], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][39], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][40], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][41], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][42], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][43], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.

### docs (39 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][44], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][45], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][46], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][47], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][48], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][49], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][50], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][51], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 56 (text) and line 63 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 56 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 56 (text) and line 64 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text) and line 64 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line
  56 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][52], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][53], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 67 (text) and line 74 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][54], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][55], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][58], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][59], in the cell docs × markdown:
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 68 (text).
- [docs/explanation/automation/build-then-place-with-one-command.md][60], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][61], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][62], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][63], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][64], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 47
  (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][65], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][66], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it
  at line 15 (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][67], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 45 (text) and line 68 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line
  41 (text), line 51 (text), line 66 (text), line 69 (text) and line 73 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line
  33 (text) and line 61 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 62 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 33 (text), line 44 (text), line 60 (text) and line 67 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][68], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][69], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text)
  and line 61 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text)
  and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][70], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 17 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][71], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][72], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 17 (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][73], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 14 (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][74], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line
  61 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][75], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 32 (text).
- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][76], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 30 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][77], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][78], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 111 (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][79], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][80], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 43 (text) and line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][81], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][82], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 36 (text).

### adr/pwsh (26 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/announce-state-changes.md][83], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/assert-idioms.md][84], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][85], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][86], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/cross-platform-powershell.md][87], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dora-explains.md][88], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][89], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][90], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/error-handling.md][5], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][91], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/identifier-names.md][92], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][93], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][94], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/one-function-per-file.md][95], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/parameter-design.md][96], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][97], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][98], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][99], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][100], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][101], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pwsh-engine.md][102], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][103], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/script-scope-caching.md][104], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][105], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][106], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][107], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.

### Docs (22 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][108], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1][109], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1][110], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 3 (header) and line 24 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][111], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 162 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 101 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 192 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][112], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][113], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][114], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 1 (text).
- [automation/Catzc.Base.Docs/types/AdrCitationChange.cs][115], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs][116], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationMap.cs][117], in the cell automation × csharp: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs][118], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][119], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/AdrDomainEdge.cs][120], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][121], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][122], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Docs/types/AgentEntry.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryAvoid.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][126], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.Docs/types/GlossaryEntry.cs][127], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryOptions.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryRealization.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).

### QualityGates (20 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][130], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the
  file cites it at line 65 (header), line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][131], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][132], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][133], in the cell automation × yaml: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 18 (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][134], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 588 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 568 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 608 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][135], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][136], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 7 (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][137], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][138], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 37 (text) and line 37 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][139], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][140], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1][141], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 29 (text) and line 80 (text).
- [automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1][142], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 36 (text).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][143], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81 (text).
- [automation/Catzc.Base.QualityGates/types/GuidsConfig.cs][144], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][145], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs][146], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][147], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/types/SpellingOracle.cs][148], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][149], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).

### Maps (16 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/CitationSite.cs][150], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/HighlightReason.cs][151], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/HighlightedCell.cs][152], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][153], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Maps/types/MapPlacement.cs][154], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][155], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][156], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][157], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][158], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][159], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPin.cs][160], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Maps/types/TreemapRect.cs][161], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][162], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][163], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][164], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 25 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][165], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 10 (header).

### ModuleSystem (16 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][166], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 29 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][167], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][168], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][169], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][170], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][171], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][172], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 23 (header) and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][173], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][174], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 35 (text) and line 113 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][175], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs][176], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/BaseModule.cs][177], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][178], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs][179], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs][180], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs][181], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][182], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][183], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][184], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][185], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][186], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][187], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][188], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][189], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][190], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][6], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][191], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][192], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][193], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][194], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][195], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Languages (12 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][196], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 25 (header).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][197], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][198], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][199], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FormatterEngine.cs][200], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][201], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][202], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][203], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 2 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][204], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][205], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][206], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][207], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).

### VSCode (12 lit files)

The group holds the files of automation/Catzc.Base.VSCode; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][208], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][209], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][210], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 18 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][211], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][212], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][213], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][214], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][215], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][216], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][217], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 2 (header).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][218], in the cell automation × csharp: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][219], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 9 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### Exporter (10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][220], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][221], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 52 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][222], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][223], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][224], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][225], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][226], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][227], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][228], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterPackage.cs][229], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Azure (9 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][230], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Azure/types/AzureCustomer.cs][231], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][232], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][233], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][234], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/types/CustomerConfig.cs][235], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/NetworkConfig.cs][236], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Azure/types/NetworkEnvironment.cs][237], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/NetworkSubscription.cs][238], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).

### TypesSystem (9 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][239], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][240], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][241], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 12 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][242], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][243], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][244], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 19 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][245], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][246], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][247], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][248], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][249], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][250], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][3], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][251], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][252], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][253], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][254], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][255], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### RootConfig (8 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][256], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 24 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][257], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][258], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][259], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][260], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][261], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][262], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][263], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 6 (header).

### adr/prin (7 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/configure-not-program.md][264], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/dora-explains.md][265], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/everything-as-code.md][266], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/one-living-version.md][4], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/poka-yoke.md][267], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles`
  ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-variability.md][268], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-waste.md][269], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.

### Contracts (6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][270], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).
- [automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1][271], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header) and line 23 (text).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][272], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractCheckResult.cs][273], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractManifest.cs][274], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][275], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 12 (header).

### Az.Templates (5 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][276], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 103 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][277], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 133 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepParameter.cs][278], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header) and line 8 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameterModel.cs][279], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][280], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).

### Repository (5 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][281], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][282], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][283], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][284], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][285], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 1 (text).

### .internal (4 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][286], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1][287], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header) and line 9 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][288], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][289], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 2 (header), line 17 (text), line 38 (text) and line 75 (text).

### Reports (4 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/types/OutputFormat.cs][290], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs][291], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/types/OutputPattern.cs][292], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 67 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][293], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][294], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][295], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [importer.ps1][296], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
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

- [automation/Catzc.Base.Git/New-GitIgnore.ps1][297], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][298], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][299], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 6 (header).

### Variants (3 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantAspect.cs][300], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][301], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][302], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Vendor (3 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][303], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][304], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Vendor/types/VendorConfig.cs][305], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][306], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 57 (text) and line
  121 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 30 (text).
- [.claude/agents/build-inspiration-module.md][307], in the cell .claude × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 25 (text).

### Az.DevOps.BuildValidation (2 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][308], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][309], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).

### Files (2 lit files)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/Set-FileLink.ps1][310], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][311], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 20 (header).

### Objects (2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][312], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][313], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (text).

### Timeouts (2 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][314], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][315], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Tool.Inspiration (2 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][316], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs][317], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 4 (header).

### Tool.KeyHandler (2 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs][318], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs][319], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][320], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .scriptanalyzer (1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1][321], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 3 (text).

### Az.DevOps (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/types/AdoConfig.cs][322], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][323], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).

### Engines (1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][324], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][325], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 29 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][326], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15
  (text) and line 178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 273 (text).

## Keywords

- [world map][327]
- [track][328]
- [file language][329]
- [cell][330]
- [lit cell][331]
- [root file][332]
- [unlisted file][333]
- [.claude][334]: a track
- [.github][334]: a track
- [automation][334]: a track
- [docs][334]: a track
- [csharp][335]: a file language
- [markdown][335]: a file language
- [powershell][335]: a file language
- [yaml][335]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/repository/generated-root-configs.md
[7]: ../../adr/automation/BCL/index.md
[8]: ../../adr/automation/avoid-deep-nesting.md
[9]: ../../adr/automation/bash/bash-test-artifacts.md
[10]: ../../adr/automation/caching.md
[11]: ../../adr/automation/console-output-matters.md
[12]: ../../adr/automation/controlling-module-dependencies.md
[13]: ../../adr/automation/controlling-systemwide-deps.md
[14]: ../../adr/automation/cross-platform.md
[15]: ../../adr/automation/devbox-pipeline-parity.md
[16]: ../../adr/automation/dora-explains.md
[17]: ../../adr/automation/dry-run.md
[18]: ../../adr/automation/effective-in-enterprises.md
[19]: ../../adr/automation/environment-variables.md
[20]: ../../adr/automation/execution-engines.md
[21]: ../../adr/automation/fail-fast-with-asserts.md
[22]: ../../adr/automation/go/index.md
[23]: ../../adr/automation/go/test-artifacts.md
[24]: ../../adr/automation/idempotent-state-functions.md
[25]: ../../adr/automation/internal-asset-dependencies.md
[26]: ../../adr/automation/log-before-invoke.md
[27]: ../../adr/automation/managed-guids.md
[28]: ../../adr/automation/never-depend-on-pwd.md
[29]: ../../adr/automation/open-closed-architecture.md
[30]: ../../adr/automation/path-representation.md
[31]: ../../adr/automation/protected-globs.md
[32]: ../../adr/automation/python/index.md
[33]: ../../adr/automation/python/python-test-artifacts.md
[34]: ../../adr/automation/retry-as-last-resort.md
[35]: ../../adr/automation/sensible-defaults.md
[36]: ../../adr/automation/single-responsibility-functions.md
[37]: ../../adr/automation/spell-out-names.md
[38]: ../../adr/automation/test-automation.md
[39]: ../../adr/automation/tool-removal-lifecycle.md
[40]: ../../adr/automation/tracked-files-from-the-index.md
[41]: ../../adr/automation/use-proper-package-managers.md
[42]: ../../adr/automation/uv-python-handler.md
[43]: ../../adr/automation/zero-ceremony-poka-yoke.md
[44]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[45]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[46]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[47]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[48]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[49]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[50]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[51]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[52]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[53]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[54]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[55]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[56]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[57]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[58]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[59]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[60]: ../../explanation/automation/build-then-place-with-one-command.md
[61]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[62]: ../../explanation/automation/dot-source-one-entry-script.md
[63]: ../../explanation/automation/every-code-root-is-a-copy.md
[64]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[65]: ../../explanation/automation/invoke-importer-in-code-order.md
[66]: ../../explanation/automation/one-commit-one-immutable-package.md
[67]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[68]: ../../explanation/automation/two-entries-feed-one-importer.md
[69]: ../../explanation/automation/what-gates-each-bundle-stage.md
[70]: ../../explanation/design/one-entry-script-per-mode.md
[71]: ../../explanation/design/shims-set-roots-mode-read-back.md
[72]: ../../explanation/design/two-roots-one-importer-same-modules.md
[73]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[74]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[75]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[76]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[77]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[78]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[79]: ../../references/automation/catzc-base-languages.md
[80]: ../../references/automation/catzc-base-rootconfig.md
[81]: ../../references/automation/catzc-base-typessystem.md
[82]: ../../references/automation/internal/catzc-internal-importer.md
[83]: ../../adr/pwsh/announce-state-changes.md
[84]: ../../adr/pwsh/assert-idioms.md
[85]: ../../adr/pwsh/automatic-variable-pitfalls.md
[86]: ../../adr/pwsh/avoid-using-semicolons.md
[87]: ../../adr/pwsh/cross-platform-powershell.md
[88]: ../../adr/pwsh/dora-explains.md
[89]: ../../adr/pwsh/dynamic-module-manifests.md
[90]: ../../adr/pwsh/environment-variable-mechanics.md
[91]: ../../adr/pwsh/hosting-csharp-types.md
[92]: ../../adr/pwsh/identifier-names.md
[93]: ../../adr/pwsh/index.md
[94]: ../../adr/pwsh/module-path-hygiene.md
[95]: ../../adr/pwsh/one-function-per-file.md
[96]: ../../adr/pwsh/parameter-design.md
[97]: ../../adr/pwsh/pester-testing.md
[98]: ../../adr/pwsh/powershell-formatting.md
[99]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[100]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[101]: ../../adr/pwsh/prepost-extension-modules.md
[102]: ../../adr/pwsh/pwsh-engine.md
[103]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[104]: ../../adr/pwsh/script-scope-caching.md
[105]: ../../adr/pwsh/use-ps1-not-psm1.md
[106]: ../../adr/pwsh/vendor-toolset-dependencies.md
[107]: ../../adr/pwsh/working-directory-mechanics.md
[108]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[109]: ../../../automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
[110]: ../../../automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
[111]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[112]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[113]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[114]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[115]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChange.cs
[116]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
[117]: ../../../automation/Catzc.Base.Docs/types/AdrCitationMap.cs
[118]: ../../../automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
[119]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[120]: ../../../automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
[121]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[122]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[123]: ../../../automation/Catzc.Base.Docs/types/AgentEntry.cs
[124]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[125]: ../../../automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
[126]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[127]: ../../../automation/Catzc.Base.Docs/types/GlossaryEntry.cs
[128]: ../../../automation/Catzc.Base.Docs/types/GlossaryOptions.cs
[129]: ../../../automation/Catzc.Base.Docs/types/GlossaryRealization.cs
[130]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[131]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[132]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[133]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[134]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[135]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[136]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[137]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[138]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[139]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[140]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[141]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1
[142]: ../../../automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1
[143]: ../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[144]: ../../../automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
[145]: ../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[146]: ../../../automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
[147]: ../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[148]: ../../../automation/Catzc.Base.QualityGates/types/SpellingOracle.cs
[149]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[150]: ../../../automation/Catzc.Base.Maps/types/CitationSite.cs
[151]: ../../../automation/Catzc.Base.Maps/types/HighlightReason.cs
[152]: ../../../automation/Catzc.Base.Maps/types/HighlightedCell.cs
[153]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[154]: ../../../automation/Catzc.Base.Maps/types/MapPlacement.cs
[155]: ../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[156]: ../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[157]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[158]: ../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[159]: ../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[160]: ../../../automation/Catzc.Base.Maps/types/MapsPin.cs
[161]: ../../../automation/Catzc.Base.Maps/types/TreemapRect.cs
[162]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[163]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[164]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[165]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[166]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[167]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[168]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[169]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[170]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[171]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[172]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[173]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[174]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[175]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[176]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
[177]: ../../../automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
[178]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[179]: ../../../automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs
[180]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
[181]: ../../../automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
[182]: ../../adr/repository/agent-definitions.md
[183]: ../../adr/repository/api-contracts.md
[184]: ../../adr/repository/controlled-vocabulary.md
[185]: ../../adr/repository/conventional-folders.md
[186]: ../../adr/repository/dedicated-output-directory.md
[187]: ../../adr/repository/documentation-examples.md
[188]: ../../adr/repository/domain-language-separation.md
[189]: ../../adr/repository/dora-explains.md
[190]: ../../adr/repository/generated-readmes.md
[191]: ../../adr/repository/inspiration.md
[192]: ../../adr/repository/markdown-links.md
[193]: ../../adr/repository/output-formats.md
[194]: ../../adr/repository/repo-variants.md
[195]: ../../adr/repository/uniform-formatting.md
[196]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[197]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[198]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[199]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[200]: ../../../automation/Catzc.Base.Languages/types/FormatterEngine.cs
[201]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[202]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[203]: ../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[204]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[205]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[206]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[207]: ../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[208]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[209]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[210]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[211]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[212]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[213]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[214]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[215]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[216]: ../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[217]: ../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[218]: ../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[219]: ../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[220]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[221]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[222]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[223]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[224]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[225]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[226]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[227]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[228]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[229]: ../../../automation/Catzc.Base.Exporter/types/ExporterPackage.cs
[230]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[231]: ../../../automation/Catzc.Azure/types/AzureCustomer.cs
[232]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[233]: ../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[234]: ../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[235]: ../../../automation/Catzc.Azure/types/CustomerConfig.cs
[236]: ../../../automation/Catzc.Azure/types/NetworkConfig.cs
[237]: ../../../automation/Catzc.Azure/types/NetworkEnvironment.cs
[238]: ../../../automation/Catzc.Azure/types/NetworkSubscription.cs
[239]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[240]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[241]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[242]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[243]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[244]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[245]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[246]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[247]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[248]: ../../adr/design/commit-lifecycle.md
[249]: ../../adr/design/dora-explains.md
[250]: ../../adr/design/module-aspects.md
[251]: ../../adr/design/self-service.md
[252]: ../../adr/design/server-remote-integration.md
[253]: ../../adr/design/thin-platforms.md
[254]: ../../adr/design/tracks.md
[255]: ../../adr/design/visual-design.md
[256]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[257]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[258]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[259]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[260]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[261]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[262]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[263]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[264]: ../../adr/principles/configure-not-program.md
[265]: ../../adr/principles/dora-explains.md
[266]: ../../adr/principles/everything-as-code.md
[267]: ../../adr/principles/poka-yoke.md
[268]: ../../adr/principles/reduce-variability.md
[269]: ../../adr/principles/reduce-waste.md
[270]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[271]: ../../../automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
[272]: ../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[273]: ../../../automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
[274]: ../../../automation/Catzc.Base.Contracts/types/ContractManifest.cs
[275]: ../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[276]: ../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[277]: ../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[278]: ../../../automation/Catzc.Azure.Templates/types/BicepParameter.cs
[279]: ../../../automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
[280]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[281]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[282]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[283]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[284]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[285]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[286]: ../../../automation/.internal/assets/Import-Catzc.ps1
[287]: ../../../automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
[288]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[289]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[290]: ../../../automation/Catzc.Base.Reports/types/OutputFormat.cs
[291]: ../../../automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs
[292]: ../../../automation/Catzc.Base.Reports/types/OutputPattern.cs
[293]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[294]: ../../../.gitattributes
[295]: ../../../.gitignore
[296]: ../../../importer.ps1
[297]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[298]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[299]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[300]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[301]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[302]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[303]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[304]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[305]: ../../../automation/Catzc.Base.Vendor/types/VendorConfig.cs
[306]: ../../../.claude/CLAUDE.md
[307]: ../../../.claude/agents/build-inspiration-module.md
[308]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[309]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[310]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[311]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[312]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[313]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[314]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[315]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[316]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[317]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
[318]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
[319]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
[320]: ../../../.github/workflows/ci-automation.yml
[321]: ../../../automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
[322]: ../../../automation/Catzc.Azure.DevOps/types/AdoConfig.cs
[323]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[324]: ../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[325]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[326]: ../../adr/index.md
[327]: ../../adr/glossary.md#world-map
[328]: ../../adr/glossary.md#track
[329]: ../../adr/glossary.md#file-language
[330]: ../../adr/glossary.md#cell
[331]: ../../adr/glossary.md#lit-cell
[332]: ../../adr/glossary.md#root-file
[333]: ../../adr/glossary.md#unlisted-file
[334]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[335]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
