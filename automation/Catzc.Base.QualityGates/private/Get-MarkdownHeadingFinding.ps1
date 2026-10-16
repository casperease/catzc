<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
    folder: private
    name: get-markdown-heading-finding
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-MarkdownHeadingFinding.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD
      - ADR-PWSH-AUTOVAR
  config:
    synopsis: Checks one Markdown file's H2–H6 headings against their normal form and returns the fixed text.
    description: |-
      A heading is plain words: a trailing parenthesized group that holds only code spans and separators — a file
      name, a path, a citation such as (`ADR-AZ-DATAMOD`) — is moved out of the heading onto its own line directly
      below it, the groups joined by ' · ' and a known citation code written as a relative link to its ADR. Code that
      is the subject of a heading (`$Matches` — capture immediately) and a group holding prose stay in the heading. Every
      heading's GitHub anchor is unique within its document. In a dora-explains.md file each H2 entry's DORA paragraph —
      paraphrased research — opens the entry as a > blockquote, which renders as grey text.

      Findings are Reference (a group moved out; the heading's anchor changes from From to To), Quote (a DORA paragraph
      quoted), and Duplicate (an anchor used twice — the author rewords; no fix). Headings inside fenced code blocks and
      YAML front matter are not headings; the H1 is the title and belongs to Get-MarkdownTitleFinding. Fixed is the
      corrected file text, keeping the file's own line endings; it equals the input when there is nothing to fix.
    parameters:
      RelativePath: The file's repository-relative, '/'-separated path.
      Text: The file's content.
      Citation: |-
        Citation code -> repository-relative ADR path, for the links a moved citation becomes. A code not in it stays a
        code span.
    outputs: '[pscustomobject] @{ Path; Findings; Fixed } — each finding is @{ Line; Kind; Actual; Expected; From; To }.'
---
#>

function Get-MarkdownHeadingFinding {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [hashtable] $Citation = @{}
    )

    $newline = if ($Text.Contains("`r`n")) {
        "`r`n"
    }
    else {
        "`n"
    }
    $lines = [System.Collections.Generic.List[string]]::new([string[]] ($Text -split '\r?\n'))
    $directory = [System.IO.Path]::GetDirectoryName($RelativePath) -replace '\\', '/'
    if ($directory -eq '') {
        $directory = '.'
    }

    # A line that is only code spans, links, and separators — what a moved group becomes, and what one may hold.
    $separatorsOnly = '^[\s+,/&·;|-]*$'
    $isReferenceLine = {
        param([string] $Line)
        $Line.Trim() -ne '' -and (($Line -replace '`[^`]*`', '' -replace '\[[^\]]*\]\([^)]*\)', '') -match $separatorsOnly)
    }

    # Index every heading outside front matter and fences: { Index; Level; Text }.
    $start = 0
    if ($lines.Count -gt 1 -and $lines[0] -eq '---') {
        for ($index = 1; $index -lt $lines.Count; $index++) {
            if ($lines[$index] -eq '---') {
                $start = $index + 1
                break
            }
        }
    }
    $headings = [System.Collections.Generic.List[pscustomobject]]::new()
    $fence = $null
    for ($index = $start; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        if ($line -match '^ {0,3}(`{3,}|~{3,})') {
            $marker = $Matches[1]
            if ($null -eq $fence) {
                $fence = $marker
            }
            elseif ($marker[0] -eq $fence[0] -and $marker.Length -ge $fence.Length) {
                $fence = $null
            }
            continue
        }
        if ($null -eq $fence -and $line -match '^ {0,3}(#{1,6})[ \t]+(.*?)(?:[ \t]+#+)?[ \t]*$') {
            $headings.Add([pscustomobject]@{ Index = $index; Level = $Matches[1].Length; Text = $Matches[2] })
        }
    }

    # A heading's normal form: its plain words, and the trailing groups that move out (left to right).
    $split = {
        param([string] $Heading)
        $words = $Heading
        $groups = [System.Collections.Generic.List[string]]::new()
        while ($words -match '^(?<head>.*?)\s*\((?<inner>[^()]*`[^()]*)\)\s*$') {
            $head = $Matches['head']
            $inner = $Matches['inner']
            if ($head.Trim() -eq '' -or ($inner -replace '`[^`]*`', '') -notmatch $separatorsOnly) {
                break
            }
            $groups.Insert(0, $inner.Trim())
            $words = $head.TrimEnd()
        }
        [pscustomobject]@{ Words = $words; Groups = $groups }
    }

    $findings = [System.Collections.Generic.List[pscustomobject]]::new()

    # Duplicates are judged on the normal form, so a fix can never introduce one.
    $seen = @{}
    foreach ($heading in $headings) {
        $slug = [Catzc.Base.Docs.GitHubAnchor]::Slug((& $split $heading.Text).Words)
        if ($seen.ContainsKey($slug)) {
            $findings.Add([pscustomobject]@{
                    Line     = $heading.Index + 1
                    Kind     = 'Duplicate'
                    Actual   = $lines[$heading.Index]
                    Expected = "a heading unique in its document (anchor #$slug is also line $($seen[$slug]))"
                    From     = $null
                    To       = $null
                })
            continue
        }
        $seen[$slug] = $heading.Index + 1
    }

    # dora-explains: each entry's DORA paragraph is quoted. Prefixes only, so no line moves.
    if ($RelativePath -match '(^|/)dora-explains\.md$') {
        foreach ($heading in @($headings | Where-Object Level -EQ 2)) {
            $index = $heading.Index + 1
            while ($index -lt $lines.Count -and ($lines[$index].Trim() -eq '' -or (& $isReferenceLine $lines[$index]))) {
                $index++
            }
            if ($index -ge $lines.Count -or $lines[$index] -match '^\s*(>|#|[-*+]\s|\d+[.)]\s)') {
                continue
            }
            $findings.Add([pscustomobject]@{
                    Line     = $index + 1
                    Kind     = 'Quote'
                    Actual   = $lines[$index]
                    Expected = '> the DORA paragraph as a blockquote'
                    From     = $null
                    To       = $null
                })
            while ($index -lt $lines.Count -and $lines[$index].Trim() -ne '') {
                $lines[$index] = "> $($lines[$index])"
                $index++
            }
        }
    }

    # Move trailing groups out, bottom-up so every recorded index stays valid while lines are inserted.
    for ($position = $headings.Count - 1; $position -ge 0; $position--) {
        $heading = $headings[$position]
        if ($heading.Level -lt 2) {
            continue
        }
        $form = & $split $heading.Text
        if ($form.Groups.Count -eq 0) {
            continue
        }
        $parts = foreach ($group in $form.Groups) {
            if ($group -match '^`(?<code>ADR-[A-Z0-9-]+)`$' -and $Citation.ContainsKey($Matches['code'])) {
                $target = [System.IO.Path]::GetRelativePath($directory, $Citation[$Matches['code']]) -replace '\\', '/'
                "[$($Matches['code'])]($target)"
            }
            else {
                $group
            }
        }
        $fixedHeading = "$('#' * $heading.Level) $($form.Words)"
        $findings.Add([pscustomobject]@{
                Line     = $heading.Index + 1
                Kind     = 'Reference'
                Actual   = $lines[$heading.Index]
                Expected = $fixedHeading
                From     = [Catzc.Base.Docs.GitHubAnchor]::Slug($heading.Text)
                To       = [Catzc.Base.Docs.GitHubAnchor]::Slug($form.Words)
            })
        $lines[$heading.Index] = $fixedHeading
        $insert = [System.Collections.Generic.List[string]]::new([string[]] @('', ($parts -join ' · ')))
        $next = $heading.Index + 1
        if ($next -lt $lines.Count -and $lines[$next].Trim() -ne '') {
            $insert.Add('')
        }
        $lines.InsertRange($next, $insert)
    }

    [pscustomobject]@{
        Path     = $RelativePath
        Findings = @($findings | Sort-Object Line)
        Fixed    = if ($findings.Count -eq 0 -or -not @($findings | Where-Object Kind -NE 'Duplicate')) {
            $Text
        }
        else {
            $lines -join $newline
        }
    }
}
