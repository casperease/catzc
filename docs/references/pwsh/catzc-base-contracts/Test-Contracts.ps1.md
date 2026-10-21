# pwsh/Catzc.Base.Contracts/Test-Contracts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the repository honours every binding contract asset, every released version folder is unchanged, and contracts/ holds no
dot-prefixed folder.

### description

Contracts are binding, proven by tests
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)). A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) that checks three things.

The binding assets. Each is checked by its kind with Get-ContractCheckResults
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)):

- every asset, in both directions, of each unit's current version folder, -Version;
- the provided assets of every other released version folder still in the tree. Released folders are the pin record: a version folder is
  kept while a consumer pins it, and retiring it means deleting the folder
  ([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)). Their depended-on
  assets are not checked: a depended-on contract follows its outside platform, so only the current version's binds.

Every finding is one issue naming the asset, its kind and direction, 'pinned' for an asset of an older release, and the finding.

The freeze. Every version folder other than 0.0.0 is released, so immutable
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)): its files must
match the .frozen record Publish-ContractRelease wrote when it froze the draft. A missing record, and each file changed, added or removed
since, is one issue.

The layout. contracts/ holds no dot-prefixed folder at any depth
([ADR-REPO-CONTRACT-NODOTFOLDERS](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders)): an asset whose target sits
under a dot-prefixed root reaches it through its module's target root
([ADR-REPO-CONTRACT-LAYOUT](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)). Each outermost dot-prefixed folder is
one issue (Get-ContractDotFolderFindings); a dot-prefixed file name, such as the .frozen record, is not.

The current version folder is the draft, 0.0.0, on a devbox and in every build before a release. A release build freezes the draft with
Publish-ContractRelease and then passes the resolved version with -Version; a named release that a unit holds no folder for is one issue, so
the gate never passes over a release it did not check. A contracts/ tree that does not list (a malformed version folder, a file outside a
module folder, a contract.yml entry naming no asset) is one issue. No assets at all is a clean pass. The gate reads files only: no git, no
build.

It ends through Write-QualityGateReport: the report goes to out/test-contracts/, every issue is printed, and the quality gate throws once
listing them all; -PassThru returns the result instead.

### parameter `Version`

The current version folder of every unit, `<major>.<minor>.<patch>`. Default: 0.0.0, each unit's draft.

### parameter `RepositoryRoot`

The repository root that holds contracts/ and the files the assets constrain. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-contracts/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Version; Assets; PinnedAssets; FailedAssets; ReleasedFolders }) instead of
throwing on issues. Assets counts every checked asset, PinnedAssets those of older releases among them.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-Contracts
```

### example 2

```powershell
Test-Contracts -Version 0.1.427
```

### example 3

```powershell
(Test-Contracts -PassThru).Issues
```
