---
catzc:
  edges:
    cites:
      - ADR-AUTO-BUNDLE-TWOROOTS
      - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
      - ADR-AUTO-BUNDLE-BUNDLEISSESSION
      - ADR-BCL-TYPES-JANITORSBYCALLER
      - ADR-PWSH-ERROR-STOPONERROR
      - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
      - ADR-REPO-ROOTCFG-FULLYMANAGED
      - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - DDR-RUNMODE-TWORUNMODES
      - DDR-RUNMODE-NEVERCOEXIST
      - PDR-ONELIVE-ONEVERSION
---

# Every load stage but the unload has an ADR rule and a gate

```text
Every load stage but the unload has an ADR rule and a gate.

1  Shim                    generated importer.ps1; gate New-Importer.Tests
2  Session                 preferences and two roots; gate code review
3  Load                    types before modules; gate Import-AllModules.Tests
4  Run mode                run modes never coexist; gate Assert-CatzcRunModeExclusive.Tests
5  Janitors                idempotent, actor-aware; gate Invoke-TypeCacheJanitor.Tests
6  Unload                  the import-time helpers removed; no rule and no gate

Supports ADR-AUTO-BUNDLE-TWOROOTS, ADR-AUTO-BUNDLE-ONELIVINGIMPORTER, ADR-AUTO-BUNDLE-BUNDLEISSESSION, ADR-PWSH-ERROR-STOPONERROR, PDR-ONELIVE-ONEVERSION, ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, DDR-RUNMODE-NEVERCOEXIST and ADR-BCL-TYPES-JANITORSBYCALLER (governance lens).
```

The cats load sequence runs in six stages, from the generated shim to the final unload of the import-time helpers. Each stage but the last
is constrained by at least one ADR rule, and each of those stages is checked by a gate: a test for four of them, and code review for the
session set-up. The unload has neither a rule nor a gate.

```yml drawio
description:
  The cats load runs in six stages; each stage but the last carries the ADR rules it follows and the test or review that gates them, and the
  unload carries neither.
about:
  adrs:
    - ADR-AUTO-BUNDLE-TWOROOTS
    - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
    - ADR-AUTO-BUNDLE-BUNDLEISSESSION
    - ADR-PWSH-ERROR-STOPONERROR
    - PDR-ONELIVE-ONEVERSION
    - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
    - ADR-REPO-ROOTCFG-FULLYMANAGED
    - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
    - DDR-RUNMODE-NEVERCOEXIST
    - ADR-BCL-TYPES-JANITORSBYCALLER
  lens: governance
content:
  title: Every load stage but the unload has an ADR rule and a gate
  kind: explanation
  flow: top-to-bottom
  relation: is checked by
  theme: dark
  bands:
    - { id: band-shim, label: SHIM }
    - { id: band-session, label: SESSION }
    - { id: band-load, label: LOAD }
    - { id: band-mode, label: RUN MODE }
    - { id: band-janitors, label: JANITORS }
    - { id: band-unload, label: UNLOAD }
  glyphs:
    - { id: g-shim, kind: gate, label: New-Importer.Tests, in: band-shim }
    - { id: g-session, kind: gate, label: code review, in: band-session }
    - { id: g-load, kind: gate, label: Import-AllModules.Tests, in: band-load }
    - { id: g-mode, kind: gate, label: Assert-CatzcRunModeExclusive.Tests, in: band-mode }
    - { id: g-janitors, kind: gate, label: Invoke-TypeCacheJanitor.Tests, in: band-janitors }
  markers:
    - { at: g-shim, number: 1 }
    - { at: g-session, number: 2 }
    - { at: g-load, number: 3 }
    - { at: g-mode, number: 4 }
    - { at: g-janitors, number: 5 }
    - { at: band-unload, number: 6 }
  chips:
    - { at: g-shim, kind: rule, rule: ADR-REPO-ROOTCFG-FULLYMANAGED }
    - { at: g-shim, kind: rule, rule: PDR-ONELIVE-ONEVERSION }
    - { at: g-session, kind: rule, rule: ADR-PWSH-ERROR-STOPONERROR }
    - { at: g-session, kind: rule, rule: ADR-AUTO-BUNDLE-TWOROOTS }
    - { at: g-session, kind: rule, rule: ADR-AUTO-BUNDLE-BUNDLEISSESSION }
    - { at: g-load, kind: rule, rule: ADR-AUTO-BUNDLE-ONELIVINGIMPORTER }
    - { at: g-load, kind: rule, rule: ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE }
    - { at: g-mode, kind: rule, rule: DDR-RUNMODE-NEVERCOEXIST }
    - { at: g-janitors, kind: rule, rule: ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION }
    - { at: g-janitors, kind: rule, rule: ADR-BCL-TYPES-JANITORSBYCALLER }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, PDR-ONELIVE-ONEVERSION]
      - cell: docs/-/.
        by:
          - docs/drs/automation/BCL/dora-explains.md
          - docs/drs/automation/BCL/native-csharp-types.md
          - docs/drs/automation/dora-explains.md
          - docs/drs/automation/platform-bundle.md
          - docs/drs/automation/pwsh/dora-explains.md
          - docs/drs/automation/pwsh/error-handling.md
          - docs/drs/automation/pwsh/hosting-csharp-types.md
          - docs/drs/design/dora-explains.md
          - docs/drs/design/run-modes.md
          - docs/drs/index.md
          - docs/drs/principles/dora-explains.md
          - docs/drs/principles/one-living-version.md
          - docs/drs/repository/dora-explains.md
          - docs/drs/repository/generated-root-configs.md
          - docs/references/agent-contracts.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-base-code-meta/types/CommentPageMap.cs.md
          - docs/references/pwsh/catzc-base-drs/Get-DrsCitationMap.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCitationMap.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsRuleSet.cs.md
          - docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md
          - docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
          - docs/references/pwsh/catzc-base-files/Get-CodeCaller.ps1.md
          - docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
          - docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md
          - docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
          - docs/references/pwsh/catzc-base-git/New-GitIgnore.ps1.md
          - docs/references/pwsh/catzc-base-git/configs/gitignore.yml.md
          - docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
          - docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-module-system/Copy-CatzcModule.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-InternalAssetDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-ModuleFunction.ps1.md
          - docs/references/pwsh/catzc-base-module-system/New-Importer.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Sync-GeneratedFile.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Build-CommentView.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Export-Comments.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Get-DrsUsage.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Comments.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/comments.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentExemptPath.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Build-CommentView.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Export-Comments.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Comments.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/CommentsConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/tests/types/CheckModes.Tests.ps1.md
          - docs/references/pwsh/catzc-base-reports/types/CheckModes.cs.md
          - docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-SessionActor.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md
          - docs/references/pwsh/catzc-base-root-config/New-GitAttributes.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootAnalyzerSettings.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootConfigFiles.ps1.md
          - docs/references/pwsh/catzc-base-root-config/configs/rootconfig.yml.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigRenderedFile.ps1.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigTargets.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigIntegrity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/types/RootConfigFiles.cs.md
          - docs/references/pwsh/catzc-base-types-system/Clear-ModuleTypeCache.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Get-CSharpTypeDependency.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Invoke-BuildForVsCode.ps1.md
          - docs/references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md
          - docs/references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeExtensions.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeLaunch.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodePipelineSchema.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeSettings.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeTasks.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-extensions.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-launch.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-pipeline-schema.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-settings.yml.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeExtensionsConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeLaunchConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodePipelineSchemaConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeSettingsConfig.cs.md
          - docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
          - docs/references/pwsh/internal/assets/Import-Catzc.ps1.md
          - docs/references/pwsh/internal/catzc-internal-importer.md
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.CodeMeta/types
        by: [pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.Docs/configs
        by: [pwsh/Catzc.Base.Docs/configs/agents.yml, pwsh/Catzc.Base.Docs/configs/capabilities.yml, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.Drs/.
        by: [pwsh/Catzc.Base.Drs/Get-DrsCitationMap.ps1, ADR-PWSH-ERROR-STOPONERROR]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.Drs/types
        by:
          - pwsh/Catzc.Base.Drs/types/DrsCitationMap.cs
          - pwsh/Catzc.Base.Drs/types/DrsRuleSet.cs
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
      - cell: pwsh/Catzc.Base.Exporter/configs
        by:
          - pwsh/Catzc.Base.Exporter/configs/exporter.yml
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
      - cell: pwsh/Catzc.Base.Exporter/private
        by:
          - pwsh/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
      - cell: pwsh/Catzc.Base.Exporter/types
        by:
          - pwsh/Catzc.Base.Exporter/types/ExporterBundle.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterConfig.cs
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
      - cell: pwsh/Catzc.Base.Files/.
        by:
          - pwsh/Catzc.Base.Files/Get-CodeCaller.ps1
          - pwsh/Catzc.Base.Files/Get-InputStamp.ps1
          - pwsh/Catzc.Base.Files/Rename-CodeName.ps1
          - pwsh/Catzc.Base.Files/Write-FileIfChanged.ps1
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.Git/.
        by: [pwsh/Catzc.Base.Git/New-GitIgnore.ps1, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.Git/configs
        by: [pwsh/Catzc.Base.Git/configs/gitignore.yml, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.Git/types
        by: [pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.Globs/.
        by: [pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1, DDR-RUNMODE-NEVERCOEXIST]
      - cell: pwsh/Catzc.Base.Languages/.
        by: [pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Base.ModuleSystem/.
        by:
          - pwsh/Catzc.Base.ModuleSystem/Copy-CatzcModule.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-ModuleFunction.ps1
          - pwsh/Catzc.Base.ModuleSystem/New-Importer.ps1
          - pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - DDR-RUNMODE-NEVERCOEXIST
      - cell: pwsh/Catzc.Base.ModuleSystem/tests
        by: [pwsh/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1, ADR-BCL-TYPES-JANITORSBYCALLER]
      - cell: pwsh/Catzc.Base.QualityGates/.
        by:
          - pwsh/Catzc.Base.QualityGates/Build-CommentView.ps1
          - pwsh/Catzc.Base.QualityGates/Export-Comments.ps1
          - pwsh/Catzc.Base.QualityGates/Get-DrsUsage.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Comments.ps1
          - ADR-PWSH-ERROR-STOPONERROR
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/comments.yml, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1, ADR-REPO-ROOTCFG-FULLYMANAGED]
      - cell: pwsh/Catzc.Base.QualityGates/tests
        by:
          - pwsh/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.QualityGates/tests/types
        by: [pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.QualityGates/types
        by:
          - pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/Catzc.Base.Reports/tests/types
        by: [pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.Reports/types
        by: [pwsh/Catzc.Base.Reports/types/CheckModes.cs, PDR-ONELIVE-ONEVERSION]
      - cell: pwsh/Catzc.Base.Repository/.
        by:
          - pwsh/Catzc.Base.Repository/Assert-SourceTree.ps1
          - pwsh/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
          - pwsh/Catzc.Base.Repository/Get-SessionActor.ps1
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - DDR-RUNMODE-NEVERCOEXIST
      - cell: pwsh/Catzc.Base.Repository/tests
        by: [pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1, ADR-BCL-TYPES-JANITORSBYCALLER]
      - cell: pwsh/Catzc.Base.RootConfig/.
        by:
          - pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
          - pwsh/Catzc.Base.RootConfig/New-GitAttributes.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
      - cell: pwsh/Catzc.Base.RootConfig/configs
        by: [pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.RootConfig/private
        by:
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Base.RootConfig/tests
        by:
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Base.RootConfig/types
        by: [pwsh/Catzc.Base.RootConfig/types/RootConfigFiles.cs, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
      - cell: pwsh/Catzc.Base.TypesSystem/.
        by:
          - pwsh/Catzc.Base.TypesSystem/Build-AgentHook.ps1
          - pwsh/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
          - pwsh/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
          - pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - DDR-RUNMODE-NEVERCOEXIST
      - cell: pwsh/Catzc.Base.Vendor/.
        by: [pwsh/Catzc.Base.Vendor/Install-VendorModule.ps1, pwsh/Catzc.Base.Vendor/Remove-VendorModules.ps1, DDR-RUNMODE-NEVERCOEXIST]
      - cell: pwsh/Catzc.Base.VSCode/.
        by:
          - pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Base.VSCode/configs
        by:
          - pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-launch.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Base.VSCode/types
        by:
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
      - cell: pwsh/Catzc.Internal.Assets/.
        by:
          - pwsh/.internal/assets/Import-Catzc.ps1
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - DDR-RUNMODE-NEVERCOEXIST
    grid:
      - cell: .claude/markdown
        by: [.claude/CLAUDE.md, PDR-ONELIVE-ONEVERSION]
      - cell: docs/markdown
        by:
          - docs/drs/automation/BCL/dora-explains.md
          - docs/drs/automation/BCL/native-csharp-types.md
          - docs/drs/automation/dora-explains.md
          - docs/drs/automation/platform-bundle.md
          - docs/drs/automation/pwsh/dora-explains.md
          - docs/drs/automation/pwsh/error-handling.md
          - docs/drs/automation/pwsh/hosting-csharp-types.md
          - docs/drs/design/dora-explains.md
          - docs/drs/design/run-modes.md
          - docs/drs/index.md
          - docs/drs/principles/dora-explains.md
          - docs/drs/principles/one-living-version.md
          - docs/drs/repository/dora-explains.md
          - docs/drs/repository/generated-root-configs.md
          - docs/references/agent-contracts.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-base-code-meta/types/CommentPageMap.cs.md
          - docs/references/pwsh/catzc-base-drs/Get-DrsCitationMap.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCitationMap.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsRuleSet.cs.md
          - docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md
          - docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
          - docs/references/pwsh/catzc-base-files/Get-CodeCaller.ps1.md
          - docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
          - docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md
          - docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
          - docs/references/pwsh/catzc-base-git/New-GitIgnore.ps1.md
          - docs/references/pwsh/catzc-base-git/configs/gitignore.yml.md
          - docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
          - docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-module-system/Copy-CatzcModule.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-InternalAssetDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Get-ModuleFunction.ps1.md
          - docs/references/pwsh/catzc-base-module-system/New-Importer.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Sync-GeneratedFile.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Build-CommentView.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Export-Comments.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Get-DrsUsage.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Comments.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/comments.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentExemptPath.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Build-CommentView.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Export-Comments.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Comments.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/CommentsConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/tests/types/CheckModes.Tests.ps1.md
          - docs/references/pwsh/catzc-base-reports/types/CheckModes.cs.md
          - docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-SessionActor.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md
          - docs/references/pwsh/catzc-base-root-config/New-GitAttributes.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootAnalyzerSettings.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootConfigFiles.ps1.md
          - docs/references/pwsh/catzc-base-root-config/configs/rootconfig.yml.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigRenderedFile.ps1.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigTargets.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigIntegrity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/types/RootConfigFiles.cs.md
          - docs/references/pwsh/catzc-base-types-system/Clear-ModuleTypeCache.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Get-CSharpTypeDependency.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Invoke-BuildForVsCode.ps1.md
          - docs/references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md
          - docs/references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeExtensions.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeLaunch.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodePipelineSchema.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeSettings.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/New-VsCodeTasks.ps1.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-extensions.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-launch.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-pipeline-schema.yml.md
          - docs/references/pwsh/catzc-base-vs-code/configs/vscode-settings.yml.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeExtensionsConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeLaunchConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodePipelineSchemaConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeSettingsConfig.cs.md
          - docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md
          - docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
          - docs/references/pwsh/internal/assets/Import-Catzc.ps1.md
          - docs/references/pwsh/internal/catzc-internal-importer.md
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/bcl
        by:
          - pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationMap.cs
          - pwsh/Catzc.Base.Drs/types/DrsRuleSet.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterBundle.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterConfig.cs
          - pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - pwsh/Catzc.Base.Reports/types/CheckModes.cs
          - pwsh/Catzc.Base.RootConfig/types/RootConfigFiles.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/powershell
        by:
          - pwsh/.internal/assets/Import-Catzc.ps1
          - pwsh/Catzc.Base.Drs/Get-DrsCitationMap.ps1
          - pwsh/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
          - pwsh/Catzc.Base.Files/Get-CodeCaller.ps1
          - pwsh/Catzc.Base.Files/Get-InputStamp.ps1
          - pwsh/Catzc.Base.Files/Rename-CodeName.ps1
          - pwsh/Catzc.Base.Files/Write-FileIfChanged.ps1
          - pwsh/Catzc.Base.Git/New-GitIgnore.ps1
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - pwsh/Catzc.Base.ModuleSystem/Copy-CatzcModule.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Get-ModuleFunction.ps1
          - pwsh/Catzc.Base.ModuleSystem/New-Importer.ps1
          - pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/Build-CommentView.ps1
          - pwsh/Catzc.Base.QualityGates/Export-Comments.ps1
          - pwsh/Catzc.Base.QualityGates/Get-DrsUsage.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Comments.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
          - pwsh/Catzc.Base.Repository/Assert-SourceTree.ps1
          - pwsh/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
          - pwsh/Catzc.Base.Repository/Get-SessionActor.ps1
          - pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
          - pwsh/Catzc.Base.RootConfig/New-GitAttributes.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/Build-AgentHook.ps1
          - pwsh/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
          - pwsh/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
          - pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
          - pwsh/Catzc.Base.Vendor/Install-VendorModule.ps1
          - pwsh/Catzc.Base.Vendor/Remove-VendorModules.ps1
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
          - PDR-ONELIVE-ONEVERSION
      - cell: pwsh/yaml
        by:
          - pwsh/Catzc.Base.Docs/configs/agents.yml
          - pwsh/Catzc.Base.Docs/configs/capabilities.yml
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Exporter/configs/exporter.yml
          - pwsh/Catzc.Base.Git/configs/gitignore.yml
          - pwsh/Catzc.Base.QualityGates/configs/comments.yml
          - pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-launch.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-ERROR-STOPONERROR
          - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - DDR-RUNMODE-NEVERCOEXIST
          - PDR-ONELIVE-ONEVERSION
      - cell: (no track)/powershell
        by:
          - importer.ps1
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - DDR-RUNMODE-NEVERCOEXIST
      - cell: (no track)/(other)
        by: [.gitattributes, .gitignore, ADR-BCL-TYPES-JANITORSBYCALLER, DDR-RUNMODE-NEVERCOEXIST]
    axis:
      - cell: DSGN/build
        by: [DDR-RUNMODE-NEVERCOEXIST]
      - cell: DSGN/release
        by: [PDR-ONELIVE-ONEVERSION]
      - cell: AUTO/build
        by:
          - ADR-AUTO-BUNDLE-BUNDLEISSESSION
          - ADR-AUTO-BUNDLE-ONELIVINGIMPORTER
          - ADR-AUTO-BUNDLE-TWOROOTS
          - ADR-BCL-TYPES-JANITORSBYCALLER
          - ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE
      - cell: AUTO/release
        by: [ADR-AUTO-BUNDLE-BUNDLEISSESSION, ADR-AUTO-BUNDLE-ONELIVINGIMPORTER, ADR-AUTO-BUNDLE-TWOROOTS]
      - cell: AUTO/*
        by: [ADR-PWSH-ERROR-STOPONERROR, ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION]
layout:
  band-shim: { x: 20, y: 124, w: 1260, h: 70 }
  band-session: { x: 20, y: 204, w: 1260, h: 70 }
  band-load: { x: 20, y: 284, w: 1260, h: 70 }
  band-mode: { x: 20, y: 364, w: 1260, h: 70 }
  band-janitors: { x: 20, y: 444, w: 1260, h: 70 }
  band-unload: { x: 20, y: 524, w: 1260, h: 70 }
  g-shim: { x: 600, y: 136, w: 400, h: 48 }
  g-session: { x: 600, y: 216, w: 400, h: 48 }
  g-load: { x: 600, y: 296, w: 400, h: 48 }
  g-mode: { x: 600, y: 376, w: 400, h: 48 }
  g-janitors: { x: 600, y: 456, w: 400, h: 48 }
```

![Every load stage but the unload has an ADR rule](.assets/rule-and-gate-per-load-stage.drawio.png)

Each stage has its own band, and a stage's gate sits in its band beside the rules it checks.

## Walkthrough

1. **Shim.** `importer.ps1` is fully managed: `New-Importer` renders it from one source of truth, and it carries no load logic of its own
   (ADR-REPO-ROOTCFG-FULLYMANAGED, PDR-ONELIVE-ONEVERSION). `New-Importer.Tests` checks that the shim's parameter set equals
   `Invoke-Importer`'s and that the committed file equals the generated one.
2. **Session.** The importer sets `$ErrorActionPreference = 'Stop'` globally (ADR-PWSH-ERROR-STOPONERROR), anchors on the working root and
   the code root (ADR-AUTO-BUNDLE-TWOROOTS), and a bundle sets up the same session as source mode does (ADR-AUTO-BUNDLE-BUNDLEISSESSION).
   The gate is code review, the gate the platform-bundle ADR names: it rejects a scan of catzc's own code anchored on `RepositoryRoot`. No
   test checks the preferences.
3. **Load.** The bundle reuses the one importer so that the C# types and their accelerators register before any module loads
   (ADR-AUTO-BUNDLE-ONELIVINGIMPORTER, ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE). `Import-AllModules.Tests` checks that a duplicated or
   shadowing function name fails the import, and `Import-CSharpTypes.Tests` and the walking-skeleton `Import-Catzc.Tests` also cover this
   stage.
4. **Run mode.** The two run modes never coexist (DDR-RUNMODE-NEVERCOEXIST). The stage is itself a check: `Assert-CatzcRunModeExclusive`
   runs on every load and throws when a module from the other run mode's root is still loaded. `Assert-CatzcRunModeExclusive.Tests` checks
   it, and the eviction block of `Import-AllModules.Tests` checks the removal that comes before it.
5. **Janitors.** Generation is idempotent and runs on every import (ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION), and who runs the importer
   decides what the janitors may change, read from `Get-SessionActor` (ADR-BCL-TYPES-JANITORSBYCALLER). `Invoke-TypeCacheJanitor.Tests`
   checks that holders are never stopped in a `Pipeline` or `Agent` session.
6. **Unload.** `Invoke-Importer` removes `Catzc.Internal.Bootstrap`, and the entry script's `finally` removes `Catzc.Internal.Importer`. No
   ADR rule states this, and no test checks it; only the code comments and the project instructions describe it. That is why its band holds
   no rule and no gate.

Beyond the gate at each stage, `Test-Automation` and `Test-CatzcBuild` run the same tests in both modes, `Assert-CatzcBundle` checks every
build, and code review rejects a bundle loader that forks the importer.

## Why it holds

- An opted-in root file is materialised from exactly one source of truth (ADR-REPO-ROOTCFG-FULLYMANAGED), and the code holds one living
  version of every behaviour (PDR-ONELIVE-ONEVERSION).
- The error preference is `Stop`, set globally by the importer (ADR-PWSH-ERROR-STOPONERROR). Cats anchors on two roots
  (ADR-AUTO-BUNDLE-TWOROOTS), and a bundle is a session, not a passive library (ADR-AUTO-BUNDLE-BUNDLEISSESSION).
- A bundle loads through the one living importer, so types and accelerators register before any module (ADR-AUTO-BUNDLE-ONELIVINGIMPORTER,
  ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE).
- The two run modes never coexist in one session (DDR-RUNMODE-NEVERCOEXIST).
- Root-config generation is idempotent and runs on every import (ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION), and the session actor decides what
  the janitors may change (ADR-BCL-TYPES-JANITORSBYCALLER).
- The run modes have two entry points (DDR-RUNMODE-TWORUNMODES).

## Where the code and the decision record differ

- No ADR rule covers removing the Bootstrap and the importer after the load, although the code does it on every load.

## See also

- [Platform bundle](../../drs/automation/platform-bundle.md) — the decision this article explains. The stages also rest on
  [error-handling](../../drs/automation/pwsh/error-handling.md), [native-csharp-types](../../drs/automation/BCL/native-csharp-types.md),
  [hosting-csharp-types](../../drs/automation/pwsh/hosting-csharp-types.md), [run-modes](../../drs/design/run-modes.md),
  [one-living-version](../../drs/principles/one-living-version.md) and
  [generated-root-configs](../../drs/repository/generated-root-configs.md).
- The other lenses on the same load sequence: [meta](every-entry-runs-one-load-sequence.md),
  [architecture](two-entries-feed-one-importer.md), [implementation](invoke-importer-in-code-order.md) and
  [operations](dot-source-one-entry-script.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
