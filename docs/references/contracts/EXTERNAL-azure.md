---
catzc:
  immutable:
    with_body_sha: "4f1c4e5b8c4b"
    with_inputs_sha: "29715d9a930ba7085d678fca27787da361860218dc70ede131a6353d9b0ce9c7"
    repo_status: locked
    path: docs/references/contracts/EXTERNAL-azure.md
    source: contracts/EXTERNAL-azure
    role: reference
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
    generator: pwsh/Catzc.Base.Contracts/Build-ContractReference.ps1
---

# docs/references/contracts/EXTERNAL-azure.md

`The EXTERNAL-azure contracts`

The contract assets of the `EXTERNAL-azure` unit: one table per version folder, then the notes of its assets.

`Build-ContractReference` writes this page from `contracts/EXTERNAL-azure/`: edit an asset or its header comment, never this page.

Each note is the asset's own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.

A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.

A command contract's signature is the call interface its contract language states, as `Get-CommandContract` reads it; every other kind has
none.

Layout, kinds, and directions: [api-contracts](../../adr/repository/api-contracts.md); command contracts:
[command-contracts](../../adr/repository/command-contracts.md).

## 0.0.0

The draft: the one mutable version folder ([ADR-REPO-CONTRACT#5](../../adr/repository/api-contracts.md#rule-adr-repo-contract5)).

| Module                  | Asset                                                | Target                                                              | Direction   | Kind   | Signature |
| ----------------------- | ---------------------------------------------------- | ------------------------------------------------------------------- | ----------- | ------ | --------- |
| `Catzc.Azure.Templates` | `tests/assets/parameter-model/main.json.schema.json` | `pwsh/Catzc.Azure.Templates/tests/assets/parameter-model/main.json` | depended-on | schema | none      |

Notes:

- `Catzc.Azure.Templates/tests/assets/parameter-model/main.json.schema.json`: Depended-on schema of a compiled ARM template
  (ADR-REPO-CONTRACT#6): the skeleton Azure Resource Manager reads, kept local so an editor and a gate need no download. vendor: azure.
  source: <https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json> (the full schema, 186 KB, refs hundreds of
  per-API-version resource schemas and uses oneOf/anyOf/allOf, outside the bounded subset of ContractSchema), trimmed to the top-level
  shape. Only the top-level sections are checked, never a resource body. Taken 2026-10-17.

## 0.1.0

Released, so frozen by its `.frozen` record ([ADR-REPO-CONTRACT#5](../../adr/repository/api-contracts.md#rule-adr-repo-contract5)).

| Module                  | Asset                                                | Target                                                              | Direction   | Kind   | Signature |
| ----------------------- | ---------------------------------------------------- | ------------------------------------------------------------------- | ----------- | ------ | --------- |
| `Catzc.Azure.Templates` | `tests/assets/parameter-model/main.json.schema.json` | `pwsh/Catzc.Azure.Templates/tests/assets/parameter-model/main.json` | depended-on | schema | none      |

Notes:

- `Catzc.Azure.Templates/tests/assets/parameter-model/main.json.schema.json`: Depended-on schema of a compiled ARM template
  (ADR-REPO-CONTRACT#6): the skeleton Azure Resource Manager reads, kept local so an editor and a gate need no download. vendor: azure.
  source: <https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json> (the full schema, 186 KB, refs hundreds of
  per-API-version resource schemas and uses oneOf/anyOf/allOf, outside the bounded subset of ContractSchema), trimmed to the top-level
  shape. Only the top-level sections are checked, never a resource body. Taken 2026-10-17.
