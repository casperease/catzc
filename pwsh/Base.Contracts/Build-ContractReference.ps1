<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Build-ContractReference.ps1.md"
  header: "generated"
---
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
    $records = (Get-Config -Config drs).Root
    $adr = [System.IO.Path]::GetRelativePath($pageFolder, "$records/repository/api-contracts.md").Replace('\', '/')
    $commandAdr = [System.IO.Path]::GetRelativePath($pageFolder,
        "$records/repository/command-contracts.md").Replace('\', '/')
    $kindText = @{ Presence = 'presence'; Fragment = 'fragment'; Schema = 'schema'; Sample = 'sample payload'; Command = 'command contract' }
    $directionText = @{ DependedOn = 'depended-on'; Provided = 'provided' }
    $headers = @('Group', 'Asset', 'Bound file', 'Direction', 'Kind', 'Signature')
    # Every page this writer emits carries this line; only a page carrying it is ever removed.
    $marker = '`Build-ContractReference` writes this page from'

    $assets = @(Get-Contract -Version '*' -RepositoryRoot $RepositoryRoot)
    $roots = [string[]] @($assets | ForEach-Object { $_.Root } | Select-Object -Unique)
    [System.Array]::Sort($roots, [System.StringComparer]::Ordinal)

    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($rootName in $roots) {
        $rootAssets = @($assets | Where-Object { $_.Root -ceq $rootName })
        $signatures = @{}
        if (@($rootAssets | Where-Object { $_.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command }).Count -gt 0) {
            try {
                foreach ($command in Get-CommandContract -Root ([WildcardPattern]::Escape($rootName)) -Version '*' -RepositoryRoot $RepositoryRoot) {
                    $signatures[$command.Asset.AssetPath] = $command.Signature
                }
            }
            catch {
                foreach ($asset in @($rootAssets | Where-Object { $_.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command })) {
                    try {
                        $one = Get-CommandContract -Root ([WildcardPattern]::Escape($asset.Root)) -Version ([WildcardPattern]::Escape($asset.Version)) `
                            -Module ([WildcardPattern]::Escape($asset.Group)) -Name ([WildcardPattern]::Escape([Catzc.Base.Contracts.ContractCommand]::NameOf($asset))) `
                            -RepositoryRoot $RepositoryRoot
                        $signatures[$asset.AssetPath] = $one.Signature
                    }
                    catch {
                        Write-Verbose "Build-ContractReference: '$($asset.AssetPath)' does not read, so the page shows no signature: $($_.Exception.Message)"
                    }
                }
            }
        }

        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("# $pageFolder/$rootName.md")
        $lines.Add('')
        $lines.Add("``The $rootName contracts``")
        $lines.Add('')
        $lines.Add("The contract assets of the ``$rootName`` root: one table per version folder, then the notes of its assets.")
        $lines.Add('')
        $lines.Add("$marker ``contracts/$rootName/``: edit an asset, its description or its header comment, never this page.")
        $lines.Add('')
        foreach ($line in (Format-MarkdownParagraph -Text 'Each note is the asset''s own: the `description` of a command contract, the `$comment` of a schema, or the leading `#` lines of another YAML asset.')) {
            $lines.Add($line)
        }
        $lines.Add('')
        $lines.Add('A presence asset, a text fragment, and a JSON fragment or sample payload carry no note: a comment would change what they pin.')
        $lines.Add('')
        foreach ($line in (Format-MarkdownParagraph -Text "A command contract's signature is the call interface its contract language states, as ``Get-CommandContract`` reads it; every other kind has none.")) {
            $lines.Add($line)
        }
        $lines.Add('')
        foreach ($line in (Format-MarkdownParagraph -Text "Layout, kinds, and directions: [api-contracts]($adr); command contracts: [command-contracts]($commandAdr).")) {
            $lines.Add($line)
        }

        # The current version first, then the released folders, newest first.
        $versions = [string[]] @($rootAssets | ForEach-Object { $_.Version } | Select-Object -Unique)
        $versions = @($versions | Sort-Object -Property @{ Expression = { $_ -ceq '0.1.0' }; Descending = $true }, @{ Expression = { [version] $_ }; Descending = $true })
        foreach ($version in $versions) {
            $lines.Add('')
            $lines.Add("## $version")
            $lines.Add('')
            $immutable = "[ADR-REPO-CONTRACT-RELEASEDIMMUTABLE]($adr#rule-adr-repo-contract-releasedimmutable)"
            $state = if ($version -ceq '0.1.0') {
                "The current version: edited in place ($immutable)."
            }
            else {
                "Released, so frozen by its ``.frozen`` record ($immutable)."
            }
            foreach ($line in (Format-MarkdownParagraph -Text $state)) {
                $lines.Add($line)
            }
            $lines.Add('')

            $rows = [System.Collections.Generic.List[string[]]]::new()
            $notes = [System.Collections.Generic.List[string]]::new()
            foreach ($asset in @($rootAssets | Where-Object { $_.Version -ceq $version })) {
                $direction = $directionText["$($asset.Direction)"]
                $target = if ($asset.Target) {
                    "``$($asset.Target.Replace('|', '\|'))``"
                }
                else {
                    'none'
                }
                $note = Get-ContractAssetNote -RepositoryRoot $RepositoryRoot -Asset $asset
                if ($note) {
                    $text = "``$($asset.Key)``: $(ConvertTo-ContractNoteMarkdown -Note $note -PageFolder $pageFolder)"
                    foreach ($line in (Format-MarkdownParagraph -Text $text -FirstPrefix '- ' -ContinuationPrefix '  ')) {
                        $notes.Add($line)
                    }
                }
                $assetCell = "``$($asset.Path.Replace('|', '\|'))``"
                $signature = if ($signatures.ContainsKey($asset.AssetPath)) {
                    "``$($signatures[$asset.AssetPath].Replace('|', '\|'))``"
                }
                elseif ($asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
                    'not readable (Test-Contracts reports it)'
                }
                else {
                    'none'
                }
                $rows.Add([string[]] @("``$($asset.Group)``", $assetCell, $target, $direction,
                        $kindText["$($asset.Kind)"], $signature))
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

        $path = Join-Path $RepositoryRoot "$pageFolder/$rootName.md"
        $page = Format-GeneratedFileHead -Text (($lines -join "`n") + "`n") -Path "$pageFolder/$rootName.md"
        $changed = Write-FileIfChanged $path $page -DryRun:$DryRun
        $results.Add([pscustomobject]@{
                Root = $rootName; Path = "$pageFolder/$rootName.md"; Changed = $changed; Removed = $false; DryRun = [bool] $DryRun
                AssetCount = $rootAssets.Count
            })
    }

    # A page this writer emitted whose root has no assets left is removed; a page without the marker is someone's own.
    $folder = Join-Path $RepositoryRoot $pageFolder
    if ([System.IO.Directory]::Exists($folder)) {
        $pages = [Catzc.Base.Folders.PathSet]::new((Get-Config -Config folder-walk)).AddPattern($folder, '*.md',
            1).ToArray()
        foreach ($page in $pages) {
            $rootName = [System.IO.Path]::GetFileNameWithoutExtension($page)
            if ($rootName -cin $roots -or -not [System.IO.File]::ReadAllText($page).Contains($marker)) {
                continue
            }
            if (-not $DryRun) {
                [System.IO.File]::Delete($page)
            }
            $results.Add([pscustomobject]@{
                    Root = $rootName; Path = "$pageFolder/$rootName.md"; Changed = $true; Removed = $true; DryRun = [bool] $DryRun; AssetCount = 0
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
