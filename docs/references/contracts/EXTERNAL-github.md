---
catzc:
  immutable:
    warning: "Do Not Edit, this file is generated"
---

# docs/references/contracts/EXTERNAL-github.md

`The EXTERNAL-github contracts`

The contract assets of the `EXTERNAL-github` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/EXTERNAL-github/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../drs/repository/api-contracts.md); command contracts:
[command-contracts](../../drs/repository/command-contracts.md).

## 0.0.0

The draft: the one mutable version folder
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).

| Module                 | Asset                                | Target                                     | Direction   | Kind   | Signature |
| ---------------------- | ------------------------------------ | ------------------------------------------ | ----------- | ------ | --------- |
| `Catzc.Tooling.Github` | `workflows/workflow.yml.schema.json` | `.github/workflows/ci-pwsh.yml`            | depended-on | schema | none      |
| `Catzc.Tooling.Github` | `workflows/workflow.yml.schema.json` | `.github/workflows/release-automation.yml` | depended-on | schema | none      |

Notes:

- `Catzc.Tooling.Github/workflows/workflow.yml.schema.json`: Depended-on schema of a GitHub Actions workflow
  (ADR-REPO-CONTRACT-CONTRACTASSET): the shape GitHub reads, kept local so an editor and a gate need no download. vendor: github. source:
  <https://json.schemastore.org/github-workflow.json> (the full schema validates every job and step through patternProperties and oneOf,
  outside the bounded subset of ContractSchema), trimmed to the top-level shape: jobs is required and every known top-level key has its
  type. A job, keyed by its own name, is not checked here. It applies to every workflow file through contract.yml's applies_to. Taken
  2026-10-25.
- `Catzc.Tooling.Github/workflows/workflow.yml.schema.json`: Depended-on schema of a GitHub Actions workflow
  (ADR-REPO-CONTRACT-CONTRACTASSET): the shape GitHub reads, kept local so an editor and a gate need no download. vendor: github. source:
  <https://json.schemastore.org/github-workflow.json> (the full schema validates every job and step through patternProperties and oneOf,
  outside the bounded subset of ContractSchema), trimmed to the top-level shape: jobs is required and every known top-level key has its
  type. A job, keyed by its own name, is not checked here. It applies to every workflow file through contract.yml's applies_to. Taken
  2026-10-25.
