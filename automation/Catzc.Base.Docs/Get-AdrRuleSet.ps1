<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-AdrRuleSet.ps1
    name: get-adr-rule-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
  config:
    synopsis: The flat set of ADR rule-sets declared in adrs.yml — one typed record per ADR.
    description: |-
      Returns the RuleSets of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig — mapped and
      validated by the C# type, so this reads strong properties, not a slippery ordered dictionary). Each record
      (Catzc.Base.Docs.AdrRuleSet) carries the internal kebab Slug, the full External citation code, the
      domain Code in effect (a leaf override or the domain default), the folder-owning Domain and its Role, and
      the optional Terminology token.
    parameters:
      Domain: Restrict to one folder-owning domain (e.g. 'automation'), by name.
    outputs: '[Catzc.Base.Docs.AdrRuleSet[]] in declaration order.'
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
