function Resolve-CodeModuleFolder {
    [CmdletBinding(DefaultParameterSetName = 'Folder')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Folder')]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'Bare')]
        [string] $BareName
    )

    $isBuild = (Get-CatzcRunMode) -eq 'build'
    $prefix = 'Catzc.'
    if ($PSCmdlet.ParameterSetName -eq 'Bare') {
        if ($isBuild -and $BareName.StartsWith($prefix, [System.StringComparison]::Ordinal) -and $BareName.Length -gt $prefix.Length) {
            return $BareName.Substring($prefix.Length)
        }
        return $BareName
    }

    if ($Name.StartsWith('.')) {
        return $null
    }
    $folder = if ($isBuild) {
        "$prefix$Name"
    }
    else {
        $Name
    }
    $candidate = [System.IO.Path]::Combine((Get-CatzcModulesRoot), $folder)
    if ([System.IO.Directory]::Exists($candidate)) {
        return $candidate
    }
    $null
}
