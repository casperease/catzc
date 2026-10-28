# pwsh/Base.QualityGates/private/Get-TestLevelTag.ps1

Resolves a Pester test's integration tier, L0 to L4, from its block hierarchy. The nearest block that contributes a tier wins, and `$null`
comes back when no block in the chain names one.

## help

### synopsis

Resolves a Pester test's integration tier (L0 to L4, `[Catzc.Base.Timeouts.TestTiers]`) from its block hierarchy.

### description

Returns the single tier tag for a test — nearest contributing block wins (innermost override). Returns $null when no block in the chain
carries a tier tag, or when the nearest contributing block carries more than one (ambiguous); both are tagging violations surfaced by
Get-TestTagViolations. The tier tag is mandatory — there is no default (see the test-automation record). Shares the block walk with
Get-TestCategoryTag via Get-TestBlockTag, and feeds Test-Automation's timing report and Write-TestAutomationReport.

### parameter `Test`

A Pester test-result object (an item of $result.Tests). Its .Block chain carries the tier tags.
