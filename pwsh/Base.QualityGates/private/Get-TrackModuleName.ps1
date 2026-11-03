function Get-TrackModuleName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $repositoryRoot = Get-RepositoryRoot
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $engineTrack = Get-Track -Name pwsh
    foreach ($track in @(Get-Track).Where({ $_.type -ceq 'modules' -and $_.name -cne $engineTrack.name })) {
        foreach ($place in $track.places) {
            $placeDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $place)).TrimEnd('\', '/')
            $prefix = "$placeDirectory$([System.IO.Path]::DirectorySeparatorChar)"
            if ($fullPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                $folder = ($fullPath.Substring($prefix.Length) -split '[\\/]')[0]
                return $track.FullNameOf($folder)
            }
        }
    }
}
