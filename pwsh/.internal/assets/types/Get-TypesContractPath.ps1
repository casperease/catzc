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
    #     [string] The contract file, repository-relative; with no such group yet, the path under the modules track, the
    #     one folder under the root that holds this module.
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
        # No group yet: the modules track is the folder under the repository root that holds this module, read from the
        # root alone, so a build's staging copy names the same group as the repository it builds.
        $tracks = @([System.IO.Directory]::GetDirectories($RepositoryRoot) |
                Where-Object { [System.IO.File]::Exists([System.IO.Path]::Combine($_, '.internal', 'Catzc.Internal.Types.psm1')) } |
                ForEach-Object { [System.IO.Path]::GetFileName($_) })
        if ($tracks.Count -ne 1) {
            throw "Get-TypesContractPath: no types group under $version, and $($tracks.Count) folders under '$RepositoryRoot' hold .internal/Catzc.Internal.Types.psm1; one must, to name the group."
        }
        "$($tracks[0]).$short"
    }
    "$version/$group/types.sample.json"
}
