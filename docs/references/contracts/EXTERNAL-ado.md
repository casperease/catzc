---
catzc:
  immutable:
    with_body_sha: ad0d4939392a
    warning: "Do Not Edit, this file is generated"
---

# docs/references/contracts/EXTERNAL-ado.md

`The EXTERNAL-ado contracts`

The contract assets of the `EXTERNAL-ado` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/EXTERNAL-ado/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../drs/repository/api-contracts.md); command contracts:
[command-contracts](../../drs/repository/command-contracts.md).

## 0.0.0

The draft: the one mutable version folder
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).

| Module               | Asset                                 | Target                                                | Direction   | Kind   | Signature |
| -------------------- | ------------------------------------- | ----------------------------------------------------- | ----------- | ------ | --------- |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-apex.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-flux.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-nova.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-shared.yaml`                       | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-infrastructure.yaml`               | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-pwsh-expected-failures.yaml`       | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-pwsh.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-apex.yaml`                     | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-nova.yaml`                     | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-shared.yaml`                   | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/extends/cd-customer.yaml`             | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/stages/deploy-unit.yaml`              | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/assert-deployment-history.yaml` | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/download-artifact.yaml`         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/invoke-automation.yaml`         | depended-on | schema | none      |

Notes:

- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.

## 0.1.0

Released, so frozen by its `.frozen` record
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).

| Module               | Asset                                 | Target                                                | Direction   | Kind   | Signature |
| -------------------- | ------------------------------------- | ----------------------------------------------------- | ----------- | ------ | --------- |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-apex.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-flux.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-nova.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/cd-shared.yaml`                       | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-infrastructure.yaml`               | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-pwsh-expected-failures.yaml`       | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/ci-pwsh.yaml`                         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-apex.yaml`                     | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-nova.yaml`                     | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/deploy-shared.yaml`                   | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/extends/cd-customer.yaml`             | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/stages/deploy-unit.yaml`              | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/assert-deployment-history.yaml` | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/download-artifact.yaml`         | depended-on | schema | none      |
| `Catzc.Azure.DevOps` | `pipelines/pipeline.yaml.schema.json` | `.ado/pipelines/steps/invoke-automation.yaml`         | depended-on | schema | none      |

Notes:

- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Azure.DevOps/pipelines/pipeline.yaml.schema.json`: Depended-on schema of an Azure Pipelines file (ADR-REPO-CONTRACT-CONTRACTASSET):
  the shape Azure DevOps reads, kept local so an editor and a gate need no download. vendor: ado. source:
  <https://github.com/microsoft/azure-pipelines-vscode> service-schema.json (the full schema models a step's task as one anyOf branch per
  known task version, which offline reports every branch that does not match), trimmed to the top-level shape, the container types, and one
  loose step whose task is Name@Major or a template expression. It applies to every pipeline file through contract.yml's applies_to. Taken
  2026-10-25.
