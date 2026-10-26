# pwsh/Base.Contracts/private/Get-ContractLayoutFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every version folder under contracts/ that the layout forbids, one finding each.

### description

The current version 0.1.0 and the catzc releases from 1.0.0 up are the only version folders a root may hold
([ADR-REPO-CONTRACT-CURRENTVERSION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-currentversion)). A finding names the
devbox build version (exporter.yml direct_install_version), any other 0.x version such as 0.0.0, and a release folder under a vendor root,
which follows its vendor in the current version instead
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)). A repository with
no contracts folder has no findings.

### parameter `RepositoryRoot`

The repository root that holds contracts/.

### outputs

`[string[]]` One finding per forbidden version folder.

### example 1

```powershell
Get-ContractLayoutFindings -RepositoryRoot $root
```
