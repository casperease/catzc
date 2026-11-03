function Get-GoTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    # The package path is the module line of the go.mod (the holder's in the folder, a module's above its tests/) plus the path inside it.
    $folderFull = [System.IO.Path]::GetFullPath($Folder).TrimEnd('\', '/')
    $modFile = $null
    foreach ($candidate in @($folderFull, [System.IO.Path]::GetDirectoryName($folderFull))) {
        if (-not $modFile -and $candidate -and (Test-Path -LiteralPath (Join-Path $candidate 'go.mod') -PathType Leaf)) {
            $modFile = Join-Path $candidate 'go.mod'
        }
    }
    if (-not $modFile) {
        throw "$Folder has no go.mod, in it or above it — it is generated; regenerate with: Build-RootConfig"
    }
    $moduleLine = [regex]::Match([System.IO.File]::ReadAllText($modFile), '(?m)^module\s+(\S+)\s*$')
    if (-not $moduleLine.Success) {
        throw "$modFile has no module line."
    }
    $inside = [System.IO.Path]::GetRelativePath([System.IO.Path]::GetDirectoryName($modFile), $folderFull).Replace('\', '/')
    $modulePath = if ($inside -eq '.') {
        $moduleLine.Groups[1].Value
    }
    else {
        "$($moduleLine.Groups[1].Value)/$inside"
    }
    $integrityPrefix = [Catzc.Base.Languages.GoTestResult]::IntegrityPrefix
    $declaration = [regex]::new('(?m)^func\s+(Test(?![a-z])\w*)\s*\(\s*\w+\s+\*testing\.T\s*\)')

    # A module folder holds its Go tests directly or in a package one level down; the third level is headroom.
    $files = @(Get-ChildPath $Folder -File -Filter '*_test.go' -Depth 3)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relativeFolder = [System.IO.Path]::GetRelativePath($Folder,
            [System.IO.Path]::GetDirectoryName($file)).Replace('\', '/')
        if ($relativeFolder -eq '.') {
            $relativeFolder = ''
        }
        $ignored = $false
        foreach ($segment in ($relativeFolder -split '/')) {
            if ($segment -and ($segment.StartsWith('.') -or $segment.StartsWith('_') -or $segment -eq 'testdata')) {
                $ignored = $true
            }
        }
        if ($ignored) {
            continue
        }

        $package = if ($relativeFolder) {
            "$modulePath/$relativeFolder"
        }
        else {
            $modulePath
        }
        foreach ($match in $declaration.Matches([System.IO.File]::ReadAllText($file))) {
            $name = $match.Groups[1].Value
            $category = if ($name.StartsWith($integrityPrefix, [System.StringComparison]::Ordinal)) {
                'integrity'
            }
            else {
                'logic'
            }
            $title = if ($relativeFolder) {
                "$relativeFolder/$name"
            }
            else {
                $name
            }
            [pscustomobject]@{
                Key      = "$package $name"
                Package  = $package
                Name     = $name
                Category = $category
                Title    = $title
            }
        }
    }
}
