<#
.SYNOPSIS
    The flat set of ADR rule-sets declared in adrs.yml — one typed record per ADR.
.DESCRIPTION
    Each record's Code is already resolved, a leaf override or else the domain default, so callers never merge them.
    [comment:1](/docs/references/automation/catzc-base-docs/Get-AdrRuleSet.ps1.md#comment1)
.PARAMETER Domain
    Restrict to one folder-owning domain (e.g. 'automation'), by name.
.OUTPUTS
    [Catzc.Base.Docs.AdrRuleSet[]] in declaration order.
#>
function Get-AdrRuleSet {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [ArgumentCompleter({ (Get-Config -Config adrs).Domains.Name })]
        [string] $Domain
    )

    $ruleSets = (Get-Config -Config adrs).RuleSets
    if ($Domain) {
        return @($ruleSets | Where-Object { $_.Domain -ceq $Domain })
    }
    @($ruleSets)
}
