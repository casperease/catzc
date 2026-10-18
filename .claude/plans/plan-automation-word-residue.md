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

P4 of plan-layers-vocabulary-rename-contracts moved `automation/` to `pwsh/` on 2026-10-18. A full classification of every
`automation` hit in the tree (963 code lines, 274 plan and agent lines, docs probed by hand; the report is
`out/automation-usage-overview.md`) finds about 870 hits correct and a residue that still means the removed folder. This plan removes
that residue. It does not touch the pipeline names or the avoid phrasings: those are P5 and P6 of the rename plan, carried by
task-layers-classification-flip steps 6 and 7.

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
- **Replacement words**: where the folder is meant, `pwsh/`; where a variable or parameter holds the folder, `ModulesRoot` /
  `$modulesRoot`, matching `Get-CatzcModulesRoot`; where the layer is meant, "the automation". The executor judges each line by that test.
- **Generated files are fixed at their source**, then regenerated, never edited in place (`catzc.sln`, the `pwsh/.internal/assets`
  csproj, `docs/explanation/.assets/**`).

## Open steps

Every step edits one file and proves it before the next (CLAUDE.md, editing rule). "Grep clean" means
`grep -n -i automation <file>` shows only lines the decided list above keeps. A test check runs under `Invoke-TestFile <test>`.

### The live break first

- [x] `pwsh/Catzc.Base.RootConfig/assets/root/catzc.sln`: the `Catzc.Types` project path is `pwsh\.internal\assets\Catzc.Types.csproj`.
      The root `catzc.sln` is a hard link to this asset (`copyAsLink`), so the edit writes through the same inode and never replaces the
      file. Done 2026-10-18: `grep -c automation catzc.sln` is 0, both paths share one inode, "No root-config-files issues found", and
      `Test-RootConfigFiles.Tests.ps1` passed under `Invoke-TestFile`.
- [ ] `pwsh/Catzc.Base.RootConfig/assets/root/.editorconfig:60`: the IDE path example `Catzc.Types.automation.Catzc.Azure.types` becomes
      `Catzc.Types.pwsh.Catzc.Azure.types`; regenerate the root `.editorconfig`. (check: grep clean; `Test-GeneratedFiles` clean)
- [ ] `pwsh/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml:87,97,160`: the MSBuild task parameter `AutomationRoot` becomes
      `ModulesRoot` in the declaration, the enumeration and the call; regenerate `pwsh/.internal/assets/Catzc.Types.csproj` from it, in a
      fresh pwsh. (check: grep clean on both files; `Test-GeneratedFiles` clean; `Invoke-TestFile
      pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.VSCode/assets/extensions/catzc-compiled-info.js:11-15`: `automationRoot` becomes `modulesRoot`. (check: grep
      clean; `Invoke-TestFile pwsh/Catzc.Base.VSCode/tests/Build-VSCodeExtension.Tests.ps1`)

### Source code: comments, examples and error text

- [ ] `pwsh/.internal/assets/PSScriptAnalyzerSettings.psd1:128`: names `Format-Automation`, which does not exist; name the formatter that
      aligns `=` today (`Format-Code`) or drop the clause. (check: grep clean; `Invoke-TestFile
      pwsh/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1`)
- [ ] `pwsh/.internal/Catzc.Internal.Bootstrap.psm1:465,495`: "automation modules" and "automation function" become "catzc modules" and
      "module function". (check: grep clean; `Invoke-TestFile pwsh/.internal/tests/Import-AllModules.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.Variants/types/VariantTrack.cs:10,13`: the examples `e.g. automation` become `e.g. pwsh`. (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs:261`: the error-text example `e.g. automation` becomes `e.g. pwsh`, and every
      test that asserts that text follows in the same step. (check: grep clean; `Invoke-TestFile
      pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.Maps/types/MapsPin.cs:9`: the track example `automation` becomes `pwsh`. (check: grep clean; `Invoke-TestFile
      pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1:37`: "levels below automation" becomes "levels below pwsh/"; the depth
      number stays. (check: grep clean; `Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1:53`: "outside automation" becomes "outside pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Format-Types.ps1:23`: "as wide as automation" becomes "as wide as pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1:20`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1:21`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1:20`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1:28`: depth comment to "below pwsh/". (check: grep clean; `Invoke-TestFile
      pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-SourceConventions.ps1:117`: depth comment to "below pwsh/". (check: grep clean;
      `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/Test-TestTitles.ps1:12`: depth comment to "below pwsh/". (check: grep clean; `Invoke-TestFile
      pwsh/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1`)
- [ ] `pwsh/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1:18`: "fixtures under automation" to "under pwsh/". (check:
      grep clean; `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1`)
- [ ] `.gitignore:94` and its source `pwsh/Catzc.Base.Git/configs/gitignore.yml:82`: "the automation types system" becomes "the types
      system"; edit the yml, regenerate `.gitignore`. (check: grep clean on both; `Test-GeneratedFiles` clean)

### Tests that mock the old folder

- [ ] `pwsh/.internal/tests/Import-AllModules.Tests.ps1:63,189-195`: the context title and the `$automation` local become "modules folder"
      and `$modulesRoot`. (check: grep clean; the file passes under `Invoke-TestFile`)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1:213-230`: `$automation` and the `Automation` parameter key become
      `$modulesRoot` / `ModulesRoot`. (check: grep clean; the file passes)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1:3,5,9`: the mocked root `<repo>/automation` becomes
      `<repo>/pwsh`. (check: only `TestAutomation` names remain; the file passes)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1:18,27`: mocked and expected root to `pwsh`. (check: grep clean; the
      file passes)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1:48`: mocked root to `pwsh`. (check: grep clean; the file
      passes)
- [ ] `pwsh/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1:5`: fake repo path to `repo/pwsh`. (check: grep clean; the file
      passes)
- [ ] `pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1:57`: test title "under automation" to "under pwsh/". (check:
      grep clean; the file passes)
- [ ] `pwsh/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1:5`: depth comment to "below pwsh/". (check: grep clean;
      the file passes)
- [ ] `pwsh/Catzc.Tooling.Core/tests/Get-EngineCaseTable.Tests.ps1:58`: depth comment to "below pwsh/". (check: grep clean; the file
      passes)

### The generator that prints the old folder into 421 pages

- [ ] `.claude/drawio/minimaps/describe.py:414`: "under `automation/` by module" becomes "under `pwsh/` by module"; rerun `render.py` per
      STYLE.md so every `docs/explanation/.assets/tree/*.tree.md` is rewritten from it. (check: `git grep -c "under \`automation/\`" --
      docs/explanation/.assets` is empty; `Test-GeneratedFiles` clean)

### Comment pages: the source of the help text

Each page below is edited by hand where it means the folder (`<RepositoryRoot>/automation`, `automation/<Module>/...`, "under
automation/"), never where it means the layer or the ADR domain. Check for each: grep clean, `Test-Comments` and `Test-Links` clean on the
page.

- [ ] `docs/references/pwsh/catzc-base-config/Get-Config.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-docs/tests/Build-Readme.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-docs/tests/Get-ReadmeMappings.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-files/Get-GitTrackedPath.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md` (check: grep clean; Test-Comments and Test-Links clean) (also "the automation itself", rename plan line 1033)
- [ ] `docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-globs/configs/globs.yml.md` (check: grep clean; Test-Comments and Test-Links clean) (the globset key `automation` stays until P6; only the folder wording
      changes)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/private/Get-UncoveredInternalAssetDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Format-Types.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Invoke-TestFile.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Test-Change.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/Test-SourceConventions.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-ChangeTestFile.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestFileModule.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunContext.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-repository/Get-CatzcModulesRoot.ps1.md` (check: grep clean; Test-Comments and Test-Links clean) (synopsis "root of the catzc automation tree" and the
      description's `<RepositoryRoot>/automation`)
- [ ] `docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/index.md` (check: grep clean; Test-Comments and Test-Links clean) (the "engine-agnostic `automation/` rules" sentence means the ADR domain and stays)
- [ ] `docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/internal/Catzc.Internal.TestKit.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/internal/Catzc.Internal.Types.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/internal/catzc-internal-testkit.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/internal/tests/Import-CSharpTypes.Tests.ps1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/scriptanalyzer/NoScriptRootAnchor.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)
- [ ] `docs/references/pwsh/scriptanalyzer/ParameterDesign.psm1.md` (check: grep clean; Test-Comments and Test-Links clean)

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

Each page: reword `automation/` to `pwsh/` where the modules folder is meant; leave links into `docs/adr/automation/`, the how-to
folders and the layer wording alone. Check for each: grep shows no folder-meaning line, `Test-Links` clean on the page. A `.drawio.md`
page changes its prose only, never the generated sidebar.

- [ ] `docs/adr/azure/caf/platform-automation-and-devops.md` (check: no folder-meaning line; Test-Links clean) (line 326)
- [ ] `docs/adr/azure/waf/operational-excellence.md` (check: no folder-meaning line; Test-Links clean) (line 522)
- [ ] `docs/adr/configuration/module-config-loading.md` (check: no folder-meaning line; Test-Links clean) (lines 82, 114)
- [ ] `docs/adr/flow/durable-sha-globs.md` (check: no folder-meaning line; Test-Links clean) (the glob table at 171 to 174 uses `automation/` as sample paths: switch them to `pwsh/`; line
      281)
- [ ] `docs/adr/flow/pipeline-runner-pattern.md` (check: no folder-meaning line; Test-Links clean) (line 35)
- [ ] `docs/adr/flow/pipeline-types.md` (check: no folder-meaning line; Test-Links clean) (lines 14, 180)
- [ ] `docs/adr/pwsh/bounded-enumeration.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/dynamic-module-manifests.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/index.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/one-function-per-file.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/pester-testing.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/prepost-extension-modules.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/pwsh-engine.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/pwsh/working-directory-mechanics.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/repository/generated-readmes.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/repository/generated-root-configs.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/adr/repository/protected-globs.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/configuration/callers-depend-on-one-config-module.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/configuration/three-caches-back-one-reader.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/a-push-fires-only-touched-pipelines.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/get-aspect-feeds-globs-and-maps.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/manifest-and-aspects-from-one-folder.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/manifest-and-aspects-from-one-folder.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/one-folder-two-independent-readers.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/one-folder-two-independent-readers.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/only-automation-compiles-its-aspects.md` (check: no folder-meaning line; Test-Links clean) (the title means the track: the page's file name is the user's
      call, the prose changes)
- [ ] `docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/partition-integrity-runs-only-in-unit-tests.drawio.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/two-roots-one-importer-same-modules.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/design/which-run-mode-rules-have-a-gate.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/flow/ci-budget-is-the-only-quality-gate.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/flow/the-runner-is-the-only-seam.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/flow/two-declared-layers-one-derived.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/repository/one-registry-one-writer-two-primitives.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/explanation/repository/one-source-one-writer-one-boolean.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/how-to/getting-started/pwsh/BCL/add-a-dotnet-type.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/how-to/getting-started/pwsh/BCL/index.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/how-to/getting-started/pwsh/add-a-module.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/how-to/getting-started/pwsh/powershell/add-a-function.md` (check: no folder-meaning line; Test-Links clean)
- [ ] `docs/how-to/getting-started/pwsh/powershell/index.md` (check: no folder-meaning line; Test-Links clean)

### Plans that still say P4 waits or name removed functions

- [ ] `plan-clear` over `plan-layers-vocabulary-rename-contracts.md`: about 40 lines name `Get-AutomationModules`, `Copy-Automation`,
      `-AutomationRoot` or P2 and P4 work as present or pending, line 58 names a prompt file that is gone, and three link labels name the
      absorbed `plan-automation-layers-rename.md`. (check: `Test-Plans` clean on the file)
- [ ] `plan-clear` over `decisions-2026-10-18.md` (line 24 says P4 waits), `task-layers-classification-flip.md` (lines 13, 38),
      `questionnaire-2026-10-18.md` (lines 23, 37), `plan-module-model-closeout.md` (lines 28, 34, 35),
      `task-module-model-closeout.md` (lines 48, 49), `value-of-plan.md` (line 33). (check: `Test-Plans` clean on each)

### Close

- [ ] The residue scan is empty. (check: `git grep -n -i -E "\\\$automation\b|AutomationRoot|automationRoot|<RepositoryRoot>/automation|
      under automation/" -- pwsh docs .claude/drawio` prints nothing; the final full `Test-Automation` of task-user-runs-and-commits is the
      tree-wide proof)

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
- plan-layers-vocabulary-rename-contracts and task-layers-classification-flip steps 6 (P5 guards) and 7 (P6 pipeline names): the
  globset key `automation`, `ci-automation*`, `build-validation.yml`, the README badge, the avoid phrasings and tracks.md line 53 land
  there, not here.
- ADR-AUTO-LAYERS (the layer doctrine), ADR-PRIN-ONELIVE (no residue of the old shape), ADR-REPO-PLANS (this file's shape).
