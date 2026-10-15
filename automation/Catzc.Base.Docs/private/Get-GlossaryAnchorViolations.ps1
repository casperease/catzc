<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryAnchorViolations.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Lists the glossary terms that are not anchored on their defining rule (check G2) — one message per violation.
.DESCRIPTION
    Only the normative summary anchors a term; bold in the ADR body, rule bullets or code spans does not.
    [ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryAnchorViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER IndexPath
    A test points this at a fixture index beside fixture ADR files.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryAnchorViolations.ps1.md#comment2)
.OUTPUTS
    [string[]] One message per violation, in glossary order; empty when every term is anchored.
.EXAMPLE
    Get-GlossaryAnchorViolations
#>
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
            $violations.Add("$($item.SourcePath): concept '$term': defined_by '$citation' names no rule in an indexed ADR (ADR-REPO-VOCAB#1)")
            continue
        }
        $bold = '\*\*' + ([regex]::Escape($term) -replace '\\ ', '\s+') + '\*\*'
        if ($statements[$ruleId] -inotmatch $bold) {
            $violations.Add("$($item.SourcePath): concept '$term': the normative summary of $citation does not bold '**$term**' — a term is defined where its rule bolds it (ADR-REPO-VOCAB#1)")
        }
    }

    $violations.ToArray()
}
