function Build-AdrIndex {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    # The authored text around the generated tables is data in adr-index.yml, never prose in this function.
    $index = Get-Config -Config adr-index
    $preamble = $index.preamble
    $conventions = $index.conventions

    $reflow = {
        param([string] $Markdown)
        $out = [System.Collections.Generic.List[string]]::new()
        $block = $null
        $flush = {
            if ($block) {
                $prefix = if ($block.IsItem) {
                    '- '
                }
                else {
                    ''
                }
                $continuation = if ($block.IsItem) {
                    '  '
                }
                else {
                    ''
                }
                foreach ($wrapped in (Format-MarkdownParagraph -Text $block.Text -FirstPrefix $prefix -ContinuationPrefix $continuation)) {
                    $out.Add($wrapped)
                }
            }
        }
        foreach ($sourceLine in ($Markdown.TrimEnd() -split '\r?\n')) {
            if ($sourceLine -match '^\s*$' -or $sourceLine.StartsWith('#')) {
                . $flush
                $block = $null
                $out.Add($sourceLine.TrimEnd())
            }
            elseif ($sourceLine.StartsWith('- ')) {
                . $flush
                $block = @{ IsItem = $true; Text = $sourceLine.Substring(2) }
            }
            elseif ($block) {
                $block.Text += ' ' + $sourceLine.Trim()
            }
            else {
                $block = @{ IsItem = $false; Text = $sourceLine.Trim() }
            }
        }
        . $flush
        $out -join "`n"
    }

    $adrs = Get-Config -Config adrs
    $adrDocsRoot = Resolve-RepoPath 'docs/adr'
    $fileOf = (Get-AdrFileIndex @($adrs.RuleSets) -AdrRoot $adrDocsRoot).FileOf

    $sections = foreach ($domain in $adrs.Domains) {
        $rows = foreach ($ruleSet in $domain.RuleSets) {
            $path = $fileOf[$ruleSet.External]
            if (-not $path) {
                throw "Build-AdrIndex: no single ADR file docs/adr/$($domain.Folder)/**/$($ruleSet.Slug).md for $($ruleSet.External)"
            }
            [pscustomobject]@{
                Code = '`' + $ruleSet.External + '`'
                Adr  = "[$($ruleSet.Slug)]($path)"
            }
        }

        $codeWidth = [System.Math]::Max(4, (@($rows.Code) | Measure-Object -Property Length -Maximum).Maximum)
        $adrWidth = [System.Math]::Max(3, (@($rows.Adr) | Measure-Object -Property Length -Maximum).Maximum)

        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("### $($domain.Folder)/")
        $lines.Add('')

        # The domain's description, filled the way Prettier fills it (formatter-stable, like the authored prose).
        foreach ($line in (Format-MarkdownParagraph -Text $domain.Description)) {
            $lines.Add($line)
        }
        $lines.Add('')

        $dependsOn = if ($domain.DependsOn.Count) {
            (@($domain.DependsOn) | ForEach-Object { "``$_``" }) -join ', '
        }
        else {
            'none'
        }
        $lines.Add("**Role:** ``$($domain.Role)`` — **depends on:** $dependsOn.")
        $lines.Add('')
        $lines.Add("| $('Code'.PadRight($codeWidth)) | $('ADR'.PadRight($adrWidth)) |")
        $lines.Add("| $('-' * $codeWidth) | $('-' * $adrWidth) |")
        foreach ($row in $rows) {
            $lines.Add("| $($row.Code.PadRight($codeWidth)) | $($row.Adr.PadRight($adrWidth)) |")
        }
        $lines -join "`n"
    }

    $content = (& $reflow $preamble) + "`n`n" + ($sections -join "`n`n") + "`n`n" + (& $reflow $conventions) + "`n"

    $content = Format-GeneratedFileHead -Text $content -Path 'docs/adr/index.md' -Generator Build-AdrIndex -Source (ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/adrs.yml')) -FileKind (Get-FileKind 'docs/adr/index.md')
    $target = Resolve-RepoPath 'docs/adr/index.md'
    $changed = Write-FileIfChanged $target $content -DryRun:$DryRun

    $relativeTarget = ConvertTo-RepoRelativePath $target
    if ($changed -and -not $Silent) {
        $verb = if ($DryRun) {
            'would write'
        }
        else {
            'wrote'
        }
        Write-Message "$verb $relativeTarget"
    }

    if ($PassThru) {
        [pscustomobject]@{ Path = $relativeTarget; Changed = $changed; DryRun = [bool]$DryRun }
    }
    else {
        $relativeTarget
    }
}
