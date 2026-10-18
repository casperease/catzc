---
catzc:
  immutable:
    with_body_sha: "268c6162b3b9"
    repo_status: locked
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
    folder: docs/references/automation/catzc-base-contracts/private
    name: get-contract-dot-folder-findings-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Finds every dot-prefixed folder under contracts/, and returns one finding per folder.

### description

contracts/ holds no dot-prefixed folder at any depth
([ADR-REPO-CONTRACT#10](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract10)): a dot prefix marks a repository root as
infrastructure ([ADR-REPO-FOLDERS#4](../../../../adr/repository/conventional-folders.md#rule-adr-repo-folders4)), so an asset whose target
sits under a dot-prefixed root reaches it through its module's target root in contracts.yml
([ADR-REPO-CONTRACT#2](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract2)) and never repeats the dot folder. Only the
outermost dot-prefixed folder of a branch is a finding, since moving it moves what it holds. A dot-prefixed file name is not a finding: a
released folder's .frozen record and an asset that pins a dotfile by its own name are files, and a target root relocates a folder but never
renames a file. Findings come in ordinal path order; a missing contracts/ gives none.

### parameter RepositoryRoot

The repository root that holds contracts/.

### outputs

`[string[]]` The findings; none when no folder under contracts/ is dot-prefixed.

### example 1

```powershell
Get-ContractDotFolderFindings -RepositoryRoot $root
```

## comment:1

Above `$folders = [string[]] @(Get-ChildPath $contractsRoot -Directory -Depth 64...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): this gate
looks for stray folders, so no name is pruned and no depth hides one.
```
