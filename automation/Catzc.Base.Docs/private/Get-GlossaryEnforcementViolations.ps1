<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryEnforcementViolations.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
    adrs:
      - ADR-REPO-VOCAB
  config:
    synopsis: Lists the realized glossary concepts whose defining rule nothing enforces (check G5) — one message per violation.
    description: |-
      A concept realized in code is only as reliable as the check behind it
      ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
      [ADR-REPO-VOCAB#6](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)). For every concept whose
      source takes part in the `enforced` check and whose `realized_by.kind`
      is not `prose-only`, this reports a defining rule (`defined_by`) with no enforcer: no analyzer rule mapped to it
      and no test citing it in a `-Tag` — the same rule-citation link Show-Cats reports (Get-CatsRuleEnforcers).
      A `prose-only` concept has nothing in code to enforce and is exempt.

      Private helper for the glossary checks; not exported.
    parameters:
      Entry: The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
      Enforcer: |-
        Rule citation ('#' form) -> { Analyzers; Tests }, as Get-CatsRuleEnforcers returns it. Defaults to the
        repository's enforcers (source tree only).
    outputs: '[string[]] One message per unenforced concept, in glossary order; empty when every realized concept is enforced.'
    examples:
      - Get-GlossaryEnforcementViolations
---
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
