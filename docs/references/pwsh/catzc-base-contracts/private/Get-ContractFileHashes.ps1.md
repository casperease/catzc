# pwsh/Base.Contracts/private/Get-ContractFileHashes.ps1

The hasher of a version folder: one hash per file, the same way when a release is frozen and when the freeze is checked.

## help

### synopsis

Hashes every file of one contract version folder, the content a release freezes.

### description

A released version folder is immutable
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)); its .frozen
record holds the hashes this returns, so a later change to any file shows as a different hash. Every file under the folder counts, at any
depth, contract.yml included; only the record itself, .frozen directly in the folder, does not.

Each hash is the SHA-256 of the file's bytes with every CRLF read as LF. Contract assets are text, and a checkout with core.autocrlf
materialises them with CRLF while another checkout of the same commit has LF; reading line endings as LF gives every checkout of one commit
the same hashes.

### parameter `Folder`

The version folder's absolute path.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The path under the folder, in communication form
([ADR-AUTO-PATH-COMMUNICATIONFORM](../../../../drs/automation/path-representation.md#rule-adr-auto-path-communicationform)), to its
lowercase hex SHA-256, in ordinal order of path; keys compare ordinally.

### example 1

```powershell
Get-ContractFileHashes -Folder $versionFolder
```

## the walk is whole

A frozen contract is hashed in full, so the walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): no name is pruned
and no depth drops a file.
