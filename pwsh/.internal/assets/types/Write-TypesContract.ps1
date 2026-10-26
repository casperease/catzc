function Write-TypesContract {
    # .SYNOPSIS
    #     Writes the types surface of a combined types assembly to the provided contract, only when the surface moved.
    # .DESCRIPTION
    #     The surface is each public type's name, aliases and display, read from the assembly's metadata, sorted by
    # name; it is
    #     what a consumer binds to, so it is the contract contracts/catzc/0.1.0/catzc.internal.types/types.sample.json
    # and the
    #     source hash stays a local cache key. The text is compared with the file first, so an equal surface leaves git
    # clean;
    #     it runs in the bootstrap, before the modules load, so the compare-then-write is its own and not
    # Write-FileIfChanged.
    # .PARAMETER Path
    #     The assembly (Catzc.Types.<hash>.dll) to describe.
    # .PARAMETER RepositoryRoot
    #     The repository root the contract sits under.
    # .OUTPUTS
    #     [pscustomobject] with Path, the contract file, and Written, whether the surface moved and the file was
    # written.
    # .EXAMPLE
    #     Write-TypesContract -Path $dll -RepositoryRoot $root
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes a generated contract file only when its content moved; the importer announces it.')]
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

    $contract = [System.IO.Path]::Combine($RepositoryRoot, 'contracts', 'catzc', '0.1.0', 'catzc.internal.types',
        'types.sample.json')
    $types = @((Get-TypesAssemblyManifest -Path $Path).Types | Sort-Object -Property Name -CaseSensitive | ForEach-Object {
            [ordered]@{ name = $_.Name; aliases = @($_.Aliases); display = @($_.Display) }
        })
    # One type per line: the file grows by one line per type, and a diff names exactly the types that moved.
    $lines = @($types | ForEach-Object { '    ' + (ConvertTo-Json -InputObject $_ -Depth 3 -Compress) })
    $text = "{`n  `"types`": [`n" + ($lines -join ",`n") + $(if ($lines.Count) {
            "`n"
        }) + "  ]`n}`n"
    if ([System.IO.File]::Exists($contract) -and [System.IO.File]::ReadAllText($contract) -ceq $text) {
        return [pscustomobject]@{ Path = $contract; Written = $false }
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($contract)) | Out-Null
    $tmp = "$contract.$PID.tmp"
    [System.IO.File]::WriteAllText($tmp, $text, [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::Move($tmp, $contract, $true)
    [pscustomobject]@{ Path = $contract; Written = $true }
}
