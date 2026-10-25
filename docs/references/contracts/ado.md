---
catzc:
  immutable:
    with_body_sha: "1d8ec3e89e3a"
    warning: "Do Not Edit, this file is generated"
---

# docs/references/contracts/ado.md

`The ado contracts`

The contract assets of the `ado` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/ado/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../drs/repository/api-contracts.md); command contracts:
[command-contracts](../../drs/repository/command-contracts.md).

## 0.1.0

The current version: edited in place
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).

| Module      | Asset                            | Target                                                | Direction   | Kind     | Signature |
| ----------- | -------------------------------- | ----------------------------------------------------- | ----------- | -------- | --------- |
| `pipelines` | `cd-apex.yaml`                   | `.ado/pipelines/cd-apex.yaml`                         | depended-on | fragment | none      |
| `pipelines` | `cd-flux.yaml`                   | `.ado/pipelines/cd-flux.yaml`                         | depended-on | fragment | none      |
| `pipelines` | `cd-nova.yaml`                   | `.ado/pipelines/cd-nova.yaml`                         | depended-on | fragment | none      |
| `pipelines` | `cd-shared.yaml`                 | `.ado/pipelines/cd-shared.yaml`                       | depended-on | fragment | none      |
| `pipelines` | `ci-infrastructure.yaml`         | `.ado/pipelines/ci-infrastructure.yaml`               | depended-on | fragment | none      |
| `pipelines` | `ci-pwsh-expected-failures.yaml` | `.ado/pipelines/ci-pwsh-expected-failures.yaml`       | depended-on | fragment | none      |
| `pipelines` | `ci-pwsh.yaml`                   | `.ado/pipelines/ci-pwsh.yaml`                         | depended-on | fragment | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/cd-apex.yaml`                         | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/cd-flux.yaml`                         | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/cd-nova.yaml`                         | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/cd-shared.yaml`                       | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/ci-infrastructure.yaml`               | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/ci-pwsh-expected-failures.yaml`       | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/ci-pwsh.yaml`                         | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/deploy-apex.yaml`                     | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/deploy-nova.yaml`                     | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/deploy-shared.yaml`                   | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/extends/cd-customer.yaml`             | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/stages/deploy-unit.yaml`              | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/steps/assert-deployment-history.yaml` | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/steps/cache-types.yaml`               | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/steps/download-artifact.yaml`         | depended-on | schema   | none      |
| `pipelines` | `pipeline.yaml.schema.json`      | `.ado/pipelines/steps/invoke-automation.yaml`         | depended-on | schema   | none      |

Notes:

- `pipelines/cd-apex.yaml`: Depended-on fragment of .ado/pipelines/cd-apex.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/cd-flux.yaml`: Depended-on fragment of .ado/pipelines/cd-flux.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/cd-nova.yaml`: Depended-on fragment of .ado/pipelines/cd-nova.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, honoured only there, and the `extends` root with its `template`. A null value
  pins only that the key exists. Source: <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/cd-shared.yaml`: Depended-on fragment of .ado/pipelines/cd-shared.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `stages` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/ci-infrastructure.yaml`: Depended-on fragment of .ado/pipelines/ci-infrastructure.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/ci-pwsh-expected-failures.yaml`: Depended-on fragment of .ado/pipelines/ci-pwsh-expected-failures.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/ci-pwsh.yaml`: Depended-on fragment of .ado/pipelines/ci-pwsh.yaml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): what Azure Pipelines
  reads at the pipeline root — the `trigger` and `pr` blocks, and the `jobs` root. A null value pins only that the key exists. Source:
  <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline>
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET): the shape Azure
  DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
