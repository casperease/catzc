function Build-Glossary {
    [CmdletBinding()]
    [OutputType([string], [pscustomobject])]
    param(
        [string] $Path = (Resolve-RepoPath 'docs/adr/glossary.md'),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $inputsSha = Get-InputStamp -Path @(
        @(Get-Config -Config glossary -ListOwners | ForEach-Object Path)
        (Resolve-RepoPath 'automation/Catzc.Base.Docs/configs/adrs.yml')
        (Resolve-RepoPath 'docs/adr')
        (Resolve-RepoPath 'automation/Catzc.Base.Docs/Build-Glossary.ps1')
        (Resolve-RepoPath 'automation/Catzc.Base.Docs/Format-MarkdownParagraph.ps1')
        (Resolve-RepoPath 'automation/Catzc.Base.Docs/types')
    ) -Exclude ([System.Management.Automation.WildcardPattern]::Escape($Path)), '*/docs/adr/index.md', '*/docs/adr/glossary.md', '*/README.md'
    if (-not $PassThru -and (Test-GeneratedFileCurrent -Path $Path -InputsSha $inputsSha)) {
        return ConvertTo-RepoRelativePath $Path
    }

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

    $glossaryPath = ConvertTo-RepoRelativePath $Path
    $content = Format-GeneratedFileHead -Text (($lines -join "`n") + "`n") -Path $glossaryPath -Generator Build-Glossary -InputsSha $inputsSha -FileKind (Get-FileKind $glossaryPath)
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
