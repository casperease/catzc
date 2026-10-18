# automation/Catzc.Base.QualityGates/private/Get-TestLevelTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a Pester test's integration tier (L0 to L4, `[Catzc.Base.Timeouts.TestTiers]`) from its block hierarchy.

### description

Returns the single tier tag for a test — nearest contributing block wins (innermost override). Returns $null when no block in the chain
carries a tier tag, or when the nearest contributing block carries more than one (ambiguous); both are tagging violations surfaced by
Get-TestTagViolations. The tier tag is mandatory — there is no default (see the test-automation ADR). Shares the block walk with
Get-TestCategoryTag via Get-TestBlockTag, and feeds Test-Automation's timing report and Write-TestAutomationReport.

### parameter `Test`

A Pester test-result object (an item of $result.Tests). Its .Block chain carries the tier tags.
