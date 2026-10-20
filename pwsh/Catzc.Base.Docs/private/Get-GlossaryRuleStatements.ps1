<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
    folder: private
    name: get-glossary-rule-statements
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
    docs: "[Get-GlossaryRuleStatements.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md)"
    cites:
      - ADR-AUTO-TEST-TWOMANDATORYTAGS
      - ADR-REPO-VOCAB-DEFINEDTERM
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
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
