function Get-GlossaryEnforcementViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [hashtable] $Enforcer = (Get-RuleEnforcers)
    )

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $Entry) {
        $kind = $item.Concept.realized_by.kind
        if ($item.Options.checks -notcontains 'enforced' -or $kind -eq 'prose-only') {
            continue
        }
        $citation = $item.Concept.defined_by
        if ($Enforcer.ContainsKey($citation) -and
            ($Enforcer[$citation].Analyzers.Count + $Enforcer[$citation].Tests.Count) -gt 0) {
            continue
        }
        $violations.Add("$($item.SourcePath): concept '$($item.Concept.term)' is realized as $kind '$($item.Concept.realized_by.pattern)', but no test or analyzer cites its defining rule $citation — tag a test with it or declare the concept prose-only (ADR-REPO-VOCAB-REALIZEDBY)")
    }

    $violations.ToArray()
}
