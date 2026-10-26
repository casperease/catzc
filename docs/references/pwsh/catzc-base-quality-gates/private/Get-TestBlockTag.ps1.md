# pwsh/Base.QualityGates/private/Get-TestBlockTag.ps1

Resolves the tags of one axis for a Pester test: the nearest block that carries any tag of the axis wins.

## help

### synopsis

Resolves the tags of one axis for a Pester test — nearest contributing block wins.

### description

Returns the matching tags from the FIRST level that carries any tag of the axis: the test's own It-tags, else the innermost ancestor block
(root excluded). This is the innermost-override model Pester itself uses for tag filtering — an inner block's tag wins over an outer
default, and outer blocks are ignored once a nearer one contributes. Normally one tag; two means a single block carries two tags of the same
axis (ambiguous), which callers treat as a tagging violation. Always returns an array (empty when nothing matches). Shared by
Get-TestLevelTag (tier) and Get-TestCategoryTag (category) so the resolution logic has one home.

### parameter `Test`

A Pester test object (an item of $result.Tests). Its .Tag and .Block chain carry the tags.

### parameter `Valid`

The axis's valid tags in canonical casing (e.g. 'L0','L1','L2','L3' or 'logic','integrity').

## Nearest wins

The levels are walked from the test outwards. The first level carrying any tag of the axis wins, and its canonical matches are returned;
`-eq` is case-insensitive. One match is the norm. Two means an ambiguous block, which is surfaced as a violation upstream.
