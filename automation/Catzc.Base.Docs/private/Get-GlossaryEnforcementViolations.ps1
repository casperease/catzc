<#
.SYNOPSIS
    Lists the realized glossary concepts whose defining rule nothing enforces (check G5) — one message per violation.
.DESCRIPTION
    A prose-only concept has nothing in code to enforce, so it is exempt from the enforcer requirement.
    [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
    [ADR-REPO-VOCAB#6](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryEnforcementViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER Enforcer
    Defaults to the repository's enforcers, which exist in the source tree only.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryEnforcementViolations.ps1.md#comment2)
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
        if ($item.Options.checks -notcontains 'enforced' -or $kind -eq 'prose-only') {
            continue
        }
        $citation = $item.Concept.defined_by
        if ($Enforcer.ContainsKey($citation) -and ($Enforcer[$citation].Analyzers.Count + $Enforcer[$citation].Tests.Count) -gt 0) {
            continue
        }
        $violations.Add("$($item.SourcePath): concept '$($item.Concept.term)' is realized as $kind '$($item.Concept.realized_by.pattern)', but no test or analyzer cites its defining rule $citation — tag a test with it or declare the concept prose-only (ADR-REPO-VOCAB#6)")
    }

    $violations.ToArray()
}
