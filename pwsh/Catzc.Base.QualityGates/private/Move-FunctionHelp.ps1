<#
---
catzc:
  immutable:
    with_body_sha: "1569e05c481c"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Move-FunctionHelp.Tests.ps1
    docs: "[Move-FunctionHelp.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Move-FunctionHelp.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-NOREADBACK
      - ADR-REPO-HELP-HELPONCOMMENTPAGE
---
#>

function Move-FunctionHelp {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $RestsOn = @(),

        [switch] $DryRun
    )

    # A caller that hands an empty list through a scope boundary hands $null, so the list is rebuilt before it is counted.
    $RestsOn = [string[]] @($RestsOn | Where-Object { $_ })
    $helpKeys = 'synopsis', 'description', 'parameters', 'inputs', 'outputs', 'examples', 'notes'
    $full = Join-Path $RepositoryRoot $Path
    $text = [System.IO.File]::ReadAllText($full)
    $form = (Get-Config -Config file-carriers).Find('powershell').Form()
    $state = Get-CodeMetaState -Text $text -Form $form
    $page = Get-CommentPage -Path $Path -Config (Get-Config -Config comment-pages)
    $outcome = [pscustomobject]@{ Path = $Path; Page = $page; Moved = $false; Reason = $null; Text = $text; PageText = $null }
    if ($state.ConfigLines.Count -eq 0) {
        $outcome.Reason = 'the head holds no help'
        return $outcome
    }
    Assert-NotNull $page -ErrorText "Move-FunctionHelp: the comment-pages config maps '$Path' to no comment page, so its help has nowhere to go."

    $yaml = (@($state.ConfigLines | ForEach-Object { if ($_.Length -ge 4) {
                    $_.Substring(4)
                }
                else {
                    $_
                } }) -join "`n")
    try {
        $config = ConvertFrom-Yaml -Yaml $yaml -Ordered
    }
    catch {
        $outcome.Reason = "the head's config does not parse as YAML: $($_.Exception.Message)"
        return $outcome
    }
    if ($config -isnot [System.Collections.IDictionary]) {
        $outcome.Reason = "the head's config part is not a map"
        return $outcome
    }
    $foreign = @($config.Keys | Where-Object { $_ -notin $helpKeys })
    if ($foreign.Count -gt 0) {
        $outcome.Reason = "the head's config holds keys that are no help keys ($($foreign -join ', ')): move them by hand"
        return $outcome
    }

    $pageFull = Join-Path $RepositoryRoot $page
    $pageText = if ([System.IO.File]::Exists($pageFull)) {
        [System.IO.File]::ReadAllText($pageFull)
    }
    else {
        [Catzc.Base.QualityGates.CommentEngine]::FreshPage($Path)
    }
    if ($RestsOn.Count -gt 0) {
        $list = if ($RestsOn.Count -eq 1) {
            $RestsOn[0]
        }
        else {
            ($RestsOn[0..($RestsOn.Count - 2)] -join ', ') + ' and ' + $RestsOn[-1]
        }
        $sentence = "It rests on $list."
        $config['description'] = if ($config.Contains('description') -and "$($config['description'])".Trim()) {
            "$($config['description'])".TrimEnd() + "`n`n" + $sentence
        }
        else {
            $sentence
        }
    }
    $section = [Catzc.Base.QualityGates.FunctionHelp]::FromConfig($config).ToSection()
    $outcome.PageText = [Catzc.Base.QualityGates.FunctionHelp]::WithSection($pageText, $section)
    $outcome.Text = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $form).WithoutConfig()
    $outcome.Moved = $true
    if (-not $DryRun) {
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($pageFull)) | Out-Null
        [System.IO.File]::WriteAllText($pageFull, $outcome.PageText, $utf8NoBom)
        [System.IO.File]::WriteAllText($full, $outcome.Text, $utf8NoBom)
    }
    $outcome
}
