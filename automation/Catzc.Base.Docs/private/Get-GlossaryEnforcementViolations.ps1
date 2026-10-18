<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossaryEnforcementViolations.ps1
    folder: private
    name: get-glossary-enforcement-violations
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
    test: automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
    cites:
      - ADR-REPO-VOCAB
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
