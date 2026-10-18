<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossaryAnchorViolations.ps1
    folder: private
    name: get-glossary-anchor-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
    cites:
      - ADR-REPO-VOCAB#1
---
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
