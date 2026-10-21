# pwsh/Catzc.Base.Contracts/private/Get-ContractPresenceFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks that a contract asset's target file exists with the exact case of its path, and returns the findings.

### description

The presence check of [ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset),
which every fragment and schema check runs first. An outside platform reads the path as written, and a case-insensitive file system
(Windows, the default macOS volume) would find a file whose case differs, so the path is walked one segment at a time against the directory
listing and each segment compares ordinally. A segment that exists only in another case, a missing segment, a folder where the file belongs,
and a file where a folder belongs are each one finding naming the path; a present file gives none.

### parameter `RepositoryRoot`

The repository root the path is relative to.

### parameter `Path`

The target, repository-relative and '/'-separated.

### outputs

`[string[]]` The findings; none when the file is present.

### example 1

```powershell
Get-ContractPresenceFindings -RepositoryRoot $root -Path '.widget/flows/build.yml'
```
