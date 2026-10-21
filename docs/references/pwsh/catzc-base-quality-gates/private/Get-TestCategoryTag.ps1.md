# pwsh/Catzc.Base.QualityGates/private/Get-TestCategoryTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a Pester test's category (logic/integrity) from its block hierarchy.

### description

Returns the single category tag for a test — nearest contributing block wins (innermost override). Returns $null when no block in the chain
carries a category tag, or when the nearest contributing block carries both (ambiguous); both are tagging violations surfaced by
Get-TestTagViolations. A logic test verifies a function's logic on mocks/own fixtures, independent of shipped config; an integrity test
verifies the actual repository contents (shipped configs, templates, binaries, conventions, dependency graphs). The category tag is
mandatory — there is no default (see the test-automation ADR). Shares the block walk with Get-TestLevelTag via Get-TestBlockTag.

### parameter `Test`

A Pester test-result object (an item of $result.Tests). Its .Block chain carries the category tags.
