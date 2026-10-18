---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-18
  targets:
    [
      pwsh,
      catzc.sln,
      docs/references/pwsh,
      docs/references/.assets/automation,
      docs/adr,
      docs/explanation,
      docs/how-to/getting-started/pwsh,
      .claude/drawio/minimaps/describe.py,
      .claude/drawio/STYLE.md,
      .claude/plans,
    ]
---

# The word "automation" after the move to pwsh/: retire the folder meaning, keep the layer meaning

P4 of plan-layers-vocabulary-rename-contracts moved `automation/` to `pwsh/` on 2026-10-18. A full classification of every `automation` hit
in the tree (963 code lines, 274 plan and agent lines, docs probed by hand; the report is `out/automation-usage-overview.md`) finds about
870 hits correct and a residue that still means the removed folder. This plan removes that residue. It does not touch the pipeline names or
the avoid phrasings: those are P5 and P6 of the rename plan, carried by task-layers-classification-flip steps 6 and 7.

## Why its value is medium-high

One residue is a live break: the root `catzc.sln` points at `automation\.internal\assets\Catzc.Types.csproj`, so C# Dev Kit loads no
project. The rest is drift that misleads every reader and sub-agent: help text sourced from comment pages says the modules sit at
`<RepositoryRoot>/automation`, a generator prints "under `automation/`" into 421 asset descriptions, and tests mock a modules root at
`<repo>/automation`. It needs no new ADR; the doctrine is ADR-AUTO-LAYERS (automation is the abstract layer, pwsh the track) and
ADR-PRIN-ONELIVE (one living version, no "we used to").

## Decided, and why

- **Stays as is**: `automation` as the ADR domain and layer (ADR-AUTO-LAYERS#1, `AdrsConfig.Layers`, the default layer), every
  `docs/adr/automation/` citation, `Test-Automation` and its `*TestAutomation*` helpers, `System.Management.Automation.*`,
  `invoke-automation.yaml` and `release-automation.yml` (rename plan Q2), and "Cloud Automation Toolkit". These are the abstract layer, a
  gate name, .NET, or a decided keep.
- **Replacement words**: where the folder is meant, `pwsh/`; where a variable or parameter holds the folder, `ModulesRoot` / `$modulesRoot`,
  matching `Get-CatzcModulesRoot`; where the layer is meant, "the automation". The executor judges each line by that test.
- **Generated files are fixed at their source**, then regenerated, never edited in place (`catzc.sln`, the `pwsh/.internal/assets` csproj,
  `docs/explanation/.assets/**`).

## Open steps

Every step edits one file and proves it before the next (CLAUDE.md, editing rule). "Grep clean" means `grep -n -i automation <file>` shows
only lines the decided list above keeps. A test check runs under `Invoke-TestFile <test>`.

### The live break first

- [x] `pwsh/Catzc.Base.RootConfig/assets/root/catzc.sln`: the `Catzc.Types` project path is `pwsh\.internal\assets\Catzc.Types.csproj`. The
      root `catzc.sln` is a hard link to this asset (`copyAsLink`), so the edit writes through the same inode and never replaces the file.
      Done 2026-10-18: `grep -c automation catzc.sln` is 0, both paths share one inode, "No root-config-files issues found", and
      `Test-RootConfigFiles.Tests.ps1` passed under `Invoke-TestFile`.
- [x] `pwsh/Catzc.Base.RootConfig/assets/root/.editorconfig:60`: the IDE path example `Catzc.Types.automation.Catzc.Azure.types` becomes
      `Catzc.Types.pwsh.Catzc.Azure.types`; regenerate the root `.editorconfig`. (check: grep clean; `Test-GeneratedFiles` clean) Landed
      2026-10-18 by session catzc-59: grep -i automation 0 on asset and root, the root hard link restored (same inode, 2 links);
      Test-GeneratedFiles 5 issues, none from this file (Build-Readme stale for `pipelines/README.md`, `pipelines/jobs/README.md`,
      `pipelines/stages/README.md`, `pipelines/variables/README.md`, `pwsh/Catzc.Azure.DevOps/README.md`; no owner yet). Trap: the Edit tool
      replaces a copyAsLink root asset and breaks its hard link; re-link with `ln -f`.
- [x] Landed 2026-10-18 by session catzc-59: `AutomationRoot` renamed to `ModulesRoot` at 3 sites, `Catzc.Types.csproj` regenerated in a
      fresh pwsh, grep 0 on both files, Import-CSharpTypes.Tests passed under Invoke-TestFile; Test-GeneratedFiles 2 issues, neither from
      this file (`docs/adr/index.md` stale for Build-AdrIndex, `docs/adr/glossary.md` for Build-Glossary, both dirty in other sessions).
      Original step: `pwsh/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml:87,97,160`: the MSBuild task parameter `AutomationRoot`
      becomes `ModulesRoot` in the declaration, the enumeration and the call; regenerate `pwsh/.internal/assets/Catzc.Types.csproj` from it,
      in a fresh pwsh. (check: grep clean on both files; `Test-GeneratedFiles` clean;
      `Invoke-TestFile     pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1`)
- [x] Landed 2026-10-18 by session catzc-59: 3 sites renamed, grep -i automation 0, Build-VSCodeExtension.Tests passed under
      Invoke-TestFile. Original step: `pwsh/Catzc.Base.VSCode/assets/extensions/catzc-compiled-info.js:11-15`: `automationRoot` becomes
      `modulesRoot`. (check: grep clean; `Invoke-TestFile pwsh/Catzc.Base.VSCode/tests/Build-VSCodeExtension.Tests.ps1`)

### Source code: comments, examples and error text

- [x] Landed 2026-10-18 by session catzc-59: the comment names `Format-Code`, grep -i automation 0, the root hard link restored,
      Test-RootAnalyzerSettings.Tests passed under Invoke-TestFile. Original step:
      `pwsh/.internal/assets/PSScriptAnalyzerSettings.psd1:128`: names `Format-Automation`, which does not exist; name the formatter that
      aligns `=` today (`Format-Code`) or drop the clause. (check: grep clean;
      `Invoke-TestFile     pwsh/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1`)
- [x] Landed 2026-10-18 by session catzc-59: "catzc modules" and "module function"; grep leaves only the kept `Test-Automation` hit on line
      4; Import-AllModules.Tests passed under Invoke-TestFile. Original step: `pwsh/.internal/Catzc.Internal.Bootstrap.psm1:465,495`:
      "automation modules" and "automation function" become "catzc modules" and "module function". (check: grep clean;
      `Invoke-TestFile pwsh/.internal/tests/Import-AllModules.Tests.ps1`) Landed 2026-10-18 by session catzc-59, the twelve steps ticked
      below, each with grep -i automation 0 (or only the kept `System.Management.Automation` hits) and its own test file passing under
      Invoke-TestFile: VariantTrack.cs and VariantsConfig.cs (VariantsConfig.Tests, fresh pwsh; no test asserts the error text), MapsPin.cs
      (MapsConfig.Tests), Get-CatsRuleEnforcers.ps1, Format-GeneratedFileHead.ps1, Format-Types.ps1 (snapshot),
      Test-ConfigIdentityHygiene.ps1, Test-LogicTestIdentity.ps1, Test-ManualTestPlan.ps1, Test-ScriptAnalyzer.ps1,
      Test-SourceConventions.ps1, Test-TestTitles.ps1 (each its `.Tests.ps1`).
- [x] `pwsh/Catzc.Base.Variants/types/VariantTrack.cs:10,13`: the examples `e.g. automation` become `e.g. pwsh`. (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`)
- [x] `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs:261`: the error-text example `e.g. automation` becomes `e.g. pwsh`, and every test
      that asserts that text follows in the same step. (check: grep clean;
      `Invoke-TestFile     pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`)
- [x] `pwsh/Catzc.Base.Maps/types/MapsPin.cs:9`: the track example `automation` becomes `pwsh`. (check: grep clean;
      `Invoke-TestFile     pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1`)
- [x] `pwsh/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1:37`: "levels below automation" becomes "levels below pwsh/"; the depth number
      stays. (check: grep clean; `Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1`)
- [x] `pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1:53`: "outside automation" becomes "outside pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Format-Types.ps1:23`: "as wide as automation" becomes "as wide as pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1:20`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1:21`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1:20`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1:28`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile     pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-SourceConventions.ps1:117`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1`)
- [x] `pwsh/Catzc.Base.QualityGates/Test-TestTitles.ps1:12`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile     pwsh/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1`)
- [x] Landed 2026-10-18 by session catzc-59: grep -i automation 0, Get-FixtureIdentityTokens.Tests passed under Invoke-TestFile. Original
      step: `pwsh/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1:18`: "fixtures under automation" to "under pwsh/". (check:
      grep clean; `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1`)
- [x] Landed 2026-10-18 by session catzc-59: "the types system", `.gitignore` regenerated by `Build-RootConfig -Target .gitignore`; grep
      leaves only the kept `docs/adr/automation/` path in both; Test-GeneratedFiles has no `.gitignore` issue (its 283 are the stale minimap
      pages of the describe.py step). Original step: `.gitignore:94` and its source `pwsh/Catzc.Base.Git/configs/gitignore.yml:82`: "the
      automation types system" becomes "the types system"; edit the yml, regenerate `.gitignore`. (check: grep clean on both;
      `Test-GeneratedFiles` clean)

### Tests that mock the old folder

Landed 2026-10-18 by session catzc-93, all nine below, each "grep clean (only TestAutomation / Test-Automation /
System.Management.Automation remain); Invoke-TestFile Result=Passed ExitCode=0". The first Invoke-TestFile of the last two crashed after 3 s
with empty stderr before any test ran; the shard script run directly and a second Invoke-TestFile passed (an import race, not these edits;
noted in plan-test-run-budget's watch).

- [x] `pwsh/.internal/tests/Import-AllModules.Tests.ps1:63,189-195`: the context title and the `$automation` local become "modules folder"
      and `$modulesRoot`. (check: grep clean; the file passes under `Invoke-TestFile`)
- [x] `pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1:213-230`: `$automation` and the `Automation` parameter key become
      `$modulesRoot` / `ModulesRoot`. (check: grep clean; the file passes)
- [x] `pwsh/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1:3,5,9`: the mocked root `<repo>/automation` becomes
      `<repo>/pwsh`. (check: only `TestAutomation` names remain; the file passes)
- [x] `pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1:18,27`: mocked and expected root to `pwsh`. (check: grep clean; the
      file passes)
- [x] `pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1:48`: mocked root to `pwsh`. (check: grep clean; the file
      passes)
- [x] `pwsh/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1:5`: fake repo path to `repo/pwsh`. (check: grep clean; the file
      passes)
- [x] `pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1:57`: test title "under automation" to "under pwsh/". (check: grep
      clean; the file passes)
- [x] `pwsh/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1:5`: depth comment to "below pwsh/". (check: grep clean; the
      file passes)
- [x] `pwsh/Catzc.Tooling.Core/tests/Get-EngineCaseTable.Tests.ps1:58`: depth comment to "below pwsh/". (check: grep clean; the file passes)

### The generator that prints the old folder into 421 pages

2026-10-18, session catzc-59: describe.py edited (grep leaves only the kept AUTO concern key on line 38); 149 tree pages still carry the old
wording and 283 minimap pages are body-hash stale after commit 06d5525b3. The user's go (2026-10-18): minimaps only,
`drawio_forward.py --all --stage highlight`, one bounded background run per folder, no slides. Blocked the same day: since 06d5525b3 the
kit's `--all` finds only diagram folders (`<article-folder>/.assets/<name>/diagram.drawio.png`), docs/explanation has none yet, so every run
ends `E_SOURCE no diagram folder` (exit 3). Decided by the orchestrator: the rerun waits for the diagram-folders migration
(task-diagram-folders step 6), then runs as approved; the 149 old-wording pages and 283 stale hashes stay until then.

- [x] Done 2026-10-18: every migrated folder re-rendered in the new layout with "residue grep 0" (catzc-fb's per-folder verdicts in
      task-diagram-folders step 6). Original step: `.claude/drawio/minimaps/describe.py:414`: "under `automation/` by module" becomes "under
      `pwsh/` by module"; rerun `render.py` per STYLE.md so every `docs/explanation/.assets/tree/*.tree.md` is rewritten from it. (check:
      `git grep -c "under \`automation/\`" -- docs/explanation/.assets`is empty;`Test-GeneratedFiles` clean)

### Comment pages: the source of the help text

Each page below is edited by hand where it means the folder (`<RepositoryRoot>/automation`, `automation/<Module>/...`, "under automation/"),
never where it means the layer or the ADR domain. Check for each: grep clean, `Test-Comments` and `Test-Links` clean on the page.

Landed 2026-10-18 by session catzc-59, the five ticked below, each Test-Comments ok and Test-Links ok (Get-AutoControlledGlobs keeps "the
automation itself", which means the layer); `gitignore.yml` Format-Code yaml applied, dry run no change, `.gitignore` rebuilt.

- [x] `docs/references/pwsh/catzc-base-config/Get-Config.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-docs/tests/Build-Readme.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-docs/tests/Get-ReadmeMappings.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-files/Get-GitTrackedPath.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
      (also "the automation itself", rename plan line 1033) Landed 2026-10-18 by session catzc-59, batch 2, the five ticked below, each
      Test-Comments ok and Test-Links ok (globs.yml.md keeps the `automation` key and ci-automation for P6).
- [x] `docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-globs/configs/globs.yml.md` (check: grep clean; Test-Comments and Test-Links clean) (the globset key
      `automation` stays until P6; only the folder wording changes)
- [x] `docs/references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links
      clean)
- [x] `docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
      Landed 2026-10-18 by session catzc-59, batch 3, the five ticked below, each Test-Comments ok and Test-Links ok
      (Get-UncoveredInternalAssetDependency's default corrected to Get-CatzcModulesRoot, as the code does; Invoke-TestFile.ps1.md needed no
      change, its hits are `out/test-automation/` and New-TestAutomationShardScript).
- [x] `docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-modulesystem/private/Get-UncoveredInternalAssetDependency.ps1.md` (check: grep clean; Test-Comments
      and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/Format-Types.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/Invoke-TestFile.ps1.md` (check: grep clean; Test-Comments and Test-Links clean) Landed
      2026-10-18 by session catzc-59, batch 4, the five ticked below, each Test-Comments ok and Test-Links ok.
- [x] `docs/references/pwsh/catzc-base-qualitygates/Test-Change.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md` (check: grep clean; Test-Comments and Test-Links
      clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/Test-SourceConventions.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/private/Get-ChangeTestFile.ps1.md` (check: grep clean; Test-Comments and Test-Links
      clean) Landed 2026-10-18 by session catzc-59, batch 5, the five ticked below, each Test-Comments ok and Test-Links ok.
- [x] `docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestFileModule.ps1.md` (check: grep clean; Test-Comments and Test-Links
      clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunContext.ps1.md` (check: grep clean; Test-Comments and Test-Links
      clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean) Landed 2026-10-18 by session catzc-59, batch 6, the five ticked below, each Test-Comments ok and Test-Links ok.
- [x] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md` (check: grep clean; Test-Comments and
      Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-repository/Get-CatzcModulesRoot.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
      (synopsis "root of the catzc automation tree" and the description's `<RepositoryRoot>/automation`)
- [x] `docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md` (check: grep clean; Test-Comments and Test-Links clean) Landed
      2026-10-18 by session catzc-59, batch 7, the five ticked below, each Test-Comments ok and Test-Links ok (index.md keeps the
      getting-started/automation/ link: it is the system guide and no pwsh/ index exists).
- [x] `docs/references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/index.md` (check: grep clean; Test-Comments and Test-Links clean) (the "engine-agnostic `automation/` rules"
      sentence means the ADR domain and stays)
- [x] `docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md` (check: grep clean; Test-Comments and Test-Links clean) Landed
      2026-10-18 by session catzc-59, batch 8, the four ticked below, each Test-Comments ok and Test-Links ok (the TestKit handle corrected
      to `{ Root; ModulesRoot; Saved }`, as the code returns it; "not the automation's to delete" kept, it means the layer).
- [x] `docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/internal/Catzc.Internal.TestKit.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/internal/Catzc.Internal.Types.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/internal/catzc-internal-testkit.md` (check: grep clean; Test-Comments and Test-Links clean) Landed 2026-10-18 by
      session catzc-59, batch 9, the three ticked below, each Test-Comments ok and Test-Links ok; every comment-page step in this section is
      done.
- [x] `docs/references/pwsh/internal/tests/Import-CSharpTypes.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/scriptanalyzer/NoScriptRootAnchor.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [x] `docs/references/pwsh/scriptanalyzer/ParameterDesign.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)

### The references asset folder named after the old track

- [ ] The user runs `git mv docs/references/.assets/automation docs/references/.assets/pwsh` (a mutating git command; it belongs in
      task-user-runs-and-commits). (check: `ls docs/references/.assets/automation` fails)
- [ ] `.claude/drawio/STYLE.md:206`: the asset path becomes `docs/references/.assets/pwsh/<module-kebab>/`. (check: grep clean)
- [ ] `docs/adr/repository/conventional-folders.md:272`: `references/.assets/automation/<module>/` becomes
      `references/.assets/pwsh/<module>/`. (check: grep shows only domain links; `Test-Links` clean)
- [ ] Every page that links into the moved folder is re-pointed by `link-fixer`. (check: `Test-Links` clean over `docs/`)
- [ ] The eleven `docs/references/.assets/pwsh/**/*.drawio.verify.md` notes: "relative to `automation/`" becomes "relative to `pwsh/`", one
      file at a time. (check: `git grep -c "automation/" -- docs/references/.assets` is empty)

### Hand-written docs prose that means the folder

Each page: reword `automation/` to `pwsh/` where the modules folder is meant; leave links into `docs/adr/automation/`, the how-to folders
and the layer wording alone. Check for each: grep shows no folder-meaning line, `Test-Links` clean on the page. A `.drawio.md` page changes
its prose only, never the generated sidebar.

Landed 2026-10-18 by session catzc-59, ADR batch 1, the five ticked below, each Test-Links ok (durable-sha-globs: the `pwsh/**` pattern row
now matches its own examples; pipeline-runner-pattern needed no change, line 35 already says pwsh/).

- [x] `docs/adr/azure/caf/platform-automation-and-devops.md` (check: no folder-meaning line; Test-Links clean) (line 326)
- [x] `docs/adr/azure/waf/operational-excellence.md` (check: no folder-meaning line; Test-Links clean) (line 522)
- [x] `docs/adr/configuration/module-config-loading.md` (check: no folder-meaning line; Test-Links clean) (lines 82, 114)
- [x] `docs/adr/flow/durable-sha-globs.md` (check: no folder-meaning line; Test-Links clean) (the glob table at 171 to 174 uses
      `automation/` as sample paths: switch them to `pwsh/`; line 281)
- [x] `docs/adr/flow/pipeline-runner-pattern.md` (check: no folder-meaning line; Test-Links clean) (line 35) ADR batches 2 and 3, session
      catzc-59, 2026-10-18, the twelve ticked below, each Test-Links ok. No change needed in `pwsh/index.md` and `pwsh-engine.md` (their
      `automation/` means the ADR domain); layer-meaning lines kept in pipeline-types, generated-readmes and generated-root-configs;
      protected-globs keeps the `test-automation|…` protection keys (key format). dynamic-module-manifests now matches Export-Catzc's
      `out/pwsh/packages/` and the Builder's `# source: pwsh/<Module>/<path>` marker.
- [x] `docs/adr/flow/pipeline-types.md` (check: no folder-meaning line; Test-Links clean) (lines 14, 180)
- [x] `docs/adr/pwsh/bounded-enumeration.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/dynamic-module-manifests.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/index.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/one-function-per-file.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/pester-testing.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/prepost-extension-modules.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/pwsh-engine.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/pwsh/working-directory-mechanics.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/repository/generated-readmes.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/repository/generated-root-configs.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/adr/repository/protected-globs.md` (check: no folder-meaning line; Test-Links clean) Explanation batch 1, session catzc-59,
      2026-10-18, each Test-Links ok. Ticked: the two configuration pages. Free prose done but kept open for the slide migration
      (slide-label lines are changed with their slides, never ahead): `a-push-fires-only-touched-pipelines.drawio.md` line 32 (the slide's
      named-set label `automation/**`); `get-aspect-feeds-globs-and-maps.md` text block lines 6, 9, 10;
      `manifest-and-aspects-from-one-folder.md` text block lines 6, 10 and marker label 30. Their `aspects.automation` / `-Track automation`
      lines are the open drift step in plan-explanation-drift-gaps.
- [x] `docs/explanation/configuration/callers-depend-on-one-config-module.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/configuration/three-caches-back-one-reader.md` (check: no folder-meaning line; Test-Links clean)
  2026-10-18, session catzc-fb with the user's go: the slide-label lines below changed with their slides ("every stage clean; LINKS 0,
  FILEMETA 0, Test-Glossary 0 on each article"); every open step of this block is now ticked.
- [x] `docs/explanation/design/a-push-fires-only-touched-pipelines.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/get-aspect-feeds-globs-and-maps.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/manifest-and-aspects-from-one-folder.md` (check: no folder-meaning line; Test-Links clean) Explanation batch
      2, session catzc-59, 2026-10-18, each Test-Links ok; free prose done, all kept open for the slide migration:
      `manifest-and-aspects-from-one-folder.drawio.md` 21, 32, 43 and `one-folder-two-independent-readers.drawio.md` 21, 32, 43 (slide
      labels, no edit); `one-folder-two-independent-readers.md` text block 6, marker label 28; `only-automation-compiles-its-aspects.md`
      title, lines 1, 4, 22 (slide title and slug), text block 8, plus its "automation track/convention" drift at 18, 29, 33 (the drift step
      in plan-explanation-drift-gaps); `partition-integrity-runs-only-in-unit-tests.md` text block 6, marker label 29 and its `.drawio.md`
      21, 33, 42 (no edit).
- [x] `docs/explanation/design/manifest-and-aspects-from-one-folder.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/one-folder-two-independent-readers.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/one-folder-two-independent-readers.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/only-automation-compiles-its-aspects.md` (check: no folder-meaning line; Test-Links clean) (the title means
      the track: the page's file name is the user's call, the prose changes)
- [x] `docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/partition-integrity-runs-only-in-unit-tests.drawio.md` (check: no folder-meaning line; Test-Links clean)
      Explanation batch 3, session catzc-59, 2026-10-18, each Test-Links ok. Ticked: which-run-mode-rules-have-a-gate, ci-budget,
      declare-or-add-folder. Kept open for the slide migration: `two-roots-one-importer-same-modules.md` text block 7 and marker label 32
      (`<RepositoryRoot>/automation`); `the-runner-is-the-only-seam.md` text block 10 (line 16 "its automation" means the layer and stays).
- [x] `docs/explanation/design/two-roots-one-importer-same-modules.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/design/which-run-mode-rules-have-a-gate.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/flow/ci-budget-is-the-only-quality-gate.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/flow/the-runner-is-the-only-seam.md` (check: no folder-meaning line; Test-Links clean) Explanation batch 4, session
      catzc-59, 2026-10-18, each Test-Links ok; every docs/explanation page of this section is reworded. Ticked: two-declared-layers (line
      31's `automation` is the globset key, kept until P6), one-source (line 35 means the layer). Kept open:
      `one-registry-one-writer-two-primitives.md` text block 6 (slide label).
- [x] `docs/explanation/flow/two-declared-layers-one-derived.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/repository/one-registry-one-writer-two-primitives.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/explanation/repository/one-source-one-writer-one-boolean.md` (check: no folder-meaning line; Test-Links clean) How-to batch,
      session catzc-59, 2026-10-18, the five ticked below, each Test-Links ok; the two index pages needed no change ("under `automation/`"
      names the getting-started guide folder, "automation platform" the layer). The section is closed but for the slide-label lines kept
      open above for the migration.
- [x] `docs/how-to/getting-started/pwsh/BCL/add-a-dotnet-type.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/how-to/getting-started/pwsh/BCL/index.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/how-to/getting-started/pwsh/add-a-module.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/how-to/getting-started/pwsh/powershell/add-a-function.md` (check: no folder-meaning line; Test-Links clean)
- [x] `docs/how-to/getting-started/pwsh/powershell/index.md` (check: no folder-meaning line; Test-Links clean)

  Found by the Close scan 2026-10-18 and landed the same day by session catzc-59, each Test-Links ok; one kept open for its slide labels
  (text block lines 7, 11 and marker label 33).

- [x] `docs/adr/automation/platform-bundle.md` (check: no folder-meaning line; Test-Links clean) (line 133)
- [x] `docs/adr/automation/internal-asset-dependencies.md` (check: no folder-meaning line; Test-Links clean) (line 77)
- [x] `docs/explanation/automation/two-entries-feed-one-importer.md` (check: no folder-meaning line; Test-Links clean) (line 37)
- [x] `docs/explanation/design/one-entry-script-per-mode.md` (check: no folder-meaning line; Test-Links clean) (line 29)
- [x] `docs/explanation/design/shims-set-roots-mode-read-back.md` (check: no folder-meaning line; Test-Links clean) (body lines 33, 44 done;
      the slide-label lines wait for the migration)

### Plans that still say P4 waits or name removed functions

- [x] `plan-clear` over `plan-layers-vocabulary-rename-contracts.md`: about 40 lines name `Get-AutomationModules`, `Copy-Automation`,
      `-AutomationRoot` or P2 and P4 work as present or pending, line 58 names a prompt file that is gone, and three link labels name the
      absorbed `plan-automation-layers-rename.md`. (check: `Test-Plans` clean on the file) Done 2026-10-18 (catzc-59): the head and the top
      sections say P0 to P4 landed, the gone prompt file and the stale memory note are out, the link labels name the file itself, and the
      carried drafts are trimmed from 860 lines to what is still open (P6 and its edges, the stray pwsh rules, L3 to L5 with Q-L1 to Q-L5,
      C7 and contract use 4 with their traps, the do-not-sweep list); 1,034 lines to 264. Test-Plans 0 issues on the file.
- [x] `plan-clear` over `decisions-2026-10-18.md` (line 24 says P4 waits), `task-layers-classification-flip.md` (lines 13, 38),
      `questionnaire-2026-10-18.md` (lines 23, 37), `plan-module-model-closeout.md` (lines 28, 34, 35), `task-module-model-closeout.md`
      (lines 48, 49), `value-of-plan.md` (line 33). (check: `Test-Plans` clean on each) Done 2026-10-18 (catzc-59): D10's outcome says P4
      landed (row width kept); the flip task's head, intro, steps 3 and 4 and report are present tense (the obj/bin unstage signal was
      closed, 0 tracked); Copy-Automation is Copy-CatzcModule in the questionnaire, both module-model-closeout files and value-of-plan.
      Test-Plans 0 issues on each of the six.

### Close

- [ ] The residue scan is empty. (check:
      `git grep -n -i -E "\\\$automation\b|AutomationRoot|automationRoot|<RepositoryRoot>/automation|     under automation/" -- pwsh docs .claude/drawio`
      prints nothing; the final full `Test-Automation` of task-user-runs-and-commits is the tree-wide proof)

## Open questions (for the next decision round)

- **The how-to folders named automation.** `docs/how-to/automation/` and `docs/how-to/getting-started/automation/` hold cross-track pages
  (deployable unit, doc chapter, infra template, go/, python/), so the name reads as the abstract layer beside their `pwsh/` siblings.
  Recommendation: keep, since ADR-AUTO-LAYERS makes automation the abstract term.
- **31 test fixtures shaped like the old folder** (`C:\repo\automation\M\...` in Convert-TestRunLocationPath, Select-TestRunFiles,
  Select-InScopeTestFiles, Assert-CatzcRunModeExclusive, Test-Links.Repository, Write-TestRunContext, Test-LoadedTypesCurrent,
  Assert-LoadedTypesCurrent, Get-FileKind and the VariantsConfig track-key fixtures). They are fake data. Recommendation: rename to a
  neutral segment only when a test is next edited, under the neutral-fixture rule (ADR-AUTO-TEST#3), with no sweep.

## Refs

- `out/automation-usage-overview.md`: the classification report, classes, counts and per-file evidence.
- plan-layers-vocabulary-rename-contracts and task-layers-classification-flip steps 6 (P5 guards) and 7 (P6 pipeline names): the globset key
  `automation`, `ci-automation*`, `build-validation.yml`, the README badge, the avoid phrasings and tracks.md line 53 land there, not here.
- ADR-AUTO-LAYERS (the layer doctrine), ADR-PRIN-ONELIVE (no residue of the old shape), ADR-REPO-PLANS (this file's shape).
