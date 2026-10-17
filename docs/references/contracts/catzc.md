---
catzc:
  immutable:
    with_body_sha: "46f74ef082ae"
    with_inputs_sha: c4f25d3e471274bf326f4c9cab6c8354bb82a6c79d921bfd29a3cc6fcf33bde4
    repo_status: locked
    path: docs/references/contracts/catzc.md
    source: contracts/catzc
    kind: reference
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

Layout, kinds, and directions: [api-contracts](../../adr/repository/api-contracts.md).

## 0.0.0

The draft: the one mutable version folder ([ADR-REPO-CONTRACT#5](../../adr/repository/api-contracts.md#rule-adr-repo-contract5)).

| Module                    | Asset                                            | Target                                                          | Direction               | Kind           |
| ------------------------- | ------------------------------------------------ | --------------------------------------------------------------- | ----------------------- | -------------- |
| `Catzc.Azure.DevOps`      | `pipelines/cd-apex.yaml`                         | `pipelines/cd-apex.yaml`                                        | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/cd-flux.yaml`                         | `pipelines/cd-flux.yaml`                                        | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/cd-nova.yaml`                         | `pipelines/cd-nova.yaml`                                        | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/cd-shared.yaml`                       | `pipelines/cd-shared.yaml`                                      | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/ci-automation-expected-failures.yaml` | `pipelines/ci-automation-expected-failures.yaml`                | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/ci-automation.yaml`                   | `pipelines/ci-automation.yaml`                                  | depended-on             | fragment       |
| `Catzc.Azure.DevOps`      | `pipelines/ci-infrastructure.yaml`               | `pipelines/ci-infrastructure.yaml`                              | depended-on             | fragment       |
| `Catzc.Base.Globs`        | `configs/file-kinds.yml`                         | `automation/Catzc.Base.Globs/configs/file-kinds.yml`            | provided (contract.yml) | fragment       |
| `Catzc.Base.QualityGates` | `head.sample.yml`                                | none                                                            | provided                | sample payload |
| `Catzc.Base.QualityGates` | `head.schema.json`                               | `contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.sample.yml` | provided                | schema         |
| `Catzc.Tooling.Github`    | `README.md`                                      | `.github/README.md`                                             | depended-on             | presence       |
| `Catzc.Tooling.Github`    | `workflows/ci-automation.yml`                    | `.github/workflows/ci-automation.yml`                           | depended-on             | fragment       |
| `Catzc.Tooling.Github`    | `workflows/release-automation.yml`               | `.github/workflows/release-automation.yml`                      | depended-on             | fragment       |

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
- `Catzc.Base.Globs/configs/file-kinds.yml`: Provided fragment of automation/Catzc.Base.Globs/configs/file-kinds.yml
  ([ADR-REPO-CONTRACT#6](../../adr/repository/api-contracts.md#rule-adr-repo-contract6)): the kinds and subkinds a consumer may rely on to
  be in the file-kinds registry, so the `kind` and `subkind` a file's meta head names keep their meaning. A null value pins only that the
  key exists; the definitions and the globs may change, and a consumer extends the registry with a config fragment of its own.
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
