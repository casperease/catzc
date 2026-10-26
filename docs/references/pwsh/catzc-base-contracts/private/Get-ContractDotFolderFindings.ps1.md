# pwsh/Base.Contracts/private/Get-ContractDotFolderFindings.ps1

The dot-folder check of the contracts folder: it reports each outermost dot-prefixed folder, since an asset reaches such a target through
its module's target root instead.

## help

### synopsis

Finds every dot-prefixed folder under contracts/, and returns one finding per folder.

### description

contracts/ holds no dot-prefixed folder at any depth
([ADR-REPO-CONTRACT-NODOTFOLDERS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders)): a dot prefix marks a
repository root as infrastructure
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), so an asset
that binds files under a dot-prefixed folder names them in its version's contract.yml applies_to
([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)) and
never repeats the dot folder. Only the outermost dot-prefixed folder of a branch is a finding, since moving it moves what it holds. A
dot-prefixed file name is not a finding: a released folder's .frozen record is a file. Findings come in ordinal path order; a missing
contracts/ gives none.

### parameter `RepositoryRoot`

The repository root that holds contracts/.

### outputs

`[string[]]` The findings; none when no folder under contracts/ is dot-prefixed.

### example 1

```powershell
Get-ContractDotFolderFindings -RepositoryRoot $root
```

## the walk is whole

The gate looks for stray folders, so its walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): no name is pruned
and no depth hides one.
