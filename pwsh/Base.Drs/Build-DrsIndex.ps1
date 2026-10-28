function Build-DrsIndex {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    # The authored text around the generated tables is data in drs-index.yml, never prose in this function.
    $index = Get-Config -Config drs-index
    $preamble = $index.preamble
    $conventions = $index.conventions

    # Every authored paragraph is reflowed through Prettier's fill, so the generated page is formatter-stable.
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

    $drs = Get-Config -Config drs
    $drsRoot = Resolve-RepoPath $drs.Root
    $indexPath = "$($drs.Root)/index.md"
    $fileOf = (Get-DrsFileIndex @($drs.RuleSets) -DrsRoot $drsRoot).FileOf

    # One aligned code table per domain, in declared order, each row in the exact shape Get-DrsIndex parses.
    $sections = foreach ($domain in $drs.Domains) {
        $rows = foreach ($ruleSet in $domain.RuleSets) {
            $path = $fileOf[$ruleSet.External]
            if (-not $path) {
                throw "Build-DrsIndex: no single decision record file $($drs.Root)/$($domain.Folder)/**/$($ruleSet.Slug).md for $($ruleSet.External)"
            }
            [pscustomobject]@{
                Code   = '`' + $ruleSet.External + '`'
                Record = "[$($ruleSet.Slug)]($path)"
            }
        }

        $codeWidth = [System.Math]::Max(4, (@($rows.Code) | Measure-Object -Property Length -Maximum).Maximum)
        $recordWidth = [System.Math]::Max(6, (@($rows.Record) | Measure-Object -Property Length -Maximum).Maximum)

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
        $lines.Add("| $('Code'.PadRight($codeWidth)) | $('Record'.PadRight($recordWidth)) |")
        $lines.Add("| $('-' * $codeWidth) | $('-' * $recordWidth) |")
        foreach ($row in $rows) {
            $lines.Add("| $($row.Code.PadRight($codeWidth)) | $($row.Record.PadRight($recordWidth)) |")
        }
        $lines -join "`n"
    }

    $content = (& $reflow $preamble) + "`n`n" + ($sections -join "`n`n") + "`n`n" + (& $reflow $conventions) + "`n"

    $content = Format-GeneratedFileHead -Text $content -Path $indexPath
    $target = Resolve-RepoPath $indexPath
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
