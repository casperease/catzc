function Get-WorkingRootModuleFolder {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string] $ModulesRoot
    )

    if ($ModulesRoot) {
        $root = $ModulesRoot
    }
    elseif ((Get-CatzcRunMode) -eq 'build') {
        # Build mode reads the working root's own modules tracks by layout, never the code root the bundle installed.
        $repositoryRoot = Get-RepositoryRoot
        $engineTrack = Get-Track -Name pwsh
        $folders = foreach ($track in @(Get-Track).Where({ $_.type -ceq 'modules' -and $_.name -cne $engineTrack.name })) {
            foreach ($place in $track.places) {
                $placeDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $place))
                if ([System.IO.Directory]::Exists($placeDirectory)) {
                    Get-ChildPath $placeDirectory -Directory -Depth 1
                }
            }
        }
        return @($folders | Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') })
    }
    else {
        $root = Get-CatzcModulesRoot
    }

    @(Get-ChildPath $root -Directory -Depth 1 | Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') })
}
