<#
.SYNOPSIS
    Lists the glossary terms that a second ADR rule defines (gate G3) — one message per violation.
.DESCRIPTION
    A defined term is fixed by exactly one rule
    ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).
    For every concept whose source takes part in the `single` gate, this reports each rule other than its
    `defined_by` whose normative summary defines the term again: `**<term>** is` (case-insensitive, whitespace
    collapsed). The pattern is deliberately conservative — a rule that merely bolds the term is not a definition —
    and only normative summaries count (Get-GlossaryRuleStatements): bold text in an ADR body or inside an inline
    code span never does.

    Private helper for the glossary gates; not exported.
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER IndexPath
    Absolute path to the ADR index whose ADRs hold the rules. Defaults to
    [index](/docs/adr/index.md); a test points it at
    a fixture index beside fixture ADR files.
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
        if ($item.Options.gates -notcontains 'single') {
            continue
        }
        $term = $item.Concept.term
        $defining = $item.Concept.defined_by.Replace('#', ':')
        $definition = '\*\*' + ([regex]::Escape($term) -replace '\\ ', '\s+') + '\*\*\s+is\b'
        foreach ($ruleId in $ruleIds) {
            if ($ruleId -ceq $defining -or $statements[$ruleId] -inotmatch $definition) {
                continue
            }
            $violations.Add("$($item.SourcePath): concept '$term': $($ruleId.Replace(':', '#')) defines '**$term**' a second time — it is defined by $($item.Concept.defined_by) (ADR-REPO-VOCAB:1)")
        }
    }

    $violations.ToArray()
}
