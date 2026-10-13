<#
.SYNOPSIS
    Lists the uses of avoided phrasings within each glossary source's scope (check G4) — one message per use.
.DESCRIPTION
    An avoided phrasing blurs a defined term, so prose within its source's scope never uses it
    ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)). For every source whose
    `checks` include `avoid`,
    this reads the tracked files its `scope` matches and its `exclude` does not
    ([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)), on the text
    surfaces its `surfaces` name:
      - markdown — the prose of `*.md` files: fenced code blocks are skipped;
      - comments — PowerShell comments that are not comment-based help;
      - help — comment-based help (a block comment holding .SYNOPSIS or .DESCRIPTION);
      - messages — the static text of the strings passed to `throw`, `Write-Message`, `Write-Warning`,
        `Write-Error`, and `Write-Host`, and of any `-ErrorText` or `-Because` value; an expandable string
        contributes its literal text only.
    PowerShell files (`*.ps1`, `*.psm1`) are read through the parser, never by regex. A phrase matches
    case-insensitively, as whole words, with any whitespace between its words (so a wrapped line still counts).
    A mention — the phrase inside backticks, "double" or “curly” quotes, within one paragraph — is exempt, so the
    vocabulary can talk about itself. Globs are the repository's one glob dialect (Catzc.Base.Globs.GlobPattern).

    Private helper for the glossary checks; not exported.
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.OUTPUTS
    [string[]] One message per use — `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)` — in file then
    line order; empty when prose avoids every avoided phrasing.
.EXAMPLE
    Get-GlossaryPhrasingViolations
#>
function Get-GlossaryPhrasingViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [AllowEmptyCollection()]
        [string[]] $TrackedFile = @(Get-GitTrackedPath '.'),

        [string] $Root = (Get-RepositoryRoot)
    )

    # Per source: its options and every avoided phrasing of its concepts. Sources outside the avoid check drop out.
    $sources = [ordered]@{}
    foreach ($item in $Entry) {
        if ($item.Options.checks -notcontains 'avoid' -or $item.Concept.avoid.Count -eq 0) {
            continue
        }
        if (-not $sources.Contains($item.SourcePath)) {
            $sources[$item.SourcePath] = [pscustomobject]@{
                Options = $item.Options
                Avoid   = [System.Collections.Generic.List[object]]::new()
            }
        }
        foreach ($avoid in $item.Concept.avoid) {
            $words = @($avoid.phrase -split '\s+' | ForEach-Object { [regex]::Escape($_) })
            $sources[$item.SourcePath].Avoid.Add([pscustomobject]@{
                    Phrase    = $avoid.phrase
                    Say       = $avoid.say
                    DefinedBy = $item.Concept.defined_by
                    Pattern   = [regex]::new('(?<![\w-])' + ($words -join '\s+') + '(?![\w-])', 'IgnoreCase')
                })
        }
    }

    # A file's text surfaces are read once, however many sources scan it.
    $surfaceCache = @{}
    $hits = [System.Collections.Generic.List[object]]::new()
    foreach ($sourcePath in $sources.Keys) {
        $source = $sources[$sourcePath]
        $scope = @($source.Options.scope | ForEach-Object { [Catzc.Base.Globs.GlobPattern]::new($_) })
        $exclude = @($source.Options.exclude | ForEach-Object { [Catzc.Base.Globs.GlobPattern]::new($_) })
        foreach ($file in $TrackedFile) {
            $isMarkdown = $file.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)
            $isPowerShell = $file -match '\.psm?1$'
            if (-not ($isMarkdown -or $isPowerShell)) {
                continue
            }
            if (-not @($scope | Where-Object { $_.Matches($file) }) -or @($exclude | Where-Object { $_.Matches($file) })) {
                continue
            }
            $fullPath = Join-Path $Root $file
            if (-not [System.IO.File]::Exists($fullPath)) {
                continue   # a tracked file deleted in the working tree has no prose to read
            }
            if (-not $surfaceCache.ContainsKey($file)) {
                $surfaceCache[$file] = if ($isMarkdown) {
                    @(Get-GlossaryMarkdownProse $fullPath)
                }
                else {
                    @(Get-GlossaryPowerShellProse $fullPath)
                }
            }
            foreach ($segment in $surfaceCache[$file]) {
                if ($source.Options.surfaces -notcontains $segment.Surface) {
                    continue
                }
                foreach ($avoid in $source.Avoid) {
                    foreach ($match in $avoid.Pattern.Matches($segment.Text)) {
                        $line = $segment.Line + ([regex]::Matches($segment.Text.Substring(0, $match.Index), "`n")).Count
                        $hits.Add([pscustomobject]@{
                                File    = $file
                                Line    = $line
                                Message = "${file}:$line says `"$($avoid.Phrase)`" — say `"$($avoid.Say)`" ($($avoid.DefinedBy))"
                            })
                    }
                }
            }
        }
    }

    [string[]] @($hits | Sort-Object -Property @{ Expression = 'File' }, @{ Expression = 'Line' }, @{ Expression = 'Message' } -Unique |
            ForEach-Object Message)
}
