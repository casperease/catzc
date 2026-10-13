<#
.SYNOPSIS
    Lists the uses of a term outside its declared forms within each glossary source's scope (check G6) — one message
    per use.
.DESCRIPTION
    A term that names a family declares the words allowed to qualify its head word (`forms:`), and any other qualified
    use is a defect ([ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)): for
    `gate`, "quality gate" and "CI gate" are forms, "spelling gate" is not. For every concept with forms whose source
    takes part in the `forms` check, this reads the same tracked files and text surfaces as the avoided-phrasing check
    (G4, Get-GlossaryPhrasingViolations) and reports:
      - a qualified use: "<word> <head>" or "<word>-<head>" (singular or plural), where <word> is neither one of the
        concept's forms nor a function word (an article, determiner, quantifier, possessive, or number — "the gate",
        "each gate", "two gates" are always allowed); the comparison ignores case;
      - a verb use: the head word's -ed and -ing forms ("gated", "gating"), which a noun family never takes.
    The bare head word is always allowed. A mention — the phrase in backticks or quotes — is exempt, as in G4, so the
    vocabulary can talk about itself.

    Private helper for the glossary checks; not exported.
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.OUTPUTS
    [string[]] One message per use — `<file>:<line> says "<use>" — "<term>" takes only: <forms> (<defined_by>)` — in
    file then line order; empty when every use is a declared form.
.EXAMPLE
    Get-GlossaryFormViolations
#>
function Get-GlossaryFormViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [AllowEmptyCollection()]
        [string[]] $TrackedFile = @(Get-GitTrackedPath '.'),

        [string] $Root = (Get-RepositoryRoot)
    )

    # Words that only point at, count, or own a noun — never a qualifier that names a kind of it.
    $functionWords = [System.Collections.Generic.HashSet[string]]::new([string[]] @(
            'a', 'an', 'the', 'this', 'that', 'these', 'those', 'each', 'every', 'any', 'all', 'no', 'some', 'both', 'either',
            'neither', 'its', 'their', 'our', 'your', 'my', 'his', 'her', 'which', 'whose', 'what', 'same', 'other', 'another',
            'own', 'one', 'two', 'three', 'four', 'five', 'first', 'second', 'last', 'next', 'single', 'per', 'more', 'most',
            'many', 'few', 'several'
        ), [System.StringComparer]::OrdinalIgnoreCase)

    # Per source: its options and every concept that declares forms. Sources outside the forms check drop out.
    $sources = [ordered]@{}
    foreach ($item in $Entry) {
        if ($item.Options.checks -notcontains 'forms' -or $item.Concept.forms.Count -eq 0) {
            continue
        }
        if (-not $sources.Contains($item.SourcePath)) {
            $sources[$item.SourcePath] = [pscustomobject]@{
                Options  = $item.Options
                Concepts = [System.Collections.Generic.List[object]]::new()
            }
        }
        $head = @($item.Concept.term -split '[ -]')[-1]
        $stem = if ($head.EndsWith('e')) {
            $head.Substring(0, $head.Length - 1)
        }
        else {
            $head
        }
        $allowed = [System.Collections.Generic.HashSet[string]]::new([string[]] @($item.Concept.forms), [System.StringComparer]::OrdinalIgnoreCase)
        $sources[$item.SourcePath].Concepts.Add([pscustomobject]@{
                Term      = $item.Concept.term
                DefinedBy = $item.Concept.defined_by
                Allowed   = $allowed
                Forms     = (@($item.Concept.forms | ForEach-Object { "$_ $head" }) + $head) -join ', '
                # The qualifier is the last word before the head ('commit' in 'pre-commit gate'), joined by spaces, one
                # line break, or a hyphen.
                Qualified = [regex]::new('(?<![A-Za-z0-9])(?<q>[A-Za-z0-9]+)(?:[ \t]+|[ \t]*\n[ \t]*|-)(?<w>' + [regex]::Escape($head) + 's?)(?![\w-])', 'IgnoreCase')
                # A verb form counts after a hyphen too ('double-gated').
                Verb      = [regex]::new('(?<![A-Za-z0-9])(?<w>' + [regex]::Escape($stem) + '(?:ed|ing))(?![\w-])', 'IgnoreCase')
            })
    }

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
                foreach ($concept in $source.Concepts) {
                    $uses = @(
                        foreach ($match in $concept.Qualified.Matches($segment.Text)) {
                            $qualifier = $match.Groups['q'].Value
                            if (-not $concept.Allowed.Contains($qualifier) -and -not $functionWords.Contains($qualifier) -and $qualifier -notmatch '^\d+$') {
                                $match
                            }
                        }
                        foreach ($match in $concept.Verb.Matches($segment.Text)) {
                            $match
                        }
                    )
                    foreach ($match in $uses) {
                        $line = $segment.Line + ([regex]::Matches($segment.Text.Substring(0, $match.Index), "`n")).Count
                        $use = $match.Value -replace '\s+', ' '
                        $hits.Add([pscustomobject]@{
                                File    = $file
                                Line    = $line
                                Message = "${file}:$line says `"$use`" — `"$($concept.Term)`" takes only: $($concept.Forms) ($($concept.DefinedBy))"
                            })
                    }
                }
            }
        }
    }

    [string[]] @($hits | Sort-Object -Property @{ Expression = 'File' }, @{ Expression = 'Line' }, @{ Expression = 'Message' } -Unique |
            ForEach-Object Message)
}
