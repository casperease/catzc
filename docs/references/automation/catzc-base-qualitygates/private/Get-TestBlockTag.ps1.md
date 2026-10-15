---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md
    kind: comment-page
    body_sha: "91acb6097c01"
---

# automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the matching tags from the FIRST level that carries any tag of the axis: the test's own It-tags,
else the innermost ancestor block (root excluded). This is the innermost-override model Pester itself uses
for tag filtering — an inner block's tag wins over an outer default, and outer blocks are ignored once a
nearer one contributes. Normally one tag; two means a single block carries two tags of the same axis
(ambiguous), which callers treat as a tagging violation. Always returns an array (empty when nothing
matches). Shared by Get-TestLevelTag (tier) and Get-TestCategoryTag (category) so the resolution logic has
one home.
```

## comment:2

Above `foreach ($levelTags in $levels) {`.

```text
The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
```

## comment:3

Above `foreach ($levelTags in $levels) {`.

```text
The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
```
