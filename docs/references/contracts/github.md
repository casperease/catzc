---
catzc:
  immutable:
    warning: "Do Not Edit, this file is generated"
---

# docs/references/contracts/github.md

`The github contracts`

The contract assets of the `github` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/github/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../drs/repository/api-contracts.md); command contracts:
[command-contracts](../../drs/repository/command-contracts.md).

## 0.1.0

The current version: edited in place
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).

| Module      | Asset                      | Target                                     | Direction   | Kind     | Signature |
| ----------- | -------------------------- | ------------------------------------------ | ----------- | -------- | --------- |
| ``          | `README.md`                | `.github/README.md`                        | depended-on | presence | none      |
| `workflows` | `ci-pwsh.yml`              | `.github/workflows/ci-pwsh.yml`            | depended-on | fragment | none      |
| `workflows` | `release-automation.yml`   | `.github/workflows/release-automation.yml` | depended-on | fragment | none      |
| `workflows` | `workflow.yml.schema.json` | `.github/workflows/ci-pwsh.yml`            | depended-on | schema   | none      |
| `workflows` | `workflow.yml.schema.json` | `.github/workflows/release-automation.yml` | depended-on | schema   | none      |

Notes:

- `workflows/ci-pwsh.yml`: Depended-on fragment of .github/workflows/ci-pwsh.yml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the keys GitHub Actions
  requires to run the workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only
  that the key exists. Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `workflows/release-automation.yml`: Depended-on fragment of .github/workflows/release-automation.yml
  ([ADR-REPO-CONTRACT-CONTRACTASSET](../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the keys GitHub Actions
  requires to run the workflow — the `on` events, and `jobs`, each job with the `runs-on` runner and its `steps`. A null value pins only
  that the key exists. Source: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>
- `workflows/workflow.yml.schema.json`: Depended-on schema of a GitHub Actions workflow (ADR-REPO-CONTRACT-CONTRACTASSET): the shape GitHub
  reads, kept local so an editor and a gate need no download. vendor: github. source: <https://json.schemastore.org/github-workflow.json>
  (the full schema validates every job and step through patternProperties and oneOf, outside the bounded subset of ContractSchema), trimmed
  to the top-level shape: jobs is required and every known top-level key has its type. A job, keyed by its own name, is not checked here. It
  applies to every workflow file through contract.yml's applies_to. Taken 2026-10-25.
- `workflows/workflow.yml.schema.json`: Depended-on schema of a GitHub Actions workflow (ADR-REPO-CONTRACT-CONTRACTASSET): the shape GitHub
  reads, kept local so an editor and a gate need no download. vendor: github. source: <https://json.schemastore.org/github-workflow.json>
  (the full schema validates every job and step through patternProperties and oneOf, outside the bounded subset of ContractSchema), trimmed
  to the top-level shape: jobs is required and every known top-level key has its type. A job, keyed by its own name, is not checked here. It
  applies to every workflow file through contract.yml's applies_to. Taken 2026-10-25.
