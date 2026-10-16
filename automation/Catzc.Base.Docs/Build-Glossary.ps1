<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Build-Glossary.ps1
    kind: writer-function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
    adrs:
      - ADR-REPO-README#7
      - ADR-REPO-VOCAB
  config:
    synopsis: |-
      Generates the [glossary](/docs/adr/glossary.md) — the controlled vocabulary as one readable page — from the
      glossary sources.
    description: |-
      Projects Get-Glossary (every concept of every configs/glossary.yml source,
      [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)) into one markdown page: a section per ADR domain,
      in adrs.yml order, and per term its one-line definition, a link to the rule that defines it, how it is realized,
      its source, its relations, its allowed forms, its contrasts (linked to the related terms), and its avoided phrasings
      with what to say instead. Terms sort by term within a domain, so the output is deterministic.

      The page is a derived artifact like the ADR index: committed so GitHub has it (linguist-generated, so its diff
      collapses) and rebuilt on import, its sources (the glossary files and this generator) are what is reviewed and
      checked
      ([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)). It is written only when its
      content changes, and emitted already formatted (Format-MarkdownParagraph), so Format-Code is a no-op on it.
    parameters:
      Path: The page to write. Defaults to the [glossary](/docs/adr/glossary.md); a test points it at a fixture path.
      DryRun: Report whether the page would change without writing it.
      Silent: Write no message.
      PassThru: Return { Path; Changed; DryRun; ConceptCount } instead of the path.
    outputs: '[string] The repo-relative page path; with -PassThru, [pscustomobject] { Path; Changed; DryRun; ConceptCount }.'
    examples:
      - Build-Glossary -DryRun -PassThru
---
#>

function Build-Glossary {
    [CmdletBinding()]
    [OutputType([string], [pscustomobject])]
    param(
        [string] $Path = (Resolve-RepoPath 'docs/adr/glossary.md'),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $entries = Get-Glossary
    $citations = Get-AdrCitationMap
    $relationLabels = [ordered]@{ kind_of = 'Kind of'; part_of = 'Part of'; selected_by = 'Selected by' }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# docs/adr/glossary.md')
    $lines.Add('')
    $lines.Add('Glossary: the controlled vocabulary')
    $lines.Add('')
    $intro = 'Every defined term of the repository, generated from the glossary sources (each module''s `configs/glossary.yml`) by ' +
    '`Build-Glossary` — edit a source, never this page. A term''s meaning is fixed by the one ADR rule that defines it ' +
    '([controlled-vocabulary](repository/controlled-vocabulary.md)); this page collects them, with how each differs from its ' +
    'neighbours and the phrasings to avoid. `Test-Glossary` checks the sources.'
    foreach ($line in (Format-MarkdownParagraph -Text $intro)) {
        $lines.Add($line)
    }

    foreach ($domain in (Get-Config -Config adrs).Domains) {
        $domainEntries = @($entries | Where-Object { $_.Concept.domain -ceq $domain.Name })
        if ($domainEntries.Count -eq 0) {
            continue
        }
        $lines.Add('')
        $lines.Add("## $($domain.Name)")

        foreach ($entry in $domainEntries) {
            $concept = $entry.Concept
            $lines.Add('')
            $lines.Add("### $($concept.term)")
            $lines.Add('')
            foreach ($line in (Format-MarkdownParagraph -Text $concept.short)) {
                $lines.Add($line)
            }
            $lines.Add('')

            # The defining rule as a markdown link relative to docs/adr/ (the citation map's destination is repo-rooted).
            $code, $rule = $concept.defined_by -split '#'
            $destination = $citations.Destination($code, [int] $rule)
            $definedBy = if ($destination) {
                "[$($concept.defined_by)]($($destination -replace '^/docs/adr/', ''))"
            }
            else {
                "``$($concept.defined_by)``"
            }
            $lines.Add("- **Defined by:** $definedBy")

            $realization = $concept.realized_by
            $realizedBy = if ($realization.kind -eq 'prose-only') {
                'prose only — a vocabulary term with nothing in code to enforce'
            }
            else {
                "$($realization.kind) ``$($realization.pattern)``"
            }
            $lines.Add("- **Realized by:** $realizedBy")
            $lines.Add("- **Source:** ``$($entry.SourcePath)``")

            foreach ($kind in $relationLabels.Keys) {
                if (-not $concept.relations.ContainsKey($kind)) {
                    continue
                }
                $targets = @($concept.relations[$kind] | ForEach-Object { "[$_](#$($_ -replace ' ', '-'))" }) -join ', '
                $lines.Add("- **$($relationLabels[$kind]):** $targets")
            }

            if ($concept.forms.Count -gt 0) {
                # Each form in backticks: the page mentions them, so the forms check (G6) never reads them as uses.
                $head = @($concept.term -split '[ -]')[-1]
                $forms = (@($concept.forms | ForEach-Object { "``$_ $head``" }) -join ', ') + ", and the bare ``$head``"
                if ($concept.verbs) {
                    $forms += ', with its verb forms'
                }
                foreach ($line in (Format-MarkdownParagraph -Text "**Forms:** $forms" -FirstPrefix '- ' -ContinuationPrefix '  ')) {
                    $lines.Add($line)
                }
            }

            if ($concept.contrasts.Count -gt 0) {
                $lines.Add('- **Contrasts:**')
                $others = [string[]] @($concept.contrasts.Keys)
                [System.Array]::Sort($others, [System.StringComparer]::Ordinal)
                foreach ($other in $others) {
                    $text = "[$other](#$($other -replace ' ', '-')): $($concept.contrasts[$other])"
                    foreach ($line in (Format-MarkdownParagraph -Text $text -FirstPrefix '  - ' -ContinuationPrefix '    ')) {
                        $lines.Add($line)
                    }
                }
            }

            if ($concept.avoid.Count -gt 0) {
                $rows = @($concept.avoid | ForEach-Object {
                        [pscustomobject]@{ Avoid = "``$($_.phrase)``"; Say = $_.say }
                    })
                $avoidWidth = [System.Math]::Max(5, (@($rows.Avoid) | Measure-Object -Property Length -Maximum).Maximum)
                $sayWidth = [System.Math]::Max(11, (@($rows.Say) | Measure-Object -Property Length -Maximum).Maximum)
                $lines.Add('')
                $lines.Add("| $('Avoid'.PadRight($avoidWidth)) | $('Say instead'.PadRight($sayWidth)) |")
                $lines.Add("| $('-' * $avoidWidth) | $('-' * $sayWidth) |")
                foreach ($row in $rows) {
                    $lines.Add("| $($row.Avoid.PadRight($avoidWidth)) | $($row.Say.PadRight($sayWidth)) |")
                }
            }
        }
    }

    $content = Format-GeneratedFileHead -Text (($lines -join "`n") + "`n") -Path (ConvertTo-RepoRelativePath $Path) -Generator Build-Glossary -Tracked
    $changed = Write-FileIfChanged $Path $content -DryRun:$DryRun

    $relativePath = ConvertTo-RepoRelativePath $Path
    if ($changed -and -not $Silent) {
        $verb = if ($DryRun) {
            'would write'
        }
        else {
            'wrote'
        }
        Write-Message "$verb $relativePath"
    }

    if ($PassThru) {
        [pscustomobject]@{ Path = $relativePath; Changed = $changed; DryRun = [bool]$DryRun; ConceptCount = @($entries).Count }
    }
    else {
        $relativePath
    }
}
