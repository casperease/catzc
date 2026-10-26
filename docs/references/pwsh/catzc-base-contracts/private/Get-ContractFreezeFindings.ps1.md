# pwsh/Base.Contracts/private/Get-ContractFreezeFindings.ps1

The freeze check of one released version folder. It compares the folder's files with the .frozen record, so a released contract cannot
change unnoticed.

## help

### synopsis

Checks that one released contract version folder still holds exactly what its release froze.

### description

A released version folder is immutable
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).
Publish-ContractRelease freezes it with a .frozen record, one line per file, '`<sha256>` `<path>`', after '#' comment lines; this compares
the record with the folder's files as Get-ContractFileHashes hashes them now, and returns one finding per defect: a missing record, a
malformed or repeated record line, and every file changed, added or removed since the freeze. No finding means the folder is intact. The
current version, 0.1.0, is never frozen, so it is never given here.

### parameter `Folder`

The released version folder's absolute path.

### parameter `Name`

The folder in communication form, `contracts/<unit>/<version>`, used in every finding.

### outputs

`[string[]]` The findings; none when the folder is intact.

### example 1

```powershell
Get-ContractFreezeFindings -Folder $versionFolder -Name contracts/widget/1.0.0
```
