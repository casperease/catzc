<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
    folder: private
    name: get-glossary-rule-statements
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
    cites:
      - ADR-REPO-VOCAB#{1,5}
---
#>

function Get-GlossaryRuleStatements {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, string]])]
    param(
        [Parameter(Mandatory)]
        [string] $IndexPath
    )

    $adrRoot = Split-Path $IndexPath -Parent
    $statements = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($adr in (Get-CatsAdrIndex -IndexPath $IndexPath)) {
        foreach ($rule in (Get-CatsAdrRules -AdrPath (Join-Path $adrRoot $adr.Path))) {
            $statements[$rule.Id] = $rule.Statement -replace '`[^`]*`', ''
        }
    }

    , $statements
}
