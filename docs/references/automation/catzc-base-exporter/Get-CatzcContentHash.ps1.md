---
catzc:
  immutable:
    with_body_sha: "6ac5479d2df8"
    repo_status: locked
    path: docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
    folder: docs/references/automation/catzc-base-exporter
    name: get-catzc-content-hash-ps1
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

# automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Computes the durable content hash of a directory tree — the bundle's content-addressed identity.

### description

The same durable-SHA recipe the globsets use
([ADR-FLOW-CD-GLOBS#5](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)), applied to every file under
-Path: per file a
SHA-256 over its bytes with every CR stripped (so a CRLF vs LF tree yields the same identity on any
machine), folded as `<relative-path>|<digest>` lines in ordinal path order, then one combined SHA-256 over
the fold — 64 lowercase hex chars. The relative path is forward-slashed and taken from -Path, so the hash
is stable wherever the tree is copied. This is the reproducibility proof an exported bundle carries
(build twice from one commit -> identical hash).

### parameter Path

The root directory whose file tree to hash (recursively).

### parameter Exclude

Path-relative, forward-slashed file paths to omit from the hash — e.g. a build.json sidecar that itself
carries the hash, so it cannot be part of the content it identifies.

### example 1

```powershell
Get-CatzcContentHash -Path (Join-Path (Get-OutputRoot) 'automation/built/full/Catzc/6.6.666') -Exclude 'build.json'
```

## comment:1

Above `$files = Get-ChildPath $rootFull -File -Depth 64 -Exclude @() -PruneVendor...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the hash
covers every file, so nothing is pruned and no depth drops one.
```
