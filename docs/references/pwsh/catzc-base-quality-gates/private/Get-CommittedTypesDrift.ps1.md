# pwsh/Base.QualityGates/private/Get-CommittedTypesDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reports why the committed types contract is not the current build's surface.

### description

What a consumer binds to, the types surface (each public type's name, aliases and display), is the provided contract
`contracts/catzc/0.1.0/catzc.internal.types/types.sample.json`; the source hash that names a build is a local cache key. The surface is read
from the build of the current type sources in the shadow root (named for the combined hash Get-CombinedTypeHash computes) and held against
the committed contract: a missing build, a missing contract, every added, removed or changed type, and a pending git change of the contract
are one reason each. None means the committed contract is the current surface.

### parameter `RepositoryRoot`

The repository whose types contract is checked.

### outputs

`[string[]]` One reason per drift found; nothing when the committed contract is the current surface.

### example 1

```powershell
Get-CommittedTypesDrift -RepositoryRoot (Get-RepositoryRoot)
```
