<#
.SYNOPSIS
    Lists the glossary terms that a second ADR rule defines (check G3) — one message per violation.
.DESCRIPTION
    A defined term is fixed by exactly one rule.
    [ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryDefinitionViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER IndexPath
    Absolute path to the ADR index whose ADRs hold the rules.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryDefinitionViolations.ps1.md#comment2)
.OUTPUTS
    [string[]] One message per second definition, in glossary then rule-id order; empty when every term has one.
.EXAMPLE
    Get-GlossaryDefinitionViolations
#>
function Get-GlossaryDefinitionViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    $statements = Get-GlossaryRuleStatements -IndexPath $IndexPath
    $ruleIds = [string[]] @($statements.Keys)
    [System.Array]::Sort($ruleIds, [System.StringComparer]::Ordinal)

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $Entry) {
        if ($item.Options.checks -notcontains 'single') {
            continue
        }
        $term = $item.Concept.term
        $defining = $item.Concept.defined_by.Replace('#', ':')
        $definition = '\*\*' + ([regex]::Escape($term) -replace '\\ ', '\s+') + '\*\*\s+is\b'
        foreach ($ruleId in $ruleIds) {
            if ($ruleId -ceq $defining -or $statements[$ruleId] -inotmatch $definition) {
                continue
            }
            $violations.Add("$($item.SourcePath): concept '$term': $($ruleId.Replace(':', '#')) defines '**$term**' a second time — it is defined by $($item.Concept.defined_by) (ADR-REPO-VOCAB#1)")
        }
    }

    $violations.ToArray()
}
