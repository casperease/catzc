# pwsh/Base.QualityGates/private/Get-GeneratedStampDrift.ps1

A private helper of Test-GeneratedFiles, its fast path. It names the generated files whose head's body hash is not the hash of their body,
so their writers render them; a file whose stamp holds needs no render of its own.

## help

### synopsis

Names the generated files whose head's body hash is not the hash of their body, for their writers to render.

### description

The stamp is the drift check's fast path and never its verdict
([ADR-REPO-FILEMETA-INTUNEWITHGENERATOR](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-intunewithgenerator)): a file whose
`with_body_sha` is the hash of its body passes, and every other file is a miss that sends its writer's dry run to decide. This reads the
given paths, which the writer registry names (Get-GeneratedTrackedPath), finds the head through each file's carrier and compares the stamp
with the body. A png is read as bytes, its stamp from the catzc tEXt chunk and its body hash over the image without it; an svg or xml stamp
is read from the element its carrier type strips. A file with no head, no stamp, no carrier that holds one, a png file that is no png, and a
file missing from the disk is a miss, since only the render can tell.

Private helper of Test-GeneratedFiles; not exported.

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Path`

The repository-relative generated files to read.

### parameter `Resolver`

The carrier resolver. Default: built from the shipped file-carriers and languages registries.

### outputs

`[string]` The repository-relative path of each miss, in the order given.

### example 1

```powershell
Get-GeneratedStampDrift -RepositoryRoot (Get-RepositoryRoot) -Path 'docs/drs/index.md'
```
