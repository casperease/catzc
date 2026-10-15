---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Test-Contracts.ps1.md
    kind: reference
    body_sha: "3dc49276338d"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-CONTRACT#10
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#3
      - ADR-REPO-CONTRACT#4
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/Test-Contracts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Contracts are binding, proven by tests
([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)). A quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) that checks three things.

The binding assets. Each is checked by its kind with Get-ContractCheckResults
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
- every asset, in both directions, of each unit's current version folder, -Version;
- the provided assets of every other released version folder still in the tree. Released folders are the pin
  record: a version folder is kept while a consumer pins it, and retiring it means deleting the folder
  ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)). Their depended-on assets
  are not checked: a depended-on contract follows its outside platform, so only the current version's binds.
Every finding is one issue naming the asset, its kind and direction, 'pinned' for an asset of an older release,
and the finding.

The freeze. Every version folder other than 0.0.0 is released, so immutable
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)): its files must match the
.frozen record Publish-ContractRelease wrote when it froze the draft. A missing record, and each file changed,
added or removed since, is one issue.

The layout. contracts/ holds no dot-prefixed folder at any depth
([ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)): an asset whose target sits
under a dot-prefixed root reaches it through its module's target root
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). Each outermost dot-prefixed
folder is one issue (Get-ContractDotFolderFindings); a dot-prefixed file name, such as the .frozen record, is not.

The current version folder is the draft, 0.0.0, on a devbox and in every build before a release. A release build
freezes the draft with Publish-ContractRelease and then passes the resolved version with -Version; a named release
that a unit holds no folder for is one issue, so the gate never passes over a release it did not check. A
contracts/ tree that does not list (a malformed version folder, a file outside a module folder, a contract.yml
entry naming no asset) is one issue. No assets at all is a clean pass. The gate reads files only: no git, no
build.

It ends through Write-QualityGateReport: the report goes to out/test-contracts/, every issue is printed, and the
quality gate throws once listing them all; -PassThru returns the result instead.
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; Version; Assets; PinnedAssets; FailedAssets;
ReleasedFolders }) instead of throwing on issues. Assets counts every checked asset, PinnedAssets those of older
releases among them.
```
