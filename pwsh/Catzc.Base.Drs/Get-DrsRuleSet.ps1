<#
---
catzc:
  immutable:
    with_body_sha: "5e16e886a685"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSet.Tests.ps1
    docs: "[Get-DrsRuleSet.ps1.md](docs/references/pwsh/catzc-base-drs/Get-DrsRuleSet.ps1.md)"
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
