---
catzc:
  immutable:
    with_body_sha: "092f92cdde6a"
    with_inputs_sha: b02e26b00842dc9e24c7285300eccff061523b153237ebc3cea622c8fc7f7c05
    repo_status: locked
    path: docs/references/contracts/catzc.md
    source: contracts/catzc
    role: reference
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.Contracts/Build-ContractReference.ps1
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

The draft: the one mutable version folder ([ADR-REPO-CONTRACT#5](../../adr/repository/api-contracts.md#rule-adr-repo-contract5)).

| Module                    | Asset                                            | Target                                                          | Direction               | Kind             | Signature                                                                                                                                                   |
| ------------------------- | ------------------------------------------------ | --------------------------------------------------------------- | ----------------------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Catzc.Azure.DevOps`      | `pipelines/cd-apex.yaml`                         | `pipelines/cd-apex.yaml`                                        | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/cd-flux.yaml`                         | `pipelines/cd-flux.yaml`                                        | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/cd-nova.yaml`                         | `pipelines/cd-nova.yaml`                                        | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/cd-shared.yaml`                       | `pipelines/cd-shared.yaml`                                      | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/ci-automation-expected-failures.yaml` | `pipelines/ci-automation-expected-failures.yaml`                | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/ci-automation.yaml`                   | `pipelines/ci-automation.yaml`                                  | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Azure.DevOps`      | `pipelines/ci-infrastructure.yaml`               | `pipelines/ci-infrastructure.yaml`                              | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Base.Contracts`    | `Build-ContractReference.command.yml`            | `automation/Catzc.Base.Contracts/Build-ContractReference.ps1`   | provided                | command contract | `RepositoryRoot: string, DryRun: switch, Silent: switch, PassThru: switch -> string[]`                                                                      |
| `Catzc.Base.Contracts`    | `Get-CommandContract.command.yml`                | `automation/Catzc.Base.Contracts/Get-CommandContract.ps1`       | provided                | command contract | `Name: string[] = *, Module: string[] = *, Unit: string[] = *, Version: string[] = 0.0.0, RepositoryRoot: string -> Catzc.Base.Contracts.ContractCommand[]` |
| `Catzc.Base.Contracts`    | `Get-ContractCheckResults.command.yml`           | `automation/Catzc.Base.Contracts/Get-ContractCheckResults.ps1`  | provided                | command contract | `Asset: Catzc.Base.Contracts.ContractAsset[] pipeline, RepositoryRoot: string -> Catzc.Base.Contracts.ContractCheckResult[]`                                |
| `Catzc.Base.Contracts`    | `Publish-ContractRelease.command.yml`            | `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1`   | provided                | command contract | `Unit: string!, Version: string!, RepositoryRoot: string -> string`                                                                                         |
| `Catzc.Base.Globs`        | `configs/file-kinds.yml`                         | `automation/Catzc.Base.Globs/configs/file-kinds.yml`            | provided (contract.yml) | fragment         | none                                                                                                                                                        |
| `Catzc.Base.Languages`    | `Get-FileLanguage.command.yml`                   | `automation/Catzc.Base.Languages/Get-FileLanguage.ps1`          | provided                | command contract | `Name: string[]!, Path: string! -> Catzc.Base.Languages.FileLanguage`                                                                                       |
| `Catzc.Base.Languages`    | `Get-PathFileType.command.yml`                   | `automation/Catzc.Base.Languages/Get-PathFileType.ps1`          | provided                | command contract | `Path: string! -> string`                                                                                                                                   |
| `Catzc.Base.Languages`    | `Invoke-BashTest.command.yml`                    | `automation/Catzc.Base.Languages/Invoke-BashTest.ps1`           | provided                | command contract | `Module: string!, EntryScript: string, EngineExecutable: string -> Catzc.Base.Languages.BashTestResult`                                                     |
| `Catzc.Base.Languages`    | `Invoke-GoTest.command.yml`                      | `automation/Catzc.Base.Languages/Invoke-GoTest.ps1`             | provided                | command contract | `Module: string!, EntryScript: string, GoExecutable: string, Engine: string, EngineExecutable: string -> Catzc.Base.Languages.GoTestResult`                 |
| `Catzc.Base.Languages`    | `Invoke-PythonTest.command.yml`                  | `automation/Catzc.Base.Languages/Invoke-PythonTest.ps1`         | provided                | command contract | `Module: string!, EntryScript: string, UvExecutable: string, Engine: string, EngineExecutable: string -> Catzc.Base.Languages.PythonTestResult`             |
| `Catzc.Base.Languages`    | `New-GoWorkspace.command.yml`                    | `automation/Catzc.Base.Languages/New-GoWorkspace.ps1`           | provided                | command contract | `Target: string = * -> Catzc.Base.Languages.GoWorkspaceFile`                                                                                                |
| `Catzc.Base.Languages`    | `New-PythonProject.command.yml`                  | `automation/Catzc.Base.Languages/New-PythonProject.ps1`         | provided                | command contract | `Target: string = * -> Catzc.Base.Languages.PythonWorkspaceFile`                                                                                            |
| `Catzc.Base.Languages`    | `Test-GeneratedFileCurrent.command.yml`          | `automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1` | provided                | command contract | `Path: string!, InputsSha: string! -> bool`                                                                                                                 |
| `Catzc.Base.QualityGates` | `head.sample.yml`                                | none                                                            | provided                | sample payload   | none                                                                                                                                                        |
| `Catzc.Base.QualityGates` | `head.schema.json`                               | `contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.sample.yml` | provided                | schema           | none                                                                                                                                                        |
| `Catzc.Tooling.Github`    | `README.md`                                      | `.github/README.md`                                             | depended-on             | presence         | none                                                                                                                                                        |
| `Catzc.Tooling.Github`    | `workflows/ci-automation.yml`                    | `.github/workflows/ci-automation.yml`                           | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Tooling.Github`    | `workflows/release-automation.yml`               | `.github/workflows/release-automation.yml`                      | depended-on             | fragment         | none                                                                                                                                                        |
| `Catzc.Tooling.Node`      | `Install-Cspell.command.yml`                     | `automation/Catzc.Tooling.Node/Install-Cspell.ps1`              | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Node`      | `Install-Markdownlint.command.yml`               | `automation/Catzc.Tooling.Node/Install-Markdownlint.ps1`        | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Node`      | `Install-NodeJs.command.yml`                     | `automation/Catzc.Tooling.Node/Install-NodeJs.ps1`              | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Node`      | `Install-Prettier.command.yml`                   | `automation/Catzc.Tooling.Node/Install-Prettier.ps1`            | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Python`    | `Install-Poetry.command.yml`                     | `automation/Catzc.Tooling.Python/Install-Poetry.ps1`            | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Python`    | `Install-PySpark.command.yml`                    | `automation/Catzc.Tooling.Python/Install-PySpark.ps1`           | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Python`    | `Install-Python.command.yml`                     | `automation/Catzc.Tooling.Python/Install-Python.ps1`            | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-AzCli.command.yml`                      | `automation/Catzc.Tooling.Toolchain/Install-AzCli.ps1`          | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Bicep.command.yml`                      | `automation/Catzc.Tooling.Toolchain/Install-Bicep.ps1`          | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Dotnet.command.yml`                     | `automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1`         | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Go.command.yml`                         | `automation/Catzc.Tooling.Toolchain/Install-Go.ps1`             | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Java.command.yml`                       | `automation/Catzc.Tooling.Toolchain/Install-Java.ps1`           | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Shellcheck.command.yml`                 | `automation/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1`     | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Terraform.command.yml`                  | `automation/Catzc.Tooling.Toolchain/Install-Terraform.ps1`      | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |
| `Catzc.Tooling.Toolchain` | `Install-Uv.command.yml`                         | `automation/Catzc.Tooling.Toolchain/Install-Uv.ps1`             | provided                | command contract | `Version: string, Force: switch`                                                                                                                            |

Notes:

- `Catzc.Azure.DevOps/pipelines/cd-apex.yaml`: Depended-on fragment of pipelines/cd-apex.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value pins only that the key
  exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-flux.yaml`: Depended-on fragment of pipelines/cd-flux.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value pins only that the key
  exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-nova.yaml`: Depended-on fragment of pipelines/cd-nova.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value pins only that the key
  exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/cd-shared.yaml`: Depended-on fragment of pipelines/cd-shared.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, and the `stages` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-automation-expected-failures.yaml`: Depended-on fragment of
  pipelines/ci-automation-expected-failures.yaml ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)):
  what Azure Pipelines reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key
  exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-automation.yaml`: Depended-on fragment of pipelines/ci-automation.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Azure.DevOps/pipelines/ci-infrastructure.yaml`: Depended-on fragment of pipelines/ci-infrastructure.yaml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): what Azure Pipelines reads at the pipeline root —
  the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `Catzc.Base.Contracts/Build-ContractReference.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Build-ContractReference, the generator of the contract reference pages. RepositoryRoot defaults to the repository root, a computed default
  the contract does not restate.
- `Catzc.Base.Contracts/Get-CommandContract.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1 and #5): the call interface of
  Get-CommandContract, the one reader of command contracts. RepositoryRoot defaults to the repository root, a computed default the contract
  does not restate.
- `Catzc.Base.Contracts/Get-ContractCheckResults.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Get-ContractCheckResults, the per-asset contract check; the assets arrive by parameter or from the pipeline. RepositoryRoot defaults to
  the repository root, a computed default the contract does not restate.
- `Catzc.Base.Contracts/Publish-ContractRelease.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1 and #6): the call interface
  of Publish-ContractRelease, which freezes the draft contracts of a unit as a released version folder. RepositoryRoot defaults to the
  repository root, a computed default the contract does not restate.
- `Catzc.Base.Globs/configs/file-kinds.yml`: Provided fragment of automation/Catzc.Base.Globs/configs/file-kinds.yml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): the kinds and subkinds a consumer may rely on to
  be in the file-kinds registry, so the `kind` and `subkind` a file's meta head names keep their meaning. A null value pins only that the
  key exists; the definitions and the globs may change, and a consumer extends the registry with a config fragment of its own.
- `Catzc.Base.Languages/Get-FileLanguage.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Get-FileLanguage, the file-language reader. One of Name (the languages by name) or Path (the language of one file) is given; the command's
  two parameter sets make each mandatory.
- `Catzc.Base.Languages/Get-PathFileType.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Get-PathFileType, which names the file type a path resolves to through the file-language registry.
- `Catzc.Base.Languages/Invoke-BashTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Invoke-BashTest, the bash test runner of one module.
- `Catzc.Base.Languages/Invoke-GoTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of Invoke-GoTest,
  the Go test runner of one module. Engine defaults to the pwsh engine of the engine registry, a computed default the contract does not
  restate.
- `Catzc.Base.Languages/Invoke-PythonTest.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Invoke-PythonTest, the Python test runner of one module. Engine defaults to the pwsh engine of the engine registry, a computed default the
  contract does not restate.
- `Catzc.Base.Languages/New-GoWorkspace.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  New-GoWorkspace, the go.work generator; Target selects the verification modules it renders for, every one by default.
- `Catzc.Base.Languages/New-PythonProject.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  New-PythonProject, the pyproject generator; Target selects the verification modules it renders for, every one by default.
- `Catzc.Base.Languages/Test-GeneratedFileCurrent.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Test-GeneratedFileCurrent, which says whether a generated file's head carries the given inputs stamp.
- `Catzc.Base.QualityGates/head.sample.yml`: Provided sample of a file's meta head
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): the shape a tool may rely on when it reads the
  `catzc.immutable` and `catzc.edges` parts of a head, written by Format-FileMeta in the carrier of the file (a comment head, or Markdown
  front matter). Every key is optional except `path` and `kind`, and a fact a file has no value for is left out. Its schema,
  head.schema.json, lists the keys.
- `Catzc.Base.QualityGates/head.schema.json`: Provided schema of a file's meta head, validated against the sample beside it
  (ADR-REPO-CONTRACT#6): the keys of catzc.immutable (the place facts) and catzc.edges (the outgoing edges), which a tool may rely on. A
  fact a file has no value for is left out, so only path and kind are required.
- `Catzc.Tooling.Github/workflows/ci-automation.yml`: Depended-on fragment of .github/workflows/ci-automation.yml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): the keys GitHub Actions requires to run the
  workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only that the key exists.
  Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `Catzc.Tooling.Github/workflows/release-automation.yml`: Depended-on fragment of .github/workflows/release-automation.yml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): the keys GitHub Actions requires to run the
  workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only that the key exists.
  Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `Catzc.Tooling.Node/Install-Cspell.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of Install-Cspell,
  which installs cspell. Version defaults to the version tools.yml locks for 'cspell', a computed default the contract does not restate;
  Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-Markdownlint.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Markdownlint, which installs markdownlint. Version defaults to the version tools.yml locks for 'markdownlint', a computed default
  the contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-NodeJs.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of Install-NodeJs,
  which installs Node.js. Version defaults to the version tools.yml locks for 'node_js', a computed default the contract does not restate;
  Force reinstalls over a present install.
- `Catzc.Tooling.Node/Install-Prettier.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Prettier, which installs Prettier. Version defaults to the version tools.yml locks for 'prettier', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Install-Poetry.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Poetry, which installs Poetry. Version defaults to the version tools.yml locks for 'poetry', a computed default the contract does
  not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Install-PySpark.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-PySpark, which installs PySpark. Version defaults to the version tools.yml locks for 'py_spark', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Python/Install-Python.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Python, which installs Python. Version defaults to the version tools.yml locks for 'python', a computed default the contract does
  not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-AzCli.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-AzCli, which installs the Azure CLI. Version defaults to the version tools.yml locks for 'az_cli', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Bicep.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Bicep, which installs the Bicep CLI. Version defaults to the version tools.yml locks for 'bicep', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Dotnet.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Dotnet, which installs the .NET SDK. Version defaults to the version tools.yml locks for 'dotnet', a computed default the contract
  does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Go.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of Install-Go,
  which installs Go. Version defaults to the version tools.yml locks for 'go', a computed default the contract does not restate; Force
  reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Java.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Java, which installs Java. Version defaults to the version tools.yml locks for 'java', a computed default the contract does not
  restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Shellcheck.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Shellcheck, which installs ShellCheck. Version defaults to the version tools.yml locks for 'shellcheck', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Terraform.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of
  Install-Terraform, which installs Terraform. Version defaults to the version tools.yml locks for 'terraform', a computed default the
  contract does not restate; Force reinstalls over a present install.
- `Catzc.Tooling.Toolchain/Install-Uv.command.yml`: Provided command contract (ADR-REPO-CMDCONTRACT#1): the call interface of Install-Uv,
  which installs uv. Version defaults to the version tools.yml locks for 'uv', a computed default the contract does not restate; Force
  reinstalls over a present install.
