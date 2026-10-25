# pwsh/Catzc.Base.Contracts/Publish-ContractRelease.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Freezes the current catzc contracts as a released version folder, with the .frozen record that keeps it unchanged.

### description

A release copies the current version `contracts/catzc/0.1.0/` byte for byte to `contracts/catzc/<version>/` and writes that folder's .frozen
record, the SHA-256 of each copied file, line endings read as LF
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)). Test-Contracts
compares every released folder with its record, so a later edit fails the quality gate; the record is not an asset (Get-Contract skips it).

It refuses, before writing anything: a vendor root, which never releases and follows its vendor in 0.1.0
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)); a version below
1.0.0; the devbox build version (exporter.yml direct_install_version, 6.6.666), which names no release
([ADR-AUTO-BUNDLE-AUTOVERSION](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-autoversion)); a target folder that already
exists, since a released folder is never written again; and a missing current version. A copy that fails part-way removes the target again.

It writes files only: it never commits, and it does not check the assets. A release build resolves the version (Resolve-CatzcBuildVersion),
runs this, runs Test-Contracts -Version `<version>`, and commits the folder in its own step. Publish is the approved verb for making a
resource available to others
([ADR-PWSH-VERBS-APPROVEDVERBS](../../../drs/automation/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs-approvedverbs)): the frozen
folder is what a consumer pins.

### parameter `Root`

The contract root to release, by folder name; only catzc, the provided root, releases.

### parameter `Version`

The released version, `<major>.<minor>.<patch>` from 1.0.0 up: the version the release build resolved.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[string]` The frozen folder in communication form, `contracts/catzc/<version>`
([ADR-AUTO-PATH-COMMUNICATIONFORM](../../../drs/automation/path-representation.md#rule-adr-auto-path-communicationform)); nothing under
-WhatIf.

### example 1

```powershell
Publish-ContractRelease -Root catzc -Version 1.0.0
```

### example 2

```powershell
Publish-ContractRelease -Root catzc -Version (Resolve-CatzcBuildVersion) -WhatIf
```

## comment:1

Above `$files = [string[]] @(Get-ChildPath $source -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the
release copies the whole current version, so no name is pruned and no depth drops a file.
```
