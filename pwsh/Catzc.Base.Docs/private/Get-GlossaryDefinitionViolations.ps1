<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossaryDefinitionViolations.ps1.md"
  header: "generated"
---
#>

function Get-GlossaryDefinitionViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [string] $IndexPath = (Resolve-RepoPath "$((Get-Config -Config drs).Root)/index.md")
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
        $defining = $item.Concept.defined_by
        $definition = '\*\*' + ([regex]::Escape($term) -replace '\\ ', '\s+') + '\*\*\s+is\b'
        foreach ($ruleId in $ruleIds) {
            if ($ruleId -ceq $defining -or $statements[$ruleId] -inotmatch $definition) {
                continue
            }
            $violations.Add("$($item.SourcePath): concept '$term': $ruleId defines '**$term**' a second time — it is defined by $($item.Concept.defined_by) (ADR-REPO-VOCAB-DEFINEDTERM)")
        }
    }

    $violations.ToArray()
}
