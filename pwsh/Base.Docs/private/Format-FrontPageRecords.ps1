function Format-FrontPageRecords {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Docs.FrontPageSection] $Section,

        [Parameter(Mandatory)]
        [string] $Folder
    )

    $drs = Get-Config -Config drs
    # The index comes back as one array object, so it is enumerated, not wrapped again.
    $index = Get-DrsIndex
    $folderPath = Resolve-RepoPath $Folder
    $rows = foreach ($code in $Section.records) {
        $row = $index | Where-Object { $_.Code -ceq $code } | Select-Object -First 1
        Assert-NotNull $row -ErrorText "frontpage.yml: the section '$($Section.id)' names '$code', which the DRS index does not list."
        $recordPath = "$($drs.Root)/$($row.Path -replace '\\', '/')"
        $rule = @(Get-DrsRules -DrsPath (Resolve-RepoPath $recordPath)) | Select-Object -First 1
        Assert-NotNull $rule -ErrorText "Format-FrontPageRecords: '$recordPath' has no rule to summarise."

        # The first sentence of the first rule, its links rebased from the record to the page, so the row reads as the record does.
        $sentence = ($rule.Statement -split '(?<=\.)\s+', 2)[0]
        $sentence = [Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase($sentence, $recordPath, $Folder) -replace '\|', '\|'

        # A reader of the front page meets sentences, never codes: a link a rule names by its code is named by its record's title.
        $sentence = [regex]::Replace($sentence, "\[``?$($drs.CodeForm.Cited)``?\]\((?<target>[^)#]+)(?<anchor>#[^)]*)?\)", {
                param($match)
                $target = [System.IO.Path]::GetRelativePath((Get-RepositoryRoot), [System.IO.Path]::GetFullPath((Join-Path $folderPath $match.Groups['target'].Value)))
                $targetPath = $target -replace '\\', '/'
                $anchor = $match.Groups['anchor'].Value
                # A link to one rule reads as the rule's short phrase, a link to a record as the record's title.
                $name = if ($anchor.StartsWith('#rule-')) {
                    Get-FrontPageRuleTitle -RecordPath $targetPath -Anchor $anchor.Substring(1)
                }
                else {
                    Get-FrontPageRecordTitle -RecordPath $targetPath
                }
                "[$name]($($match.Groups['target'].Value)$anchor)"
            })

        $link = [System.IO.Path]::GetRelativePath($folderPath, (Resolve-RepoPath $recordPath)) -replace '\\', '/'
        [pscustomobject]@{ Record = "[$(Get-FrontPageRecordTitle -RecordPath $recordPath)]($link)"; Rule = $sentence }
    }
    $rows = @($rows)

    # Padded the way the formatter pads a table, so the page is already in its normal form.
    $recordWidth = [System.Math]::Max(6, (@($rows.Record) | Measure-Object -Property Length -Maximum).Maximum)
    $ruleWidth = [System.Math]::Max(4, (@($rows.Rule) | Measure-Object -Property Length -Maximum).Maximum)
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Format-MarkdownParagraph -Text $Section.intro)) {
        $lines.Add($line)
    }
    $lines.Add('')
    $lines.Add("| $('Record'.PadRight($recordWidth)) | $('Rule'.PadRight($ruleWidth)) |")
    $lines.Add("| $('-' * $recordWidth) | $('-' * $ruleWidth) |")
    foreach ($row in $rows) {
        $lines.Add("| $($row.Record.PadRight($recordWidth)) | $($row.Rule.PadRight($ruleWidth)) |")
    }
    $lines -join "`n"
}
