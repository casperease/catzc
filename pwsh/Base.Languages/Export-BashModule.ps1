function Export-BashModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Destination,

        [switch] $Silent
    )

    $repositoryRoot = Get-RepositoryRoot
    $moduleRelative = if ([System.IO.Path]::IsPathRooted($Module)) {
        [System.IO.Path]::GetRelativePath($repositoryRoot, $Module)
    }
    else {
        $Module
    }
    $moduleRelative = $moduleRelative.Replace('\', '/').TrimEnd('/')

    $files = [System.Collections.Generic.List[string]]::new()
    $files.AddRange([string[]]@(Get-ModuleShippedFile $moduleRelative))
    $executables = [System.Collections.Generic.List[string]]::new()
    $executables.AddRange([string[]]@(Get-ModuleShippedFile $moduleRelative -ExecutableOnly))
    $files.Sort([System.StringComparer]::Ordinal)
    $executables.Sort([System.StringComparer]::Ordinal)

    $null = [System.IO.Directory]::CreateDirectory($Destination)
    $executableMode = [System.IO.UnixFileMode]::UserRead -bor [System.IO.UnixFileMode]::UserWrite -bor [System.IO.UnixFileMode]::UserExecute -bor
    [System.IO.UnixFileMode]::GroupRead -bor [System.IO.UnixFileMode]::GroupExecute -bor
    [System.IO.UnixFileMode]::OtherRead -bor [System.IO.UnixFileMode]::OtherExecute
    foreach ($file in $files) {
        $target = [System.IO.Path]::Combine($Destination, $file)
        $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target))
        [System.IO.File]::Copy([System.IO.Path]::Combine($repositoryRoot, $moduleRelative, $file), $target, $true)
        if (-not $IsWindows -and $executables.Contains($file)) {
            [System.IO.File]::SetUnixFileMode($target, $executableMode)
        }
    }

    # The carrier the installer restores the executable bit from on a POSIX host: a sorted list, one path per line.
    $lines = foreach ($executable in $executables) {
        '  ' + (ConvertTo-Json -InputObject $executable -Compress)
    }
    $manifest = if ($executables.Count) {
        "[`n" + ($lines -join ",`n") + "`n]`n"
    }
    else {
        "[]`n"
    }
    [System.IO.File]::WriteAllText([System.IO.Path]::Combine($Destination, 'executables.json'), $manifest,
        [System.Text.UTF8Encoding]::new($false))

    if (-not $Silent) {
        Write-Message "Packaged bash module $moduleRelative -> $Destination ($($files.Count) files, $($executables.Count) executable)"
    }
    [pscustomobject]@{
        Module      = $moduleRelative
        Destination = $Destination
        Files       = $files.Count
        Executables = $executables.Count
    }
}
