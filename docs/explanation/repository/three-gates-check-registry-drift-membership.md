# Three gates check the registry, the drift and the git membership; one rule has no gate

```text
Three gates check the registry, the drift and the git membership; one clause of the ADR has no gate.

1  rootconfig.yml               the registry: rules #1 and #2 govern its entries; "not restated elsewhere" has no gate
2  RootConfigFiles              the load-time gate: exactly one source (#1), a wildcard target only with a generator (#8)
3  Build-RootConfig             the single writer that keeps only opted-in entries (#2), runs on every import (#4) and writes the head (#5)
4  Get-RootConfigCopyContent    the headed copy: the template under the generated-file head, never a link (#7)
5  Write-FileIfChanged          the content primitive: canonical, EOL-insensitive, delete-then-write (#4)
6  managed root files           the targets; committed decides their git membership (#3)
7  Test-GeneratedFiles          the drift gate (#6): every target equals what the writer composes now
8  Test-RootConfigFiles         the integrity gate: git membership (#3), registry = .gitignore = index, copies equal templates, no link (#6, #7)

Supports ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-REGISTRY, ADR-REPO-ROOTCFG-COMMITTEDFLAG, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, ADR-REPO-ROOTCFG-COMPOSEDROOTFILE, ADR-REPO-ROOTCFG-THREEWAYAGREEMENT, ADR-REPO-ROOTCFG-HEADEDCOPY and ADR-REPO-ROOTCFG-WILDCARDGENERATOR (governance lens).
```

The eight rules of the generated-root-configs decision are enforced at three points. A malformed registry stops the config load; a target
that differs from what the writer would compose fails the drift check; and a target whose git membership, ignore rule, copy or link status
disagrees with the registry fails the integrity check. One clause stands on the ADR alone: that the target-to-source pairing is restated
nowhere else.

```yml drawio
description:
  "Which rules of the generated-root-configs decision a gate checks: the load-time type gate, the drift gate and the integrity gate, with
  the one clause no gate checks drawn dashed."
about:
  adrs:
    - ADR-REPO-ROOTCFG-FULLYMANAGED
    - ADR-REPO-ROOTCFG-REGISTRY
    - ADR-REPO-ROOTCFG-COMMITTEDFLAG
    - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
    - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
    - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
    - ADR-REPO-ROOTCFG-HEADEDCOPY
    - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
  lens: governance
content:
  title: Three gates check the registry, the drift and the git membership; one rule has no gate
  kind: explanation
  flow: left-to-right
  relation: feeds the next step
  theme: dark
  bands:
    - { id: band-source, label: SOURCE OF TRUTH }
    - { id: band-materialise, label: MATERIALISE }
    - { id: band-target, label: TARGET }
  groups:
    - { id: grp-gates, label: gates, in: band-target }
  glyphs:
    - { id: g-registry, kind: file, label: rootconfig.yml, in: band-source }
    - { id: g-type, kind: gate, label: RootConfigFiles, in: band-materialise }
    - { id: g-build, kind: code, label: Build-RootConfig, in: band-materialise }
    - { id: g-copy-content, kind: private, label: Get-RootConfigCopyContent, in: band-materialise }
    - { id: g-write, kind: code, label: Write-FileIfChanged, in: band-materialise }
    - { id: r-managed, kind: result, label: managed root files, in: band-target }
    - { id: g-generated-files, kind: gate, label: Test-GeneratedFiles, in: grp-gates }
    - { id: g-root-config-files, kind: gate, label: Test-RootConfigFiles, in: grp-gates }
  edges:
    - { from: g-registry, to: g-type, kind: flow, label: "" }
    - { from: g-type, to: g-build, kind: flow, label: "" }
    - { from: g-build, to: g-copy-content, kind: flow, label: "" }
    - { from: g-build, to: g-write, kind: flow, label: "" }
    - { from: g-write, to: r-managed, kind: flow, label: "" }
    - { from: r-managed, to: grp-gates, kind: flow, label: "" }
  markers:
    - { at: g-registry, number: 1 }
    - { at: g-type, number: 2 }
    - { at: g-build, number: 3 }
    - { at: g-copy-content, number: 4 }
    - { at: g-write, number: 5 }
    - { at: r-managed, number: 6 }
    - { at: g-generated-files, number: 7 }
    - { at: g-root-config-files, number: 8 }
  chips:
    - { at: g-registry, kind: rule, rule: ADR-REPO-ROOTCFG-FULLYMANAGED }
    - { at: g-registry, kind: rule, rule: ADR-REPO-ROOTCFG-REGISTRY, gated: false, corner: bottom-right }
    - { at: g-type, kind: rule, rule: ADR-REPO-ROOTCFG-FULLYMANAGED }
    - { at: g-type, kind: rule, rule: ADR-REPO-ROOTCFG-WILDCARDGENERATOR, corner: bottom-right }
    - { at: g-build, kind: rule, rule: ADR-REPO-ROOTCFG-REGISTRY, corner: top-left }
    - { at: g-build, kind: rule, rule: ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, corner: bottom-right }
    - { at: g-build, kind: rule, rule: ADR-REPO-ROOTCFG-COMPOSEDROOTFILE, corner: bottom-left }
    - { at: g-copy-content, kind: rule, rule: ADR-REPO-ROOTCFG-HEADEDCOPY, corner: bottom-right }
    - { at: g-write, kind: rule, rule: ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, corner: bottom-right }
    - { at: r-managed, kind: rule, rule: ADR-REPO-ROOTCFG-COMMITTEDFLAG, corner: bottom-right }
    - { at: g-generated-files, kind: rule, rule: ADR-REPO-ROOTCFG-THREEWAYAGREEMENT }
    - { at: g-root-config-files, kind: rule, rule: ADR-REPO-ROOTCFG-COMMITTEDFLAG }
    - { at: g-root-config-files, kind: rule, rule: ADR-REPO-ROOTCFG-THREEWAYAGREEMENT, corner: bottom-right }
    - { at: g-root-config-files, kind: rule, rule: ADR-REPO-ROOTCFG-HEADEDCOPY, corner: bottom-left }
  legend: auto
  minimaps:
    code-locations:
      - cell: docs/-/.
        by:
          - docs/drs/index.md
          - docs/drs/repository/dora-explains.md
          - docs/drs/repository/generated-root-configs.md
          - docs/references/pwsh/catzc-base-git/New-GitIgnore.ps1.md
          - docs/references/pwsh/catzc-base-git/configs/gitignore.yml.md
          - docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
          - docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentExemptPath.ps1.md
          - docs/references/pwsh/catzc-base-root-config.md
          - docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md
          - docs/references/pwsh/catzc-base-root-config/New-GitAttributes.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootAnalyzerSettings.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootConfigFiles.ps1.md
          - docs/references/pwsh/catzc-base-root-config/configs/rootconfig.yml.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigCopyContent.ps1.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigRenderedFile.ps1.md
          - docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigTargets.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigIntegrity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/types/RootConfigFiles.cs.md
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
          - docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Git/.
        by:
          - pwsh/Catzc.Base.Git/New-GitIgnore.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Git/configs
        by:
          - pwsh/Catzc.Base.Git/configs/gitignore.yml
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Git/types
        by:
          - pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Languages/.
        by:
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1, ADR-REPO-ROOTCFG-FULLYMANAGED]
      - cell: pwsh/Catzc.Base.RootConfig/.
        by:
          - pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
          - pwsh/Catzc.Base.RootConfig/New-GitAttributes.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.RootConfig/configs
        by:
          - pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.RootConfig/private
        by:
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigCopyContent.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.RootConfig/tests
        by:
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.RootConfig/types
        by:
          - pwsh/Catzc.Base.RootConfig/types/RootConfigFiles.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.VSCode/.
        by:
          - pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.VSCode/configs
        by:
          - pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-launch.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: pwsh/Catzc.Base.VSCode/types
        by:
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
    module-neighbourhood:
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: subject/Catzc.Base.Git
        by:
          - pwsh/Catzc.Base.Git/New-GitIgnore.ps1
          - pwsh/Catzc.Base.Git/configs/gitignore.yml
          - pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: subject/Catzc.Base.Languages
        by:
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: subject/Catzc.Base.QualityGates
        by: [pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1, ADR-REPO-ROOTCFG-FULLYMANAGED]
      - cell: subject/Catzc.Base.RootConfig
        by:
          - pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
          - pwsh/Catzc.Base.RootConfig/New-GitAttributes.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigCopyContent.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/types/RootConfigFiles.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
      - cell: subject/Catzc.Base.VSCode
        by:
          - pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
          - pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-launch.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
    axis:
      - cell: AUTO/*
        by:
          - ADR-REPO-ROOTCFG-COMMITTEDFLAG
          - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
          - ADR-REPO-ROOTCFG-FULLYMANAGED
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
          - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
          - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
layout:
  band-source: { x: 20, y: 124, w: 260, h: 340 }
  band-materialise: { x: 300, y: 124, w: 620, h: 340 }
  band-target: { x: 940, y: 124, w: 340, h: 340 }
  g-registry: { x: 60, y: 260, w: 180, h: 52 }
  g-type: { x: 330, y: 260, w: 180, h: 64 }
  g-build: { x: 570, y: 170, w: 140, h: 250 }
  g-copy-content: { x: 730, y: 190, w: 170, h: 44 }
  g-write: { x: 730, y: 330, w: 170, h: 44 }
  r-managed: { x: 970, y: 170, w: 280, h: 44 }
  grp-gates: { x: 960, y: 250, w: 300, h: 190 }
  g-generated-files: { x: 990, y: 280, w: 240, h: 56 }
  g-root-config-files: { x: 990, y: 370, w: 240, h: 56 }
```

![Three gates check the registry, the drift and the git membership; one rule has no gate](.assets/three-gates-check-registry-drift-membership.drawio.png)

## Walkthrough

1. **rootconfig.yml.** Each entry names one source of truth (#1), and the registry is the one place that pairs a target with its source,
   with opt-out as the default (#2). The pairing's uniqueness has no gate: `New-GitIgnore` and `New-VsCodeSettings` are fed the targets from
   the registry rather than a second list, but nothing asserts that no second list exists.
2. **RootConfigFiles.** Loading the `rootconfig` config constructs the type, which rejects an entry with both or neither of `source` and
   `generator` (#1), a wildcard target without a `generator` (#8), `sources` without a `generator`, and a duplicate target. It throws once,
   listing every error, before any write.
3. **Build-RootConfig.** The single writer touches only the entries `Get-RootConfigTargets` keeps, those with `optIn` true (#2), and the
   importer tail runs it on every load (#4). It writes the generated-file head over a generator's output (#5).
4. **Get-RootConfigCopyContent.** The copy branch for a `source` entry: the template read as LF under the generated-file head that names it,
   a headed copy and never a link, so the template stays the pure authored file (#7, #5).
5. **Write-FileIfChanged.** Every content write is canonical, compared without regard to line endings, and delete-then-write, so it can
   never tunnel into a source through a link (#4). `Build-RootConfig` also deletes a target that is still a link before it writes.
6. **Managed root files.** The `committed` boolean decides whether a target is a gitignored artifact or a tracked file, and nothing else
   (#3).
7. **Test-GeneratedFiles.** The drift check dry-runs the writer and reports every file whose content would change, one issue per file of a
   wildcard entry (#6, #8). It is a quality gate in the sense of ADR-AUTO-TEST-QUALITYGATE: one report, one throw listing every issue.
8. **Test-RootConfigFiles.** The integrity check asserts, per opted-in target, that `committed` agrees with `.gitignore` and the index (#3,
   #6), that no target is a link, and that every `source` target equals its template under the generated-file head (#6, #7). The L2
   integrity test runs it and expects zero issues. A third quality gate, `Test-RootAnalyzerSettings`, checks that the root analyzer settings
   file exists and parses.

## Why it holds

- Exactly one in-repo source of truth per opted-in root file; corrections go to the source (ADR-REPO-ROOTCFG-FULLYMANAGED).
- One registry, validated by `RootConfigFiles` and written by `Build-RootConfig`; opt-out is the default (ADR-REPO-ROOTCFG-REGISTRY).
- `committed` decides git membership and nothing else (ADR-REPO-ROOTCFG-COMMITTEDFLAG).
- Idempotent generation on every import, through `Write-FileIfChanged` (ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION).
- Every managed file, a template copy or a generator's output, carries the generated-file head (ADR-REPO-ROOTCFG-COMPOSEDROOTFILE).
- The registry, `.gitignore` and the tracked set agree, the copies equal their templates, and no target is a link
  (ADR-REPO-ROOTCFG-THREEWAYAGREEMENT).
- A `source` entry is a headed copy of its template, never a link, so a head written into the root file never lands in the template
  (ADR-REPO-ROOTCFG-HEADEDCOPY).
- A generator entry may name a wildcard target, each rendered file written, reported and checked on its own
  (ADR-REPO-ROOTCFG-WILDCARDGENERATOR).
- Every repository check is a quality gate that collects every issue, writes one report and throws once (ADR-AUTO-TEST-QUALITYGATE).

## Where the code and the decision record differ

ADR-REPO-ROOTCFG-THREEWAYAGREEMENT lists the drift check among the integrity test's assertions; the integrity check `Test-RootConfigFiles`
compares the `source` copies with their templates but no generator's output, and the generator drift check lives in `Test-GeneratedFiles`.

## See also

- [Generated root configs](../../drs/repository/generated-root-configs.md) — the decision this article explains.
- [Test automation](../../drs/automation/test-automation.md) — the quality-gate rule the two gates follow.
- The other lenses on the same mechanism: [meta](one-source-one-writer-one-boolean.md),
  [architecture](one-registry-one-writer-two-primitives.md), [implementation](opted-in-then-link-copy-or-render.md) and
  [operations](import-materialises-two-gates-name-the-fix.md).
- [The repository explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
