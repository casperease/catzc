# pwsh/Base.Contracts/private/Get-ContractDescriptionFindings.ps1

The description check of a contract asset. It makes the asset's own header say what it guarantees, in one plain sentence that matches the
command's synopsis where there is one.

## help

### synopsis

Checks a contract asset's description: present, one plain sentence, and equal to its command's synopsis where it has one.

### description

A contract states only what it guarantees, in its own header
([ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-headersayswhatitpins)). A
missing description is one finding. A present one must be a plain scalar (PlainText.PlainScalarFinding), and when a synopsis is given the
description must equal it as plain text, so a command contract and the command's help say the same. A JSON schema has no synopsis, so its
`$comment` is checked for form only.

### parameter `AssetPath`

The contract asset the description belongs to, named in each finding.

### parameter `Key`

The key that holds the description in the asset: `description` in a YAML contract, `$comment` in a JSON schema.

### parameter `Description`

The description as the asset holds it; empty when the asset has none.

### parameter `Synopsis`

The command's help synopsis, when the contract has one to equal; a schema has none, so its check is form only.

### outputs

`[string[]]` One finding per fault, each naming the asset and the key; none for a good description.

### example 1

```powershell
Get-ContractDescriptionFindings -AssetPath $asset.AssetPath -Key description -Description $contract.description -Synopsis $synopsis
```
