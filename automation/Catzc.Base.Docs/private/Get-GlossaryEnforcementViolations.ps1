<#
.SYNOPSIS
    Lists the realized glossary concepts whose defining rule nothing enforces (gate G5) — one message per violation.
.DESCRIPTION
    A concept realized in code is only as reliable as the check behind it
    ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
    [ADR-REPO-VOCAB#6](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)). For every concept whose
    source takes part in the `enforced` gate and whose `realized_by.kind`
    is not `prose-only`, this reports a defining rule (`defined_by`) with no enforcer: no analyzer rule mapped to it
    and no test citing it in a `-Tag` — the same rule-citation link Show-Cats reports (Get-CatsRuleEnforcers).
    A `prose-only` concept has nothing in code to enforce and is exempt.

    Private helper for the glossary gates; not exported.
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER Enforcer
    Rule citation ('#' form) -> { Analyzers; Tests }, as Get-CatsRuleEnforcers returns it. Defaults to the
    repository's enforcers (source tree only).
.OUTPUTS
    [string[]] One message per unenforced concept, in glossary order; empty when every realized concept is enforced.
.EXAMPLE
    Get-GlossaryEnforcementViolations
#>
function Get-GlossaryEnforcementViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [hashtable] $Enforcer = (Get-CatsRuleEnforcers)
    )

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $Entry) {
        $kind = $item.Concept.realized_by.kind
        if ($item.Options.gates -notcontains 'enforced' -or $kind -eq 'prose-only') {
            continue
        }
        $citation = $item.Concept.defined_by
        if ($Enforcer.ContainsKey($citation) -and ($Enforcer[$citation].Analyzers.Count + $Enforcer[$citation].Tests.Count) -gt 0) {
            continue
        }
        $violations.Add("$($item.SourcePath): concept '$($item.Concept.term)' is realized as $kind '$($item.Concept.realized_by.pattern)', but no test or analyzer cites its defining rule $citation — tag a test with it or declare the concept prose-only (ADR-REPO-VOCAB:6)")
    }

    $violations.ToArray()
}
