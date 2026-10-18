# automation/Catzc.Base.Contracts/private/Read-ContractManifest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a version folder's contract.yml, the direction overrides of its assets.

### description

The per-version manifest of [ADR-REPO-CONTRACT#7](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract7) sits at
`contracts/<unit>/<version>/contract.yml`. Most version folders carry none, so an absent file is an empty manifest. The ContractManifest
type validates what it reads and throws on a malformed file.

### parameter Folder

The version folder's absolute path.

### outputs

`[Catzc.Base.Contracts.ContractManifest]`

### example 1

```powershell
(Read-ContractManifest -Folder $versionFolder).direction
```
