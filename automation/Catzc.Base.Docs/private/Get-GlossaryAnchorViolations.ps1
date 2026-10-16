<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryAnchorViolations.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
    adrs:
      - ADR-REPO-VOCAB#1
  config:
    synopsis: Lists the glossary terms that are not anchored on their defining rule (check G2) — one message per violation.
    description: |-
      A defined term has one home: the ADR rule its concept names in `defined_by`, whose normative summary bolds it
      ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)). For every concept whose
      source takes part in
      the `anchored` check, this reports:
        - a `defined_by` citation that names no rule of any indexed ADR;
        - a defining rule whose normative summary does not contain `**<term>**` (case-insensitive, whitespace
          collapsed, so a term bolded across a wrapped line still counts).
      Only the normative summary counts (Get-CatsAdrRules' Statement): bold text in the ADR body or in the rule's
      linked bullets never anchors a term, and neither does a mention inside an inline code span.

      Private helper for the glossary checks; not exported.
    parameters:
      Entry: The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
      IndexPath: |-
        Absolute path to the ADR index whose ADRs hold the rules. Defaults to
        [index](/docs/adr/index.md); a test points it at
        a fixture index beside fixture ADR files.
    outputs: '[string[]] One message per violation, in glossary order; empty when every term is anchored.'
    examples:
      - Get-GlossaryAnchorViolations
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
