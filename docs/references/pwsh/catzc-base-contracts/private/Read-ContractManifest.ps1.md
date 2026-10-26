# pwsh/Base.Contracts/private/Read-ContractManifest.ps1

The reader of a version folder's contract.yml, the manifest of direction overrides and applies_to entries. A folder without one has an empty
manifest.

## help

### synopsis

Reads a version folder's contract.yml, the direction overrides of its assets.

### description

The per-version manifest of
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention) sits at
`contracts/<unit>/<version>/contract.yml`. Most version folders carry none, so an absent file is an empty manifest. The ContractManifest
type validates what it reads and throws on a malformed file.

### parameter `Folder`

The version folder's absolute path.

### outputs

`[Catzc.Base.Contracts.ContractManifest]`

### example 1

```powershell
(Read-ContractManifest -Folder $versionFolder).direction
```
