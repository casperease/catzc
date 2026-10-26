function Build-FrontPage {
    [CmdletBinding()]
    [OutputType([string], [pscustomobject])]
    param(
        [Catzc.Base.Docs.FrontPageConfig] $Config = (Get-Config -Config frontpage),

        [string] $Path = (Resolve-RepoPath $Config.target),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $sections = @(Get-FrontPageSection -Config $Config)
    $anchors = @{}
    foreach ($section in $sections) {
        $anchors[$section.Id] = $section.Anchor
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("# $($Config.title)")
    $lines.Add('')
    foreach ($line in (Format-MarkdownParagraph -Text $Config.tagline)) {
        $lines.Add($line)
    }

    # Reference-style badges keep the badge line short; a badge leads to a section by its id or to a URL as given.
    if ($Config.badges.Count -gt 0) {
        $lines.Add('')
        $lines.Add((@(for ($i = 0; $i -lt $Config.badges.Count; $i++) {
                        $badge = $Config.badges[$i]
                        $to = if ($badge.to.Contains('://')) {
                            $badge.to
                        }
                        else {
                            "#$($anchors[$badge.to])"
                        }
                        "[![$($badge.label)][badge-$($i + 1)]]($to)"
                    }) -join ' '))
        $lines.Add('')
        for ($i = 0; $i -lt $Config.badges.Count; $i++) {
            $lines.Add("[badge-$($i + 1)]: $($Config.badges[$i].ImageUrl())")
        }
    }

    foreach ($section in $sections) {
        $lines.Add('')
        $lines.Add('---')
        $lines.Add('')
        $lines.Add($section.Markdown)
    }
    $lines.Add('')
    $lines.Add('---')
    $lines.Add('')
    $lines.Add("**$($Config.closing)**")

    # The front page speaks to a person, so a link names a decision record by a sentence, never by its code.
    $codeLinks = [regex]::Matches(($lines -join "`n"), "\[``?$((Get-Config -Config drs).CodeForm.Cited)``?\]\(")
    $coded = @(foreach ($match in $codeLinks) {
            $match.Value
        })
    Assert-True ($coded.Count -eq 0) -ErrorText "Build-FrontPage: a front-page link names a decision record by its code; write a sentence instead: $($coded -join ', ')"

    $relativePath = ConvertTo-RepoRelativePath $Path
    $body = Format-MarkdownTablePadding -Text (Format-LongMarkdownLines -Text (($lines -join "`n") + "`n"))
    $content = Format-GeneratedFileHead -Text $body -Path $relativePath
    $changed = Write-FileIfChanged $Path $content -DryRun:$DryRun

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
        [pscustomobject]@{ Path = $relativePath; Changed = $changed; DryRun = [bool]$DryRun; SectionCount = $sections.Count }
    }
    else {
        $relativePath
    }
}
