# pwsh/Base.Contracts/private/Get-ContractAssetKind.ps1

The classifier of a contract asset by its file name. Because the name alone decides the kind, no registry says what an asset is.

## help

### synopsis

Picks a contract asset's kind from its file name alone.

### description

The name rule of [ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset):
`<Verb-Noun>.command.yml` is a Command
([ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract)),
`<path>.schema.json` is a Schema, `<name>.sample.<ext>` is a Sample, and any other name is a Fragment, or a Presence when the asset is empty
(an empty fragment requires presence only). The command suffix needs a Verb-Noun stem, and the suffixes are checked before emptiness, so an
empty command contract is still a command contract and a schema is never read as a sample.

### parameter `Name`

The asset's file name (its last path segment).

### parameter `IsEmpty`

The asset holds nothing but whitespace.

### outputs

`[Catzc.Base.Contracts.ContractAssetKind]`

### example 1

```powershell
Get-ContractAssetKind -Name 'build.yml.schema.json'   # Schema
```
