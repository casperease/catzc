<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Get-AdrRuleSet.ps1
    name: get-adr-rule-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
    docs: "[Get-AdrRuleSet.ps1.md](docs/references/pwsh/catzc-base-docs/Get-AdrRuleSet.ps1.md)"
---
#>

function Get-AdrRuleSet {
    [OutputType([Catzc.Base.Docs.AdrRuleSet[]])]
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
