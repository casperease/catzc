function Get-TypesContractPath {
    # .SYNOPSIS
    #     The repository-relative path of the types surface contract of the module a namespace names.
    # .DESCRIPTION
    #     A type's namespace is Catzc.<module folder>, and the module's group is its track and the folder's normal form
    #     (pwsh.base.types_system for Base.TypesSystem). It runs in the bootstrap, before the tracks and contracts.yml can
    #     be read, so it finds the one group under the repository's current contracts that ends in the folder's normal
    #     form, and with none it derives the group by the form; Test-Contracts pins each against Get-ContractGroup.
    # .PARAMETER RepositoryRoot
    #     The repository root the contract sits under.
    # .PARAMETER Namespace
    #     The namespace of the types, Catzc.<module folder>.
    # .OUTPUTS
    #     [string] The contract file, repository-relative; with no such group yet, the path under the modules track, the
    #     one folder under the root that holds the modules.
    # .EXAMPLE
    #     Get-TypesContractPath -RepositoryRoot $root -Namespace Catzc.Base.TypesSystem
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Namespace
    )

    if (-not $Namespace.StartsWith('Catzc.', [System.StringComparison]::Ordinal)) {
        throw "Get-TypesContractPath: the namespace '$Namespace' is not Catzc.<module folder>, so it names no module."
    }
    $version = 'contracts/catzc/0.1.0'
    $segments = $Namespace.Substring('Catzc.'.Length).Split('.') | ForEach-Object {
        ($_ -creplace '(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])', '_').ToLowerInvariant()
    }
    $short = $segments -join '.'
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
        # No group yet: the modules track is the folder under the repository root that holds the modules, read from the
        # root alone, so a build's staging copy names the same group as the repository it builds.
        $tracks = @([System.IO.Directory]::GetDirectories($RepositoryRoot) |
                Where-Object { [System.IO.File]::Exists([System.IO.Path]::Combine($_, '.internal', 'Catzc.Internal.Types.psm1')) } |
                ForEach-Object { [System.IO.Path]::GetFileName($_) })
        if ($tracks.Count -ne 1) {
            throw "Get-TypesContractPath: no group for $Namespace under $version, and $($tracks.Count) folders under '$RepositoryRoot' hold .internal/Catzc.Internal.Types.psm1; one must, to name the group."
        }
        "$($tracks[0]).$short"
    }
    "$version/$group/types.json"
}
