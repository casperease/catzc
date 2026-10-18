# automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the tags of one axis for a Pester test — nearest contributing block wins.

### description

Returns the matching tags from the FIRST level that carries any tag of the axis: the test's own It-tags, else the innermost ancestor block
(root excluded). This is the innermost-override model Pester itself uses for tag filtering — an inner block's tag wins over an outer
default, and outer blocks are ignored once a nearer one contributes. Normally one tag; two means a single block carries two tags of the same
axis (ambiguous), which callers treat as a tagging violation. Always returns an array (empty when nothing matches). Shared by
Get-TestLevelTag (tier) and Get-TestCategoryTag (category) so the resolution logic has one home.

### parameter Test

A Pester test object (an item of $result.Tests). Its .Tag and .Block chain carry the tags.

### parameter Valid

The axis's valid tags in canonical casing (e.g. 'L0','L1','L2','L3' or 'logic','integrity').

## comment:1

Above `foreach ($levelTags in $levels) {`, written with `#`.

```text
The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
```
