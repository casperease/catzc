---
catzc:
  immutable:
    with_body_sha: de4d4e8ac65d
    with_inputs_sha: b8e060035d40d4e4be4522c46003eb41dc4a68e3f0ca594ac90dd5f259034969
    repo_status: locked
    path: docs/references/contracts/catzc.md
    source: contracts/catzc
    role: reference
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
    generator: pwsh/Catzc.Base.Contracts/Build-ContractReference.ps1
---

# docs/references/contracts/catzc.md

`The catzc contracts`

The contract assets of the `catzc` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/catzc/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../adr/repository/api-contracts.md); command contracts:
[command-contracts](../../adr/repository/command-contracts.md).

## 0.0.0

The draft: the one mutable version folder ([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../adr/repository/api-contracts.md#rule-adr-repo-contract5)).

| Module                               | Asset                                            | Target                                                                    | Direction               | Kind             | Signature                                                                                                                                                           |
| ------------------------------------ | ------------------------------------------------ | ------------------------------------------------------------------------- | ----------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Catzc.Azure`                        | `Test-AzureNetworkPlan.command.yml`              | `pwsh/Catzc.Azure/Test-AzureNetworkPlan.ps1`                              | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Azure.DevOps`                 | `Test-Pipelines.command.yml`                     | `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1`                              | provided                | command contract | `Path: string, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                      |
| `Catzc.Azure.DevOps`                 | `pipelines/cd-apex.yaml`                         | `pipelines/cd-apex.yaml`                                                  | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/cd-flux.yaml`                         | `pipelines/cd-flux.yaml`                                                  | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/cd-nova.yaml`                         | `pipelines/cd-nova.yaml`                                                  | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/cd-shared.yaml`                       | `pipelines/cd-shared.yaml`                                                | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/ci-automation-expected-failures.yaml` | `pipelines/ci-automation-expected-failures.yaml`                          | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/ci-automation.yaml`                   | `pipelines/ci-automation.yaml`                                            | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps`                 | `pipelines/ci-infrastructure.yaml`               | `pipelines/ci-infrastructure.yaml`                                        | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Azure.DevOps.BuildValidation` | `Register-AdoBuildValidation.command.yml`        | `pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` | provided                | command contract | `GlobSet: string!, Pipeline: string, Branch: string, Project: string, Organization: string, RepositoryName: string, DryRun: switch`                                 |
| `Catzc.Azure.Templates`              | `Get-BicepParameterModel.command.yml`            | `pwsh/Catzc.Azure.Templates/Get-BicepParameterModel.ps1`                  | provided                | command contract | `Template: string! -> Catzc.Azure.Templates.BicepParameterModel`                                                                                                    |
| `Catzc.Azure.Templates`              | `Get-BicepTemplateNames.command.yml`             | `pwsh/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1`                   | provided                | command contract | `no parameters -> string[]`                                                                                                                                         |
| `Catzc.Base.ConfigExtensions`        | `Test-ConfigValidators.command.yml`              | `pwsh/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1`              | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Contracts`               | `Build-ContractReference.command.yml`            | `pwsh/Catzc.Base.Contracts/Build-ContractReference.ps1`                   | provided                | command contract | `RepositoryRoot: string, DryRun: switch, Silent: switch, PassThru: switch -> string[]`                                                                              |
| `Catzc.Base.Contracts`               | `Get-CommandContract.command.yml`                | `pwsh/Catzc.Base.Contracts/Get-CommandContract.ps1`                       | provided                | command contract | `Name: string[] = *, Module: string[] = *, Unit: string[] = *, Version: string[] = 0.0.0, RepositoryRoot: string -> Catzc.Base.Contracts.ContractCommand[]`         |
| `Catzc.Base.Contracts`               | `Get-ContractCheckResults.command.yml`           | `pwsh/Catzc.Base.Contracts/Get-ContractCheckResults.ps1`                  | provided                | command contract | `Asset: Catzc.Base.Contracts.ContractAsset[] pipeline, RepositoryRoot: string -> Catzc.Base.Contracts.ContractCheckResult[]`                                        |
| `Catzc.Base.Contracts`               | `Publish-ContractRelease.command.yml`            | `pwsh/Catzc.Base.Contracts/Publish-ContractRelease.ps1`                   | provided                | command contract | `Unit: string!, Version: string!, RepositoryRoot: string -> string`                                                                                                 |
| `Catzc.Base.Contracts`               | `Test-Contracts.command.yml`                     | `pwsh/Catzc.Base.Contracts/Test-Contracts.ps1`                            | provided                | command contract | `Version: string = 0.0.0, RepositoryRoot: string, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                   |
| `Catzc.Base.Docs`                    | `Test-AdrEngineNeutrality.command.yml`           | `pwsh/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1`                       | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Docs`                    | `Test-AdrRegistry.command.yml`                   | `pwsh/Catzc.Base.Docs/Test-AdrRegistry.ps1`                               | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Docs`                    | `Test-AgentDefinitions.command.yml`              | `pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1`                          | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Docs`                    | `Test-GeneratedReadmes.command.yml`              | `pwsh/Catzc.Base.Docs/Test-GeneratedReadmes.ps1`                          | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Docs`                    | `Test-Glossary.command.yml`                      | `pwsh/Catzc.Base.Docs/Test-Glossary.ps1`                                  | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Globs`                   | `Clear-GlobSetProtection.command.yml`            | `pwsh/Catzc.Base.Globs/Clear-GlobSetProtection.ps1`                       | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Base.Globs`                   | `Test-AdoPipelineTriggerGlob.command.yml`        | `pwsh/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1`                   | provided                | command contract | `Name: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                    |
| `Catzc.Base.Globs`                   | `Test-GitHubWorkflowTriggerGlob.command.yml`     | `pwsh/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1`                | provided                | command contract | `Name: string!, WorkflowPath: string!, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                              |
| `Catzc.Base.Globs`                   | `Test-GlobSetAffected.command.yml`               | `pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1`                          | provided                | command contract | `Name: string! -> bool`                                                                                                                                             |
| `Catzc.Base.Globs`                   | `Test-GlobSetIndependence.command.yml`           | `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`                      | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Globs`                   | `Test-GlobSetTriggerCoverage.command.yml`        | `pwsh/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1`                   | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Globs`                   | `configs/file-kinds.yml`                         | `pwsh/Catzc.Base.Globs/configs/file-kinds.yml`                            | provided (contract.yml) | fragment         | none                                                                                                                                                                |
| `Catzc.Base.Languages`               | `Get-FileLanguage.command.yml`                   | `pwsh/Catzc.Base.Languages/Get-FileLanguage.ps1`                          | provided                | command contract | `Name: string[]! in Name, Path: string! in Path; default set All -> Catzc.Base.Languages.FileLanguage`                                                              |
| `Catzc.Base.Languages`               | `Get-PathFileType.command.yml`                   | `pwsh/Catzc.Base.Languages/Get-PathFileType.ps1`                          | provided                | command contract | `Path: string! -> string`                                                                                                                                           |
| `Catzc.Base.Languages`               | `Invoke-BashTest.command.yml`                    | `pwsh/Catzc.Base.Languages/Invoke-BashTest.ps1`                           | provided                | command contract | `Module: string!, EntryScript: string, EngineExecutable: string -> Catzc.Base.Languages.BashTestResult`                                                             |
| `Catzc.Base.Languages`               | `Invoke-GoTest.command.yml`                      | `pwsh/Catzc.Base.Languages/Invoke-GoTest.ps1`                             | provided                | command contract | `Module: string!, EntryScript: string, GoExecutable: string, Engine: string, EngineExecutable: string -> Catzc.Base.Languages.GoTestResult`                         |
| `Catzc.Base.Languages`               | `Invoke-PythonTest.command.yml`                  | `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1`                         | provided                | command contract | `Module: string!, EntryScript: string, UvExecutable: string, Engine: string, EngineExecutable: string -> Catzc.Base.Languages.PythonTestResult`                     |
| `Catzc.Base.Languages`               | `New-GoWorkspace.command.yml`                    | `pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1`                           | provided                | command contract | `Target: string = * -> Catzc.Base.Languages.GoWorkspaceFile`                                                                                                        |
| `Catzc.Base.Languages`               | `New-PythonProject.command.yml`                  | `pwsh/Catzc.Base.Languages/New-PythonProject.ps1`                         | provided                | command contract | `Target: string = * -> Catzc.Base.Languages.PythonWorkspaceFile`                                                                                                    |
| `Catzc.Base.Languages`               | `Test-GeneratedFileCurrent.command.yml`          | `pwsh/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1`                 | provided                | command contract | `Path: string!, InputsSha: string! -> bool`                                                                                                                         |
| `Catzc.Base.Maps`                    | `Export-WorldMapPdf.command.yml`                 | `pwsh/Catzc.Base.Maps/Export-WorldMapPdf.ps1`                             | provided                | command contract | `View: string[], Adr: string[]! in Adr, Path: string[]! in Path; default set Plain -> string`                                                                       |
| `Catzc.Base.Maps`                    | `Test-ValueChainMap.command.yml`                 | `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1`                             | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.Maps`                    | `Test-WorldMap.command.yml`                      | `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1`                                  | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.ModuleSystem`            | `Test-CheckedInBinaries.command.yml`             | `pwsh/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1`                 | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.ModuleSystem`            | `Test-FolderConventions.command.yml`             | `pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1`                 | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.ModuleSystem`            | `Test-FunctionDependency.command.yml`            | `pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1`                | provided                | command contract | `ModulesRoot: string, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                               |
| `Catzc.Base.ModuleSystem`            | `Test-ModuleCycles.command.yml`                  | `pwsh/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1`                      | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.ModuleSystem`            | `Test-ModuleDependency.command.yml`              | `pwsh/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1`                  | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Build-EnglishDictionary.command.yml`            | `pwsh/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1`                | provided                | command contract | `DryRun: switch, PassThru: switch -> string`                                                                                                                        |
| `Catzc.Base.QualityGates`            | `Export-SpellingTriage.command.yml`              | `pwsh/Catzc.Base.QualityGates/Export-SpellingTriage.ps1`                  | provided                | command contract | `Path: string[], Exclude: string[], DryRun: switch -> string[]`                                                                                                     |
| `Catzc.Base.QualityGates`            | `Format-MarkdownTitle.command.yml`               | `pwsh/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1`                   | provided                | command contract | `Path: string[], RepositoryRoot: string, DryRun: switch, PassThru: switch -> string[]`                                                                              |
| `Catzc.Base.QualityGates`            | `Test-AnalyzerAdrMap.command.yml`                | `pwsh/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1`                    | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-BuildArtifact.command.yml`                 | `pwsh/Catzc.Base.QualityGates/Test-BuildArtifact.ps1`                     | provided                | command contract | `Module: string[], ModuleProfile: string, Facet: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                          |
| `Catzc.Base.QualityGates`            | `Test-Change.command.yml`                        | `pwsh/Catzc.Base.QualityGates/Test-Change.ps1`                            | provided                | command contract | `Path: string[], WholeModule: switch, DryRun: switch, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                               |
| `Catzc.Base.QualityGates`            | `Test-ConfigIdentityHygiene.command.yml`         | `pwsh/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1`             | provided                | command contract | `Path: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                    |
| `Catzc.Base.QualityGates`            | `Test-FileMetaProcessors.command.yml`            | `pwsh/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1`                | provided                | command contract | `Config: Catzc.Base.QualityGates.FileMetaConfig, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                    |
| `Catzc.Base.QualityGates`            | `Test-Formatting.command.yml`                    | `pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1`                        | provided                | command contract | `Language: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                |
| `Catzc.Base.QualityGates`            | `Test-GeneratedFiles.command.yml`                | `pwsh/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1`                    | provided                | command contract | `Generator: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                               |
| `Catzc.Base.QualityGates`            | `Test-Links.command.yml`                         | `pwsh/Catzc.Base.QualityGates/Test-Links.ps1`                             | provided                | command contract | `Path: string[], Kind: Catzc.Base.QualityGates.LinkKind, RepositoryRoot: string, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`    |
| `Catzc.Base.QualityGates`            | `Test-LogicTestIdentity.command.yml`             | `pwsh/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1`                 | provided                | command contract | `Path: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                    |
| `Catzc.Base.QualityGates`            | `Test-ManagedGuids.command.yml`                  | `pwsh/Catzc.Base.QualityGates/Test-ManagedGuids.ps1`                      | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-MarkdownTitle.command.yml`                 | `pwsh/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1`                     | provided                | command contract | `Path: string[], RepositoryRoot: string, OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                            |
| `Catzc.Base.QualityGates`            | `Test-Markdownlint.command.yml`                  | `pwsh/Catzc.Base.QualityGates/Test-Markdownlint.ps1`                      | provided                | command contract | `Path: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                    |
| `Catzc.Base.QualityGates`            | `Test-ParameterConsistency.command.yml`          | `pwsh/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1`              | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-PythonLint.command.yml`                    | `pwsh/Catzc.Base.QualityGates/Test-PythonLint.ps1`                        | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-PythonTypes.command.yml`                   | `pwsh/Catzc.Base.QualityGates/Test-PythonTypes.ps1`                       | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-ScriptAnalyzer.command.yml`                | `pwsh/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1`                    | provided                | command contract | `Path: string[], OutputFolder: string, NoCache: switch, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                   |
| `Catzc.Base.QualityGates`            | `Test-ShellScripts.command.yml`                  | `pwsh/Catzc.Base.QualityGates/Test-ShellScripts.ps1`                      | provided                | command contract | `ShellCheckExclude: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                       |
| `Catzc.Base.QualityGates`            | `Test-ShippedConfigs.command.yml`                | `pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1`                    | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `Test-Spelling.command.yml`                      | `pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1`                          | provided                | command contract | `Path: string[], Exclude: string[], OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                 |
| `Catzc.Base.QualityGates`            | `Test-Terminology.command.yml`                   | `pwsh/Catzc.Base.QualityGates/Test-Terminology.ps1`                       | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.QualityGates`            | `head.sample.yml`                                | none                                                                      | provided                | sample payload   | none                                                                                                                                                                |
| `Catzc.Base.QualityGates`            | `head.schema.json`                               | `contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.sample.yml`           | provided                | schema           | none                                                                                                                                                                |
| `Catzc.Base.Repository`              | `Get-RepositoryFile.command.yml`                 | `pwsh/Catzc.Base.Repository/Get-RepositoryFile.ps1`                       | provided                | command contract | `Path: string! -> string`                                                                                                                                           |
| `Catzc.Base.RootConfig`              | `Test-RootAnalyzerSettings.command.yml`          | `pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1`                | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.RootConfig`              | `Test-RootConfigFiles.command.yml`               | `pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1`                     | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Base.TypesSystem`             | `Test-ShippedTypes.command.yml`                  | `pwsh/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1`                       | provided                | command contract | `OutputFolder: string, PassThru: switch -> Catzc.Base.Reports.QualityGateResult`                                                                                    |
| `Catzc.Tooling.Github`               | `README.md`                                      | `.github/README.md`                                                       | depended-on             | presence         | none                                                                                                                                                                |
| `Catzc.Tooling.Github`               | `Remove-TokenFromHistory.command.yml`            | `pwsh/Catzc.Tooling.Github/Remove-TokenFromHistory.ps1`                   | provided                | command contract | `Token: string!, ReplaceWith: string = ***REMOVED***, SkipMessages: switch, RepositoryPath: string, DryRun: switch`                                                 |
| `Catzc.Tooling.Github`               | `workflows/ci-automation.yml`                    | `.github/workflows/ci-automation.yml`                                     | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Tooling.Github`               | `workflows/release-automation.yml`               | `.github/workflows/release-automation.yml`                                | depended-on             | fragment         | none                                                                                                                                                                |
| `Catzc.Tooling.Inspiration`          | `Get-Inspiration.command.yml`                    | `pwsh/Catzc.Tooling.Inspiration/Get-Inspiration.ps1`                      | provided                | command contract | `Id: string! in Id, Count: int! in Random, Seed: int in Random, IncludeUnavailable: switch in All,Random; default set All -> Catzc.Tooling.Inspiration.Inspiration` |
| `Catzc.Tooling.Node`                 | `Install-Cspell.command.yml`                     | `pwsh/Catzc.Tooling.Node/Install-Cspell.ps1`                              | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Node`                 | `Install-Markdownlint.command.yml`               | `pwsh/Catzc.Tooling.Node/Install-Markdownlint.ps1`                        | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Node`                 | `Install-NodeJs.command.yml`                     | `pwsh/Catzc.Tooling.Node/Install-NodeJs.ps1`                              | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Node`                 | `Install-Prettier.command.yml`                   | `pwsh/Catzc.Tooling.Node/Install-Prettier.ps1`                            | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Node`                 | `Remove-NodeJs.command.yml`                      | `pwsh/Catzc.Tooling.Node/Remove-NodeJs.ps1`                               | provided                | command contract | `InstallDir: string, Force: switch`                                                                                                                                 |
| `Catzc.Tooling.Node`                 | `Uninstall-Cspell.command.yml`                   | `pwsh/Catzc.Tooling.Node/Uninstall-Cspell.ps1`                            | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Node`                 | `Uninstall-Markdownlint.command.yml`             | `pwsh/Catzc.Tooling.Node/Uninstall-Markdownlint.ps1`                      | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Node`                 | `Uninstall-NodeJs.command.yml`                   | `pwsh/Catzc.Tooling.Node/Uninstall-NodeJs.ps1`                            | provided                | command contract | `Version: string, Remove: switch, Force: switch`                                                                                                                    |
| `Catzc.Tooling.Node`                 | `Uninstall-Prettier.command.yml`                 | `pwsh/Catzc.Tooling.Node/Uninstall-Prettier.ps1`                          | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Assert-DevBoxToolsStatus.command.yml`           | `pwsh/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1`            | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Install-DevBoxTools.command.yml`                | `pwsh/Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1`                 | provided                | command contract | `Force: switch`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Uninstall-Chocolatey.command.yml`               | `pwsh/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1`                | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Uninstall-DevBoxTools.command.yml`              | `pwsh/Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.ps1`               | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Uninstall-Git.command.yml`                      | `pwsh/Catzc.Tooling.Provisioning/Uninstall-Git.ps1`                       | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Uninstall-Postman.command.yml`                  | `pwsh/Catzc.Tooling.Provisioning/Uninstall-Postman.ps1`                   | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Provisioning`         | `Uninstall-Zsh.command.yml`                      | `pwsh/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1`                       | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Python`               | `Install-Poetry.command.yml`                     | `pwsh/Catzc.Tooling.Python/Install-Poetry.ps1`                            | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Python`               | `Install-PySpark.command.yml`                    | `pwsh/Catzc.Tooling.Python/Install-PySpark.ps1`                           | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Python`               | `Install-Python.command.yml`                     | `pwsh/Catzc.Tooling.Python/Install-Python.ps1`                            | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Python`               | `Invoke-Poetry.command.yml`                      | `pwsh/Catzc.Tooling.Python/Invoke-Poetry.ps1`                             | provided                | command contract | `Arguments: string!, PassThru: switch, NoAssert: switch, Silent: switch, DryRun: switch`                                                                            |
| `Catzc.Tooling.Python`               | `Remove-Python.command.yml`                      | `pwsh/Catzc.Tooling.Python/Remove-Python.ps1`                             | provided                | command contract | `InstallDir: string, Force: switch`                                                                                                                                 |
| `Catzc.Tooling.Python`               | `Uninstall-Poetry.command.yml`                   | `pwsh/Catzc.Tooling.Python/Uninstall-Poetry.ps1`                          | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Python`               | `Uninstall-PySpark.command.yml`                  | `pwsh/Catzc.Tooling.Python/Uninstall-PySpark.ps1`                         | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Python`               | `Uninstall-Python.command.yml`                   | `pwsh/Catzc.Tooling.Python/Uninstall-Python.ps1`                          | provided                | command contract | `Version: string`                                                                                                                                                   |
| `Catzc.Tooling.Toolchain`            | `Install-AzCli.command.yml`                      | `pwsh/Catzc.Tooling.Toolchain/Install-AzCli.ps1`                          | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Bicep.command.yml`                      | `pwsh/Catzc.Tooling.Toolchain/Install-Bicep.ps1`                          | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Dotnet.command.yml`                     | `pwsh/Catzc.Tooling.Toolchain/Install-Dotnet.ps1`                         | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Go.command.yml`                         | `pwsh/Catzc.Tooling.Toolchain/Install-Go.ps1`                             | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Java.command.yml`                       | `pwsh/Catzc.Tooling.Toolchain/Install-Java.ps1`                           | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Shellcheck.command.yml`                 | `pwsh/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1`                     | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Terraform.command.yml`                  | `pwsh/Catzc.Tooling.Toolchain/Install-Terraform.ps1`                      | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Install-Uv.command.yml`                         | `pwsh/Catzc.Tooling.Toolchain/Install-Uv.ps1`                             | provided                | command contract | `Version: string, Force: switch`                                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Remove-AzCli.command.yml`                       | `pwsh/Catzc.Tooling.Toolchain/Remove-AzCli.ps1`                           | provided                | command contract | `InstallDir: string, Force: switch`                                                                                                                                 |
| `Catzc.Tooling.Toolchain`            | `Remove-Dotnet.command.yml`                      | `pwsh/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1`                          | provided                | command contract | `InstallDir: string, Force: switch`                                                                                                                                 |
| `Catzc.Tooling.Toolchain`            | `Remove-Java.command.yml`                        | `pwsh/Catzc.Tooling.Toolchain/Remove-Java.ps1`                            | provided                | command contract | `InstallDir: string, Force: switch`                                                                                                                                 |
| `Catzc.Tooling.Toolchain`            | `Uninstall-AzCli.command.yml`                    | `pwsh/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1`                        | provided                | command contract | `Remove: switch, Force: switch`                                                                                                                                     |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Bicep.command.yml`                    | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Bicep.ps1`                        | provided                | command contract | `Version: string`                                                                                                                                                   |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Dotnet.command.yml`                   | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Dotnet.ps1`                       | provided                | command contract | `Remove: switch, Force: switch`                                                                                                                                     |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Go.command.yml`                       | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Go.ps1`                           | provided                | command contract | `no parameters`                                                                                                                                                     |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Java.command.yml`                     | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Java.ps1`                         | provided                | command contract | `Version: string, Remove: switch, Force: switch`                                                                                                                    |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Shellcheck.command.yml`               | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1`                   | provided                | command contract | `Version: string`                                                                                                                                                   |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Terraform.command.yml`                | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Terraform.ps1`                    | provided                | command contract | `Version: string`                                                                                                                                                   |
| `Catzc.Tooling.Toolchain`            | `Uninstall-Uv.command.yml`                       | `pwsh/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1`                           | provided                | command contract | `Version: string`                                                                                                                                                   |

Notes:

- `Catzc.Azure/Test-AzureNetworkPlan.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-AzureNetworkPlan, the quality gate that checks the network plan against the azure config's environments and subscriptions and returns
  its result under -PassThru.
- `Catzc.Azure.DevOps/Test-Pipelines.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-Pipelines, the quality gate that checks the pipelines/ tree against the naming-and-placement contract and returns its result under
  -PassThru.
- `Catzc.Azure.DevOps/pipelines/cd-apex.yaml`: Depended-on fragment of pipelines/cd-apex.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-flux.yaml`: Depended-on fragment of pipelines/cd-flux.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-nova.yaml`: Depended-on fragment of pipelines/cd-nova.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-shared.yaml`: Depended-on fragment of pipelines/cd-shared.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `stages` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-automation-expected-failures.yaml`: Depended-on fragment of
  pipelines/ci-automation-expected-failures.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-automation.yaml`: Depended-on fragment of pipelines/ci-automation.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-infrastructure.yaml`: Depended-on fragment of pipelines/ci-infrastructure.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml`: Provided command contract
  (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of Register-AdoBuildValidation, which creates or updates the build-validation
  branch policy tied to a globset. Branch, Project, Organization and RepositoryName default to the configured values, computed defaults the
  contract does not restate; DryRun reports the change instead of making it.
- `Catzc.Azure.Templates/Get-BicepParameterModel.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Get-BicepParameterModel, which returns a template's Bicep parameter model, every parameter its compiled main.json declares.
- `Catzc.Azure.Templates/Get-BicepTemplateNames.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Get-BicepTemplateNames, which returns the names of all discovered Bicep templates; it takes no parameters.
- `Catzc.Base.ConfigExtensions/Test-ConfigValidators.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the
  call interface of Test-ConfigValidators, the quality gate that checks every config validator maps to a config of its own module and
  returns its result under -PassThru.
- `Catzc.Base.Contracts/Build-ContractReference.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Build-ContractReference, the generator of the contract reference pages. RepositoryRoot defaults to the repository root, a
  computed default the contract does not restate.
- `Catzc.Base.Contracts/Get-CommandContract.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT and
  ADR-REPO-CMDCONTRACT-ONEREADER): the call interface of Get-CommandContract, the one reader of command contracts. RepositoryRoot defaults
  to the repository root, a computed default the contract does not restate.
- `Catzc.Base.Contracts/Get-ContractCheckResults.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Get-ContractCheckResults, the per-asset contract check; the assets arrive by parameter or from the pipeline. RepositoryRoot
  defaults to the repository root, a computed default the contract does not restate.
- `Catzc.Base.Contracts/Publish-ContractRelease.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT and
  ADR-REPO-CMDCONTRACT-VERSIONSWITHUNIT): the call interface of Publish-ContractRelease, which freezes the draft contracts of a unit as a
  released version folder. RepositoryRoot defaults to the repository root, a computed default the contract does not restate.
- `Catzc.Base.Contracts/Test-Contracts.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-Contracts, the quality gate that checks the repository honours every binding contract asset and every released folder is unchanged,
  and returns its result under -PassThru.
- `Catzc.Base.Docs/Test-AdrEngineNeutrality.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-AdrEngineNeutrality, the quality gate that checks the configured ADR domains' rule summaries carry no engine-specific
  syntax and returns its result under -PassThru.
- `Catzc.Base.Docs/Test-AdrRegistry.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-AdrRegistry, the quality gate that checks the ADR registry and the ADR rule files agree and returns its result, with each configured
  check's findings, under -PassThru.
- `Catzc.Base.Docs/Test-AgentDefinitions.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Test-AgentDefinitions, the quality gate that checks the sub-agent definitions, their capabilities, both registries and the CLAUDE.md
  list agree, and returns its result under -PassThru.
- `Catzc.Base.Docs/Test-GeneratedReadmes.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Test-GeneratedReadmes, the quality gate that checks every generated README is gitignored, untracked and current, and returns its result
  under -PassThru.
- `Catzc.Base.Docs/Test-Glossary.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-Glossary, the quality gate that checks the controlled vocabulary against the repository and returns its result under -PassThru.
- `Catzc.Base.Globs/Clear-GlobSetProtection.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Clear-GlobSetProtection, which drops every recorded glob protection so the next run of every protected scan scans in full; it
  takes no parameters.
- `Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-AdoPipelineTriggerGlob, the quality gate that checks each named ADO pipeline's trigger path filters against its
  globset's projection and returns its result under -PassThru.
- `Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-GitHubWorkflowTriggerGlob, the quality gate that checks a GitHub workflow's trigger path filters against a globset's
  projection and returns its result under -PassThru.
- `Catzc.Base.Globs/Test-GlobSetAffected.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Test-GlobSetAffected, which says whether the current context's change touches the named globset.
- `Catzc.Base.Globs/Test-GlobSetIndependence.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-GlobSetIndependence, the quality gate that checks no two globsets of one layer select a common file on their own
  contribution, and returns its result under -PassThru.
- `Catzc.Base.Globs/Test-GlobSetTriggerCoverage.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-GlobSetTriggerCoverage, the quality gate that checks every member of a pipeline-bound globset matches one of its ADO
  trigger include patterns, and returns its result under -PassThru.
- `Catzc.Base.Globs/configs/file-kinds.yml`: Provided fragment of pwsh/Catzc.Base.Globs/configs/file-kinds.yml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the kinds and subkinds a
  consumer may rely on to be in the file-kinds registry, so the `kind` and `subkind` a file's meta head names keep their meaning. A null
  value pins only that the key exists; the definitions and the globs may change, and a consumer extends the registry with a config fragment
  of its own.
- `Catzc.Base.Languages/Get-FileLanguage.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Get-FileLanguage, the file-language reader: every language with no argument, the languages by name, or the language of one file by
  path.
- `Catzc.Base.Languages/Get-PathFileType.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Get-PathFileType, which names the file type a path resolves to through the file-language registry.
- `Catzc.Base.Languages/Invoke-BashTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Invoke-BashTest, the bash test runner of one module.
- `Catzc.Base.Languages/Invoke-GoTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Invoke-GoTest, the Go test runner of one module. Engine defaults to the pwsh engine of the engine registry, a computed default the
  contract does not restate.
- `Catzc.Base.Languages/Invoke-PythonTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Invoke-PythonTest, the Python test runner of one module. Engine defaults to the pwsh engine of the engine registry, a computed default
  the contract does not restate.
- `Catzc.Base.Languages/New-GoWorkspace.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of New-GoWorkspace, the go.work generator; Target selects the verification modules it renders for, every one by default.
- `Catzc.Base.Languages/New-PythonProject.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of New-PythonProject, the pyproject generator; Target selects the verification modules it renders for, every one by default.
- `Catzc.Base.Languages/Test-GeneratedFileCurrent.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-GeneratedFileCurrent, which says whether a generated file's head carries the given inputs stamp.
- `Catzc.Base.Maps/Export-WorldMapPdf.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Export-WorldMapPdf, which writes the world map as PDFs, the grid view, the tree view or both, plain or with the cells of named ADRs or
  paths highlighted, and returns the paths it wrote.
- `Catzc.Base.Maps/Test-ValueChainMap.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-ValueChainMap, the quality gate that checks every ADR sits in a cell of the value-chain map and every label it prints is a glossary
  term, and returns its result under -PassThru.
- `Catzc.Base.Maps/Test-WorldMap.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-WorldMap, the quality gate that checks every tracked file sits in a declared track and its tech-stack and every label the map prints
  is a glossary term, and returns its result under -PassThru.
- `Catzc.Base.ModuleSystem/Test-CheckedInBinaries.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-CheckedInBinaries, the quality gate that checks every checked-in binary is stored byte-exact and returns its result
  under -PassThru.
- `Catzc.Base.ModuleSystem/Test-FolderConventions.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-FolderConventions, the quality gate that checks every module folder under pwsh/ follows the folder and file conventions,
  and returns its result under -PassThru.
- `Catzc.Base.ModuleSystem/Test-FunctionDependency.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-FunctionDependency, the quality gate that checks every function-to-function call resolves to a defined command, and
  returns its result under -PassThru.
- `Catzc.Base.ModuleSystem/Test-ModuleCycles.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ModuleCycles, the quality gate that checks the real module-to-module call graph has no cycle, and returns its result
  under -PassThru.
- `Catzc.Base.ModuleSystem/Test-ModuleDependency.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ModuleDependency, the quality gate that checks the actual module dependencies conform to the declared graph, and returns
  its result under -PassThru.
- `Catzc.Base.QualityGates/Build-EnglishDictionary.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Build-EnglishDictionary, which generates the committed English word list the spell-out-names analyzer rule checks identifiers
  against.
- `Catzc.Base.QualityGates/Export-SpellingTriage.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Export-SpellingTriage, which collects the spell-checker's flagged tokens into a triage queue. Path and Exclude default to the
  repository's own globs, a default the contract does not restate.
- `Catzc.Base.QualityGates/Format-MarkdownTitle.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Format-MarkdownTitle, which makes the H1 of every in-scope Markdown file its title. RepositoryRoot defaults to the repository
  root, a computed default the contract does not restate.
- `Catzc.Base.QualityGates/Test-AnalyzerAdrMap.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-AnalyzerAdrMap, the quality gate that checks the analyzer map cites only real ADR rules and maps every custom analyzer
  rule, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-BuildArtifact.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-BuildArtifact, the quality gate that builds the selected modules once into a temporary destination, verifies the built
  artifact by facet, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-Change.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-Change, the quality gate over what changed: it runs the tests and checks of the changed files and returns its result under -PassThru,
  or the planned set under -DryRun.
- `Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the
  call interface of Test-ConfigIdentityHygiene, the quality gate that checks no shipped config carries a test-fixture identity in its data,
  and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-FileMetaProcessors.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-FileMetaProcessors, the quality gate that checks every meta kind resolves to a processor and every processor belongs to
  a kind, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-Formatting.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-Formatting, the quality gate that checks formatting would leave the repository unchanged, for every file language or the
  named ones, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-GeneratedFiles.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-GeneratedFiles, the quality gate that checks every generated file equals what its generator would write now, and returns
  its result under -PassThru.
- `Catzc.Base.QualityGates/Test-Links.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Test-Links, the link quality gate that fails on any off-form, dangling or dead link or citation, and returns its result, with the
  report-mode findings, under -PassThru.
- `Catzc.Base.QualityGates/Test-LogicTestIdentity.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-LogicTestIdentity, the quality gate that checks no logic test names a live production identity, and returns its result
  under -PassThru.
- `Catzc.Base.QualityGates/Test-ManagedGuids.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ManagedGuids, the quality gate that checks every guid in tracked text is registered, none is denied and every entry is
  live, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-MarkdownTitle.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-MarkdownTitle, the quality gate that fails on any in-scope Markdown file whose title or headings are not in normal form,
  and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-Markdownlint.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-Markdownlint, the quality gate that lints the repository's Markdown with markdownlint-cli2 and returns its result under
  -PassThru.
- `Catzc.Base.QualityGates/Test-ParameterConsistency.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the
  call interface of Test-ParameterConsistency, the quality gate that checks one parameter name means one type across the public functions,
  and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-PythonLint.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-PythonLint, the quality gate that lints every Python file the repository holds with ruff, and returns its result under
  -PassThru.
- `Catzc.Base.QualityGates/Test-PythonTypes.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-PythonTypes, the quality gate that type-checks every Python file the repository holds with pyright, and returns its
  result under -PassThru.
- `Catzc.Base.QualityGates/Test-ScriptAnalyzer.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ScriptAnalyzer, the quality gate that analyzes the PowerShell with PSScriptAnalyzer, and returns its result under
  -PassThru.
- `Catzc.Base.QualityGates/Test-ShellScripts.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ShellScripts, the quality gate that checks every shell script for LF line endings, the executable bit and its syntax
  check, and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-ShippedConfigs.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ShippedConfigs, the quality gate that checks every shipped config has a registered C# config type and loads through it,
  and returns its result under -PassThru.
- `Catzc.Base.QualityGates/Test-Spelling.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Test-Spelling, the quality gate that spell-checks the repository's known file types with cspell, and returns its result under
  -PassThru.
- `Catzc.Base.QualityGates/Test-Terminology.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-Terminology, the quality gate that checks the terminology registry has no drift, no orphans and no unjustified entries,
  and returns its result under -PassThru.
- `Catzc.Base.QualityGates/head.sample.yml`: Provided sample of a file's meta head
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the shape a tool may rely
  on when it reads the `catzc.immutable` and `catzc.edges` parts of a head, written by Format-FileMeta in the carrier of the file (a comment
  head, or Markdown front matter). Every key is optional except `path` and `role`, and a fact a file has no value for is left out. The role
  is the name of the file-kinds entry that selects the file; the kind of the object it belongs to is its track's type, `tracktype`. Its
  schema, head.schema.json, lists the keys.
- `Catzc.Base.QualityGates/head.schema.json`: Provided schema of a file's meta head, validated against the sample beside it
  (ADR-REPO-CONTRACT-CONTRACTASSET): the keys of catzc.immutable (the place facts) and catzc.edges (the outgoing edges), which a tool may
  rely on. A fact a file has no value for is left out, so only path and role are required. The role is the name of the file-kinds entry that
  selects the file; the kind of the object the file belongs to is its track's type, tracktype.
- `Catzc.Base.Repository/Get-RepositoryFile.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Get-RepositoryFile, which returns the full, normalized path to a file relative to the repository root.
- `Catzc.Base.RootConfig/Test-RootAnalyzerSettings.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-RootAnalyzerSettings, the quality gate that checks the root analyzer settings parse as a settings hashtable through
  their link, and returns its result under -PassThru.
- `Catzc.Base.RootConfig/Test-RootConfigFiles.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-RootConfigFiles, the quality gate that checks every managed root config file agrees with rootconfig.yml on tracking,
  .gitignore and link mechanism, and returns its result under -PassThru.
- `Catzc.Base.TypesSystem/Test-ShippedTypes.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Test-ShippedTypes, the quality gate that checks every shipped C# type resolves in the session by its module and file name,
  and returns its result under -PassThru.
- `Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Remove-TokenFromHistory, which scrubs a token from a git history's blob content and commit messages. RepositoryPath defaults
  to the repository root, a computed default the contract does not restate; SkipMessages leaves the commit messages alone, and DryRun
  reports what would change.
- `Catzc.Tooling.Github/workflows/ci-automation.yml`: Depended-on fragment of .github/workflows/ci-automation.yml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the keys GitHub Actions
  requires to run the workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only
  that the key exists. Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `Catzc.Tooling.Github/workflows/release-automation.yml`: Depended-on fragment of .github/workflows/release-automation.yml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the keys GitHub Actions
  requires to run the workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only
  that the key exists. Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `Catzc.Tooling.Inspiration/Get-Inspiration.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Get-Inspiration, which lists the inspirations catzc reads for ideas: all of them, one by id, or a count of them at random
  with an optional seed.
- `Catzc.Tooling.Node/Install-Cspell.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Cspell, which installs cspell. Version defaults to the version tools.yml locks for 'cspell', a computed default the contract does
  not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-Markdownlint.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Install-Markdownlint, which installs markdownlint. Version defaults to the version tools.yml locks for 'markdownlint', a
  computed default the contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-NodeJs.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-NodeJs, which installs Node.js. Version defaults to the version tools.yml locks for 'node_js', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-Prettier.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Prettier, which installs Prettier. Version defaults to the version tools.yml locks for 'prettier', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Node/Remove-NodeJs.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Remove-NodeJs, which removes a manually installed Node.js and its PATH entries. InstallDir defaults to the install it finds, a computed
  default the contract does not restate; without Force it shows what it would remove (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Node/Uninstall-Cspell.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Uninstall-Cspell, which uninstalls cspell, the global npm package; it takes no parameters and skips when cspell or npm is absent.
- `Catzc.Tooling.Node/Uninstall-Markdownlint.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Markdownlint, which uninstalls markdownlint-cli2, the global npm package; it takes no parameters and skips when it
  or npm is absent.
- `Catzc.Tooling.Node/Uninstall-NodeJs.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Uninstall-NodeJs, which uninstalls Node.js through the platform package manager. Version defaults to the version tools.yml locks, a
  computed default the contract does not restate; Remove escalates to Remove-NodeJs for an off-config install, and Force confirms that
  destructive step (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Node/Uninstall-Prettier.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Prettier, which uninstalls Prettier, the global npm package; it takes no parameters and skips when it or npm is absent.
- `Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the
  call interface of Assert-DevBoxToolsStatus, which throws unless every tool is available at its locked version; it takes no parameters.
- `Catzc.Tooling.Provisioning/Install-DevBoxTools.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Install-DevBoxTools, which provisions the local development environment with every required tool; Force reinstalls over
  present installs.
- `Catzc.Tooling.Provisioning/Uninstall-Chocolatey.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Chocolatey, which uninstalls Chocolatey from the current machine; it takes no parameters.
- `Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-DevBoxTools, which removes every tool Install-DevBoxTools installed; it takes no parameters.
- `Catzc.Tooling.Provisioning/Uninstall-Git.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Git, which uninstalls the Git Install-Git installed; it takes no parameters.
- `Catzc.Tooling.Provisioning/Uninstall-Postman.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Postman, which uninstalls the Postman desktop app; it takes no parameters.
- `Catzc.Tooling.Provisioning/Uninstall-Zsh.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Zsh, which uninstalls the zsh Install-Zsh placed; it takes no parameters.
- `Catzc.Tooling.Python/Install-Poetry.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Poetry, which installs Poetry. Version defaults to the version tools.yml locks for 'poetry', a computed default the contract does
  not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Install-PySpark.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Install-PySpark, which installs PySpark. Version defaults to the version tools.yml locks for 'py_spark', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Install-Python.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Python, which installs Python. Version defaults to the version tools.yml locks for 'python', a computed default the contract does
  not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Invoke-Poetry.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Invoke-Poetry, which runs poetry with the given arguments.
- `Catzc.Tooling.Python/Remove-Python.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Remove-Python, which removes a manually installed Python and its PATH entries. InstallDir defaults to the install it finds, a computed
  default the contract does not restate; without Force it shows what it would remove (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Python/Uninstall-Poetry.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Poetry, which uninstalls Poetry; it takes no parameters.
- `Catzc.Tooling.Python/Uninstall-PySpark.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-PySpark, which uninstalls PySpark from the uv-managed Python; it takes no parameters.
- `Catzc.Tooling.Python/Uninstall-Python.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Python, which uninstalls the uv-provisioned Python. Version defaults to the version tools.yml locks, a computed default the
  contract does not restate.
- `Catzc.Tooling.Toolchain/Install-AzCli.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Install-AzCli, which installs the Azure CLI. Version defaults to the version tools.yml locks for 'az_cli', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Bicep.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Install-Bicep, which installs the Bicep CLI. Version defaults to the version tools.yml locks for 'bicep', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Dotnet.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Install-Dotnet, which installs the .NET SDK. Version defaults to the version tools.yml locks for 'dotnet', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Go.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Go, which installs Go. Version defaults to the version tools.yml locks for 'go', a computed default the contract does not restate;
  Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Java.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Install-Java, which installs Java. Version defaults to the version tools.yml locks for 'java', a computed default the contract does not
  restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Shellcheck.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Install-Shellcheck, which installs ShellCheck. Version defaults to the version tools.yml locks for 'shellcheck', a computed
  default the contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Terraform.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Install-Terraform, which installs Terraform. Version defaults to the version tools.yml locks for 'terraform', a computed
  default the contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Uv.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Install-Uv, which installs uv. Version defaults to the version tools.yml locks for 'uv', a computed default the contract does not restate;
  Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Remove-AzCli.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Remove-AzCli, which evicts an off-config install. InstallDir defaults to the install it finds, a computed default the contract does not
  restate; without Force it shows what it would remove (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Remove-Dotnet.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Remove-Dotnet, which evicts an off-config install. InstallDir defaults to the install it finds, a computed default the contract does
  not restate; without Force it shows what it would remove (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Remove-Java.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface of
  Remove-Java, which evicts an off-config install. InstallDir defaults to the install it finds, a computed default the contract does not
  restate; without Force it shows what it would remove (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Uninstall-AzCli.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-AzCli, which uninstalls the managed install. Remove escalates to Remove-AzCli for an off-config install, and Force
  confirms that destructive step (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Uninstall-Bicep.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Bicep, which uninstalls the tool. Version defaults to the installed or locked version, a computed default the
  contract does not restate.
- `Catzc.Tooling.Toolchain/Uninstall-Dotnet.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Dotnet, which uninstalls the managed install. Remove escalates to Remove-Dotnet for an off-config install, and
  Force confirms that destructive step (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Uninstall-Go.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Go, which uninstalls the Go toolchain Install-Go installed; it takes no parameters.
- `Catzc.Tooling.Toolchain/Uninstall-Java.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Java, which uninstalls Java through the platform package manager. Version defaults to the version tools.yml locks, a computed
  default the contract does not restate; Remove escalates to Remove-Java for an off-config install, and Force confirms that destructive step
  (ADR-AUTO-REMOVE-DOUBLYGUARDED).
- `Catzc.Tooling.Toolchain/Uninstall-Shellcheck.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Shellcheck, which uninstalls the tool. Version defaults to the installed or locked version, a computed default the
  contract does not restate.
- `Catzc.Tooling.Toolchain/Uninstall-Terraform.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call
  interface of Uninstall-Terraform, which uninstalls the tool. Version defaults to the installed or locked version, a computed default the
  contract does not restate.
- `Catzc.Tooling.Toolchain/Uninstall-Uv.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT): the call interface
  of Uninstall-Uv, which uninstalls the tool. Version defaults to the installed or locked version, a computed default the contract does not
  restate.
