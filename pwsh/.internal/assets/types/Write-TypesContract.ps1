function Write-TypesContract {
    # .SYNOPSIS
    #     Writes the types surface of a combined types assembly to each module group's provided contract, only where the
    # surface moved.
    # .DESCRIPTION
    #     The surface is each public type's name, aliases, display and public members, read from the assembly's metadata;
    # it is what a consumer binds to, so each module's types are the contract types.json in that module's group
    # (Get-TypesContractPath, by the type's namespace), and the source hash stays a local cache key. A types.json whose
    # module no longer builds a type is deleted. Each text is compared with its file first, so an equal surface leaves
    # git clean; it runs in the bootstrap, before the modules load, so the compare-then-write is its own and not
    # Write-FileIfChanged.
    # .PARAMETER Path
    #     The assembly (Catzc.Types.<hash>.dll) to describe.
    # .PARAMETER RepositoryRoot
    #     The repository root the contracts sit under.
    # .OUTPUTS
    #     [pscustomobject] per contract file, with Path and Written, whether the surface moved and the file was written
    # or deleted.
    # .EXAMPLE
    #     Write-TypesContract -Path $dll -RepositoryRoot $root
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes generated contract files only when their content moved; the importer announces it.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The caller (Import-CSharpTypes) announces a written contract through the importer messages.')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The text is what Format-Code (Prettier, printWidth 140) leaves alone, so a regenerate and a format agree: every
    # object one key per line, a string array on one line when it fits the width, else one value per line.
    $width = 140
    $quote = { param([string] $Value) ConvertTo-Json -InputObject $Value -Compress }
    $strings = { param([string] $Indent, [string] $Key, [string[]] $Values, [string] $Tail)
        $inline = "$Indent`"$Key`": [" + ((@($Values) | ForEach-Object { & $quote $_ }) -join ', ') + "]$Tail"
        if ($inline.Length -le $width -or @($Values).Count -eq 0) {
            return $inline
        }
        "$Indent`"$Key`": [`n" + ((@($Values) | ForEach-Object { "$Indent  $(& $quote $_)" }) -join ",`n") + "`n$Indent]$Tail"
    }
    $texts = [ordered]@{}
    foreach ($group in @((Get-TypesAssemblyManifest -Path $Path).Types | Group-Object -Property {
                $_.Name.Substring(0, $_.Name.LastIndexOf('.'))
            })) {
        $contract = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($RepositoryRoot,
                (Get-TypesContractPath -RepositoryRoot $RepositoryRoot -Namespace $group.Name)))
        $blocks = @($group.Group | Sort-Object -Property Name -CaseSensitive | ForEach-Object {
                $members = @($_.Members | ForEach-Object {
                        "        {`n          `"name`": $(& $quote $_.Name),`n          `"kind`": $(& $quote $_.Kind)`n        }"
                    })
                $memberText = if ($members.Count) {
                    "      `"members`": [`n" + ($members -join ",`n") + "`n      ]"
                }
                else {
                    '      "members": []'
                }
                "    {`n      `"name`": $(& $quote $_.Name),`n" +
                (& $strings '      ' 'aliases' $_.Aliases ',') + "`n" +
                (& $strings '      ' 'display' $_.Display ',') + "`n" +
                "$memberText`n    }"
            })
        $texts[$contract] = "{`n  `"types`": [`n" + ($blocks -join ",`n") + "`n  ]`n}`n"
    }

    foreach ($contract in $texts.Keys) {
        if ([System.IO.File]::Exists($contract) -and [System.IO.File]::ReadAllText($contract) -ceq $texts[$contract]) {
            [pscustomobject]@{ Path = $contract; Written = $false }
            continue
        }
        Save-BurstJournalWrite -Path $contract
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($contract)) | Out-Null
        $tmp = "$contract.$PID.tmp"
        [System.IO.File]::WriteAllText($tmp, $texts[$contract], [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($tmp, $contract, $true)
        [pscustomobject]@{ Path = $contract; Written = $true }
    }

    # A module whose types all left keeps no surface: its types.json goes, and a group left empty goes with it.
    $version = [System.IO.Path]::Combine($RepositoryRoot, 'contracts', 'catzc', '0.1.0')
    if ([System.IO.Directory]::Exists($version)) {
        foreach ($group in [System.IO.Directory]::GetDirectories($version)) {
            $stale = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($group, 'types.json'))
            if (-not [System.IO.File]::Exists($stale) -or $texts.Contains($stale)) {
                continue
            }
            Save-BurstJournalWrite -Path $stale
            [System.IO.File]::Delete($stale)
            if (-not [System.IO.Directory]::EnumerateFileSystemEntries($group).GetEnumerator().MoveNext()) {
                [System.IO.Directory]::Delete($group)
            }
            [pscustomobject]@{ Path = $stale; Written = $true }
        }
    }
}
