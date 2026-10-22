# One registry, one writer, one write primitive, two kinds of target

```text
Root config materialisation is one registry, one writer, one write primitive and two kinds of target.

1  template files          the files under pwsh/ that a source entry copies out under a generated-file head
2  generator functions     the eleven functions a generator entry names, bound in one dispatch
3  rootconfig.yml          the registry: 28 entries, each with one source of truth and two booleans
4  Build-RootConfig        the single writer, in Catzc.Base.RootConfig, run by the importer tail
5  Write-FileIfChanged     the one write primitive, in Catzc.Base.Files: all 28 entries are written through it
6  gitignored targets      22 targets git ignores
7  tracked targets         6 targets git keeps, because git or the bootstrap reads them before the importer runs

Supports ADR-REPO-ROOTCFG-REGISTRY, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION and ADR-REPO-ROOTCFG-HEADEDCOPY (architecture lens).
```

Root config materialisation in cats has four parts and one direction. Sources of truth sit under `pwsh/`; the registry in
`Catzc.Base.RootConfig` says how each one lands; the writer in the same module reproduces every target through the one write primitive that
`Catzc.Base.Files` owns; and the targets fall into two kinds that differ by one boolean. The dependency edges point one way, from the
RootConfig module to the Files module and to the modules that hold the generators, and nothing reads the registry back.

```yml drawio
description:
  The registry, the templates and the generators feed one writer in the RootConfig module, which writes every target through the one
  primitive in the Files module; the targets split into gitignored and tracked by one boolean.
about:
  adrs: [ADR-REPO-ROOTCFG-REGISTRY, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, ADR-REPO-ROOTCFG-HEADEDCOPY]
  lens: architecture
content:
  title: One registry, one writer, one write primitive, two kinds of target
  kind: explanation
  flow: left-to-right
  relation: feeds the next step
  theme: dark
  bands:
    - { id: band-source, label: SOURCE OF TRUTH }
    - { id: band-root-config, label: CATZC.BASE.ROOTCONFIG }
    - { id: band-files, label: CATZC.BASE.FILES }
    - { id: band-target, label: TARGET }
  glyphs:
    - { id: g-templates, kind: file, label: template files, in: band-source }
    - { id: g-generators, kind: set, label: generator functions, in: band-source }
    - { id: g-rootconfig-yml, kind: file, label: rootconfig.yml, in: band-source }
    - { id: g-build-root-config, kind: code, label: Build-RootConfig (importer tail), in: band-root-config }
    - { id: g-write-if-changed, kind: code, label: Write-FileIfChanged, in: band-files }
    - { id: r-gitignored, kind: result, label: gitignored targets, in: band-target }
    - { id: r-tracked, kind: result, label: tracked targets, in: band-target }
  edges:
    - { from: g-templates, to: g-build-root-config, kind: flow, label: "" }
    - { from: g-generators, to: g-build-root-config, kind: flow, label: "" }
    - { from: g-rootconfig-yml, to: g-build-root-config, kind: flow, label: "" }
    - { from: g-build-root-config, to: g-write-if-changed, kind: flow, label: 28/28 }
    - { from: g-write-if-changed, to: r-gitignored, kind: flow, label: "22" }
    - { from: g-write-if-changed, to: r-tracked, kind: flow, label: "6" }
  markers:
    - { at: g-templates, number: 1 }
    - { at: g-generators, number: 2 }
    - { at: g-rootconfig-yml, number: 3 }
    - { at: g-build-root-config, number: 4 }
    - { at: g-write-if-changed, number: 5 }
    - { at: r-gitignored, number: 6 }
    - { at: r-tracked, number: 7 }
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
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Git/.
        by:
          - pwsh/Catzc.Base.Git/New-GitIgnore.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Git/configs
        by:
          - pwsh/Catzc.Base.Git/configs/gitignore.yml
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Git/types
        by:
          - pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Languages/.
        by:
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.RootConfig/.
        by:
          - pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
          - pwsh/Catzc.Base.RootConfig/New-GitAttributes.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.RootConfig/configs
        by:
          - pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.RootConfig/private
        by:
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigCopyContent.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
          - pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.RootConfig/tests
        by:
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.RootConfig/types
        by:
          - pwsh/Catzc.Base.RootConfig/types/RootConfigFiles.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.VSCode/.
        by:
          - pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
          - pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.VSCode/configs
        by:
          - pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-launch.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
          - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: pwsh/Catzc.Base.VSCode/types
        by:
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
    module-neighbourhood:
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: subject/Catzc.Base.Git
        by:
          - pwsh/Catzc.Base.Git/New-GitIgnore.ps1
          - pwsh/Catzc.Base.Git/configs/gitignore.yml
          - pwsh/Catzc.Base.Git/types/GitIgnoreConfig.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
      - cell: subject/Catzc.Base.Languages
        by:
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
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
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
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
          - ADR-REPO-ROOTCFG-HEADEDCOPY
          - ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION
          - ADR-REPO-ROOTCFG-REGISTRY
    axis:
      - cell: AUTO/*
        by: [ADR-REPO-ROOTCFG-HEADEDCOPY, ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION, ADR-REPO-ROOTCFG-REGISTRY]
layout:
  band-source: { x: 20, y: 84, w: 300, h: 340 }
  band-root-config: { x: 340, y: 84, w: 380, h: 340 }
  band-files: { x: 740, y: 84, w: 240, h: 340 }
  band-target: { x: 1000, y: 84, w: 280, h: 340 }
  g-templates: { x: 60, y: 140, w: 220, h: 52 }
  g-generators: { x: 60, y: 240, w: 220, h: 44 }
  g-rootconfig-yml: { x: 60, y: 330, w: 220, h: 52 }
  g-build-root-config: { x: 400, y: 200, w: 260, h: 70 }
  g-write-if-changed: { x: 760, y: 213, w: 200, h: 44 }
  r-gitignored: { x: 1020, y: 140, w: 240, h: 44 }
  r-tracked: { x: 1020, y: 290, w: 240, h: 44 }
```

![One registry, one writer, one write primitive, two kinds of target](.assets/one-registry-one-writer-two-primitives.drawio.png)

## Walkthrough

1. **Template files.** A `source` entry names a file kept under `pwsh/`, most of them in `Catzc.Base.RootConfig/assets/root/`. The root path
   is a copy of it under a generated-file head that names it as the source; the template itself stays the pure authored file.
2. **Generator functions.** A `generator` entry names a function that renders the file: `New-Importer`, `New-GitIgnore`,
   `New-GitAttributes`, `New-CatsCommandLookup`, the five `New-VsCode*` writers, `New-GoWorkspace` and `New-PythonProject`.
   `Invoke-RootConfigGenerator` is the one place a name is bound to its call, so an unknown name fails loudly.
3. **rootconfig.yml.** The registry lists 28 entries. Each names its target, exactly one source of truth, and the booleans `optIn` and
   `committed`. Nothing else in cats restates the target-to-source pairing.
4. **Build-RootConfig.** The single writer reads the registry, keeps the opted-in entries, and reproduces each target. The importer tail
   runs it on every load, silently; a clean tree is a no-op.
5. **Write-FileIfChanged.** Every entry hands its composed content, the generated-file head over the template or the generator's output, to
   the one shared write primitive: canonical output, a line-ending-insensitive compare, and a delete-then-write only on a real change.
   Before the write, `Build-RootConfig` deletes a target still left as a link from before, so no root file is a link.
6. **Gitignored targets.** 22 targets are gitignored, each matched by a `.gitignore` rule that `New-GitIgnore` injects from the registry.
7. **Tracked targets.** The remaining 6 stay in git because git or the bootstrap reads them before the importer runs: `importer.ps1`,
   `.gitignore`, `.gitattributes` and `pwsh/.internal/assets/importer-commands.sh` from generators, and `importer.sh` and
   `pwsh/.internal/assets/Catzc.Types.csproj` as headed copies.

## Why it holds

- The registry is one file and `Build-RootConfig` is its single writer; the target-to-source pairing lives nowhere else
  (ADR-REPO-ROOTCFG-REGISTRY).
- All writes go through `Write-FileIfChanged`, whose delete-then-write never writes through a link into a source of truth
  (ADR-REPO-ROOTCFG-IDEMPOTENTGENERATION).
- A `source` entry is a headed copy of its template, never a link to it, since a head written into a link would land in the template
  (ADR-REPO-ROOTCFG-HEADEDCOPY).

## See also

- [Generated root configs](../../drs/repository/generated-root-configs.md) — the decision this article explains.
- The other lenses on the same mechanism: [meta](one-source-one-writer-one-boolean.md),
  [implementation](opted-in-then-link-copy-or-render.md), [operations](import-materialises-two-gates-name-the-fix.md) and
  [governance](three-gates-check-registry-drift-membership.md).
- [The repository explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
