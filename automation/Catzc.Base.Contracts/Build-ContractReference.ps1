<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Build-ContractReference.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: public
    adrs:
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-FORMAT#5
      - ADR-REPO-README#7
---
#>

<#
.SYNOPSIS
    Generates the contract reference: one page per unit, docs/references/contracts/<unit>.md, listing every contract
    asset of every version folder with its note.
.DESCRIPTION
    A page is removed only when it carries this writer's marker line, so a hand-written page is never touched.
    [comment:1](/docs/references/automation/catzc-base-contracts/Build-ContractReference.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root that holds contracts/ and docs/references/contracts/. Default: the loaded repository root.
.PARAMETER DryRun
    Report which pages would change without writing or removing any.
.PARAMETER Silent
    Write no message.
.PARAMETER PassThru
    Return one { Unit; Path; Changed; Removed; DryRun; AssetCount } per page instead of the page paths.
.OUTPUTS
    [string[]] The repository-relative page paths; with -PassThru, [pscustomobject[]] one per page, in unit order.
.EXAMPLE
    Build-ContractReference
.EXAMPLE
    Build-ContractReference -DryRun -PassThru
#>
function Build-ContractReference {
    [CmdletBinding()]
    [OutputType([string[]], [pscustomobject[]])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $pageFolder = 'docs/references/contracts'
    $adr = '../../adr/repository/api-contracts.md'
    $kindText = @{ Presence = 'presence'; Fragment = 'fragment'; Schema = 'schema'; Sample = 'sample payload' }
    $directionText = @{ DependedOn = 'depended-on'; Provided = 'provided' }
    $headers = @('Module', 'Asset', 'Target', 'Direction', 'Kind')
    # Every page this writer emits carries this line; only a page carrying it is ever removed.
    $marker = '`Build-ContractReference` writes this page from'

    $assets = @(Get-Contract -Version '*' -RepositoryRoot $RepositoryRoot)
    $units = [string[]] @($assets | ForEach-Object { $_.Unit } | Select-Object -Unique)
    [System.Array]::Sort($units, [System.StringComparer]::Ordinal)

    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($unit in $units) {
        $unitAssets = @($assets | Where-Object { $_.Unit -ceq $unit })

        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("# $pageFolder/$unit.md")
        $lines.Add('')
        $lines.Add("``The $unit contracts``")
        $lines.Add('')
        $lines.Add("The contract assets of the ``$unit`` unit: one table per version folder, then the notes of its assets.")
        $lines.Add('')
        $lines.Add("$marker ``contracts/$unit/``: edit an asset or its header comment, never this page.")
        $lines.Add('')
        $lines.Add('Each note is the asset''s own header comment: the leading `#` lines of a YAML asset, or the `$comment` of a schema.')
        $lines.Add('')
        $lines.Add('A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.')
        $lines.Add('')
        $lines.Add("Layout, kinds, and directions: [api-contracts]($adr).")

        # The draft first, then the released folders, newest first.
        $versions = [string[]] @($unitAssets | ForEach-Object { $_.Version } | Select-Object -Unique)
        $versions = @($versions | Sort-Object -Property @{ Expression = { $_ -ceq '0.0.0' }; Descending = $true }, @{ Expression = { [version] $_ }; Descending = $true })
        foreach ($version in $versions) {
            $lines.Add('')
            $lines.Add("## $version")
            $lines.Add('')
            if ($version -ceq '0.0.0') {
                $lines.Add("The draft: the one mutable version folder ([ADR-REPO-CONTRACT#5]($adr#rule-adr-repo-contract5)).")
            }
            else {
                $lines.Add("Released, so frozen by its ``.frozen`` record ([ADR-REPO-CONTRACT#5]($adr#rule-adr-repo-contract5)).")
            }
            $lines.Add('')

            $rows = [System.Collections.Generic.List[string[]]]::new()
            $notes = [System.Collections.Generic.List[string]]::new()
            foreach ($asset in @($unitAssets | Where-Object { $_.Version -ceq $version })) {
                $direction = $directionText["$($asset.Direction)"]
                if ($asset.IsDirectionOverridden) {
                    $direction += ' (contract.yml)'
                }
                $target = if ($asset.Target) {
                    "``$($asset.Target.Replace('|', '\|'))``"
                }
                else {
                    'none'
                }
                $note = Get-ContractAssetNote -RepositoryRoot $RepositoryRoot -Asset $asset
                if ($note) {
                    $text = "``$($asset.Module)/$($asset.Path)``: $(ConvertTo-ContractNoteMarkdown -Note $note -PageFolder $pageFolder)"
                    foreach ($line in (Format-MarkdownParagraph -Text $text -FirstPrefix '- ' -ContinuationPrefix '  ')) {
                        $notes.Add($line)
                    }
                }
                $assetCell = "``$($asset.Path.Replace('|', '\|'))``"
                $rows.Add([string[]] @("``$($asset.Module)``", $assetCell, $target, $direction, $kindText["$($asset.Kind)"]))
            }

            # Aligned as Prettier aligns a table, so the page is formatter-stable.
            $widths = [int[]]::new($headers.Count)
            for ($column = 0; $column -lt $headers.Count; $column++) {
                $widths[$column] = [System.Math]::Max(3, $headers[$column].Length)
                foreach ($row in $rows) {
                    $widths[$column] = [System.Math]::Max($widths[$column], $row[$column].Length)
                }
            }
            $rule = [string[]] @($widths | ForEach-Object { '-' * $_ })
            foreach ($cells in @(, $headers) + @(, $rule) + $rows) {
                $padded = for ($column = 0; $column -lt $cells.Count; $column++) {
                    $cells[$column].PadRight($widths[$column])
                }
                $lines.Add("| $($padded -join ' | ') |")
            }

            if ($notes.Count) {
                $lines.Add('')
                $lines.Add('Notes:')
                $lines.Add('')
                $lines.AddRange($notes)
            }
        }

        $path = Join-Path $RepositoryRoot "$pageFolder/$unit.md"
        $page = Format-GeneratedFileHead -Text (($lines -join "`n") + "`n") -Path "$pageFolder/$unit.md" -Generator Build-ContractReference -Source "contracts/$unit" -Tracked
        $changed = Write-FileIfChanged $path $page -DryRun:$DryRun
        $results.Add([pscustomobject]@{
                Unit = $unit; Path = "$pageFolder/$unit.md"; Changed = $changed; Removed = $false; DryRun = [bool] $DryRun
                AssetCount = $unitAssets.Count
            })
    }

    # A page this writer emitted whose unit has no assets left is removed; a page without the marker is someone's own.
    $folder = Join-Path $RepositoryRoot $pageFolder
    if ([System.IO.Directory]::Exists($folder)) {
        $pages = [string[]] [System.IO.Directory]::GetFiles($folder, '*.md')
        [System.Array]::Sort($pages, [System.StringComparer]::Ordinal)
        foreach ($page in $pages) {
            $unit = [System.IO.Path]::GetFileNameWithoutExtension($page)
            if ($unit -cin $units -or -not [System.IO.File]::ReadAllText($page).Contains($marker)) {
                continue
            }
            if (-not $DryRun) {
                [System.IO.File]::Delete($page)
            }
            $results.Add([pscustomobject]@{
                    Unit = $unit; Path = "$pageFolder/$unit.md"; Changed = $true; Removed = $true; DryRun = [bool] $DryRun; AssetCount = 0
                })
        }
    }

    foreach ($result in $results) {
        if ($result.Changed -and -not $Silent) {
            $verb = if ($result.Removed) {
                'remove'
            }
            else {
                'write'
            }
            $said = if ($DryRun) {
                "would $verb"
            }
            elseif ($result.Removed) {
                'removed'
            }
            else {
                'wrote'
            }
            Write-Message "$said $($result.Path)"
        }
        if ($PassThru) {
            $result
        }
        else {
            $result.Path
        }
    }
}
