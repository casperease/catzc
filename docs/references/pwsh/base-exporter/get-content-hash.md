# pwsh/Base.Exporter/Get-ContentHash.ps1

The command that computes the durable content hash of a directory tree: the content-addressed identity of a bundle.

## help

### synopsis

Computes the durable content hash of a directory tree — the bundle's content-addressed identity.

### description

The same durable-SHA recipe the globsets use
([FDR-GLOBS-DURABLESHAIDENTITY](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)), applied to every file under
-Path: per file a SHA-256 over its bytes with every CR stripped (so a CRLF vs LF tree yields the same identity on any machine), folded as
`<relative-path>|<digest>` lines in ordinal path order, then one combined SHA-256 over the fold — 64 lowercase hex chars. The relative path
is forward-slashed and taken from -Path, so the hash is stable wherever the tree is copied. This is the reproducibility proof an exported
bundle carries (build twice from one commit -> identical hash).

### parameter `Path`

The root directory whose file tree to hash (recursively).

### parameter `Exclude`

Path-relative, forward-slashed file paths to omit from the hash — e.g. a build.json sidecar that itself carries the hash, so it cannot be
part of the content it identifies.

### example 1

```powershell
Get-ContentHash -Path (Join-Path (Get-OutputRoot) 'automation/built/full/Catzc/6.6.666') -Exclude 'build.json'
```

## The walk

The walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the hash covers every
file, so nothing is pruned and no depth drops one.
