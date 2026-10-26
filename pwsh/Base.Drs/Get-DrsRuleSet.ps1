<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/Get-DrsRuleSet.ps1.md"
  header: "generated"
---
#>

function Get-DrsRuleSet {
    [OutputType([Catzc.Base.Drs.DrsRuleSet[]])]
    [CmdletBinding()]
    param(
        [ArgumentCompleter({ (Get-Config -Config drs).Domains.Name })]
        [string] $Domain
    )

    $ruleSets = (Get-Config -Config drs).RuleSets
    if ($Domain) {
        return @($ruleSets | Where-Object { $_.Domain -ceq $Domain })
    }
    @($ruleSets)
}
