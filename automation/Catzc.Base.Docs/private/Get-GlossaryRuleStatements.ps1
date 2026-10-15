# catzc:
#   path: automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
#   module: Catzc.Base.Docs
#   visibility: private

<#
.SYNOPSIS
    Maps every indexed ADR rule id to the text of its normative summary that can define a term.
.DESCRIPTION
    Code spans are stripped first, so an example of a definition in a code span neither anchors nor defines a term.
    [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5),
    [ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md#comment1)
.PARAMETER IndexPath
    ADR paths resolve against the index's own folder, so a test can point this at a fixture index.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md#comment2)
.OUTPUTS
    [System.Collections.Generic.Dictionary[string, string]] Rule id in registry form ('ADR-AUTO-TEST:13') ->
    statement text, ordinal keys.
.EXAMPLE
    (Get-GlossaryRuleStatements -IndexPath (Resolve-RepoPath 'docs/adr/index.md'))['ADR-REPO-VOCAB:1']
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
