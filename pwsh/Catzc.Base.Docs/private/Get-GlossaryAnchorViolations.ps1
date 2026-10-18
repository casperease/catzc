function Get-GlossaryAnchorViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    $statements = Get-GlossaryRuleStatements -IndexPath $IndexPath

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $Entry) {
        if ($item.Options.checks -notcontains 'anchored') {
            continue
        }
        $term = $item.Concept.term
        $citation = $item.Concept.defined_by
        $ruleId = $citation.Replace('#', ':')
        if (-not $statements.ContainsKey($ruleId)) {
            $violations.Add("$($item.SourcePath): concept '$term': defined_by '$citation' names no rule in an indexed ADR (ADR-REPO-VOCAB-DEFINEDTERM)")
            continue
        }
        $bold = '\*\*' + ([regex]::Escape($term) -replace '\\ ', '\s+') + '\*\*'
        if ($statements[$ruleId] -inotmatch $bold) {
            $violations.Add("$($item.SourcePath): concept '$term': the normative summary of $citation does not bold '**$term**' — a term is defined where its rule bolds it (ADR-REPO-VOCAB-DEFINEDTERM)")
        }
    }

    $violations.ToArray()
}
