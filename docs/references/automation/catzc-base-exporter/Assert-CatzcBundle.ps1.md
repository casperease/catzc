---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Assert-CatzcBundle.ps1.md
    kind: comment-page
    body_sha: "982cc613e19d"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$files = foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`.

```text
Every file once, build-relative and forward-slashed: the tests/ scan and the shipped type sources read it.
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the bundle
is verified in full, vendored modules included, so nothing is pruned.
```

## comment:4

Above `$staging = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),...`.

```text
Stage the sources build.json records in the one layout Get-CombinedTypeHash reads (<Module>/types/<File>.cs), so the
hash comes from the one implementation rather than a second copy of its recipe.
```
