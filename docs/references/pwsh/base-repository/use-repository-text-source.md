# pwsh/Base.Repository/Use-RepositoryTextSource.ps1

The scope that makes the repository readers answer from one source, such as a commit, instead of the working tree.

## help

### synopsis

Runs a script block with the repository readers answering from the given source.

### description

Inside the script block, Read-RepositoryText and Get-RepositoryTextFile answer for every repository path from the source alone. A path the
source lists has the text it was given. A path it does not list is absent, even when the working tree holds it. A path outside the
repository still reads from disk. Get-RepositoryTextSource names the source, so a reader that caches keys its entry on that name, and the
two modes never share an entry. The outer source, or none, comes back when the block ends, even when the block throws. The caller loads the
texts, so this bottom-layer module never runs git itself.

### parameter `Name`

The source's identity, such as a commit id. A cached read keys on it, so it must name fixed content.

### parameter `Path`

Every repository-relative path the source holds, with forward slashes.

### parameter `Text`

The texts the source loaded, keyed by their repository-relative paths. Each key must be one of the paths. A listed path with no text throws
when it is read.

### parameter `ScriptBlock`

The work to run against the source. Its output is returned.

### example 1

```powershell
Use-RepositoryTextSource -Name $commit -Path $paths -Text $texts -ScriptBlock { Get-Config -Config widgets }
```
