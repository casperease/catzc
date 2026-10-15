---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
    kind: comment-page
    body_sha: ef6a79dee753
    adrs:
      - ADR-REPO-CONTRACT#10
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
contracts/ holds no dot-prefixed folder at any depth
([ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)): a dot prefix marks a
repository root as infrastructure ([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)),
so an asset whose target sits under a dot-prefixed root reaches it through its module's target root in contracts.yml
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)) and never repeats the dot
folder. Only the outermost dot-prefixed folder of a branch is a finding, since moving it moves what it holds. A
dot-prefixed file name is not a finding: a released folder's .frozen record and an asset that pins a dotfile by its
own name are files, and a target root relocates a folder but never renames a file. Findings come in ordinal path
order; a missing contracts/ gives none.
```
