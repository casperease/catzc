function Get-TypesContractPath {
    # .SYNOPSIS
    #     The repository-relative path of the types surface contract.
    # .DESCRIPTION
    #     Its group is this module's track and short name (pwsh.internal.types). It runs in the bootstrap, before the
    #     tracks can be read, so it finds the one group under the repository's current contracts that ends in the
    #     module's short name, instead of spelling the track.
    # .PARAMETER RepositoryRoot
    #     The repository root the contract sits under.
    # .OUTPUTS
    #     [string] The contract file, repository-relative; with no such group yet, the path under the modules track.
    # .EXAMPLE
    #     Get-TypesContractPath -RepositoryRoot $root
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $version = 'contracts/catzc/0.1.0'
    $short = 'Catzc.Internal.Types'.Substring('Catzc.'.Length).ToLowerInvariant()
    $folder = [System.IO.Path]::Combine($RepositoryRoot, $version)
    $groups = @(if ([System.IO.Directory]::Exists($folder)) {
            [System.IO.Directory]::GetDirectories($folder, "*.$short") | ForEach-Object { [System.IO.Path]::GetFileName($_) }
        })
    if ($groups.Count -gt 1) {
        throw "Get-TypesContractPath: $($groups.Count) groups under $version end in '.$short' ($($groups -join ', ')); one module has one group."
    }
    $group = if ($groups.Count -eq 1) {
        $groups[0]
    }
    else {
        # No group yet: the modules track is the folder that holds this module's .internal folder.
        "$([System.IO.Path]::GetFileName([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..')))).$short"
    }
    "$version/$group/types.sample.json"
}
