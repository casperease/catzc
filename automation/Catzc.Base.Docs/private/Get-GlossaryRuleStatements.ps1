<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
    kind: automation-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-VOCAB#1
      - ADR-REPO-VOCAB#5
  config:
    synopsis: Maps every indexed ADR rule id to the text of its normative summary that can define a term.
    description: |-
      Walks the ADRs the index lists (Get-CatsAdrIndex) and reads each one's rules (Get-CatsAdrRules), keeping each
      rule's Statement — its whole normative summary on one line — with inline code spans removed. A code span is a
      mention, never a definition
      ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)), so `A **<term>** is …`
      written in backticks neither anchors nor
      defines a term. This is the one text the anchoring (G2) and single-definition (G3) checks match against
      ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)); ADR bodies are never read.

      Private helper for the glossary checks; not exported.
    parameters:
      IndexPath: |-
        Absolute path to the ADR index. ADR paths in it resolve against the index's own folder, so a test can point
        this at a fixture index beside fixture ADR files.
    outputs: |-
      [System.Collections.Generic.Dictionary[string, string]] Rule id in registry form ('ADR-AUTO-TEST:13') ->
      statement text, ordinal keys.
    examples:
      - (Get-GlossaryRuleStatements -IndexPath (Resolve-RepoPath 'docs/adr/index.md'))['ADR-REPO-VOCAB:1']
---
#>

function Get-GlossaryRuleStatements {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, string]])]
    param(
        [Parameter(Mandatory)]
        [string] $IndexPath
    )

    $adrRoot = Split-Path $IndexPath -Parent
    $statements = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($adr in (Get-CatsAdrIndex -IndexPath $IndexPath)) {
        foreach ($rule in (Get-CatsAdrRules -AdrPath (Join-Path $adrRoot $adr.Path))) {
            $statements[$rule.Id] = $rule.Statement -replace '`[^`]*`', ''
        }
    }

    , $statements
}
