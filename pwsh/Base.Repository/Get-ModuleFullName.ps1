function Get-ModuleFullName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $full = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $manifests = @([System.IO.Directory]::EnumerateFiles($full, '*.psd1'))
    if ($manifests.Count -eq 1) {
        return [System.IO.Path]::GetFileNameWithoutExtension($manifests[0])
    }
    # A staged burst copy, marked by a .burst-base here or one level down, is named by the live module folder it mirrors.
    $levels = @($full) + @([System.IO.Directory]::EnumerateDirectories($full))
    $isStaged = @($levels | Where-Object { @([System.IO.Directory]::EnumerateFiles($_, '*.burst-base')).Count -gt 0 }).Count -gt 0
    if ($isStaged) {
        $live = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/')
        $ancestor = [System.IO.Path]::GetDirectoryName($full)
        while ($ancestor) {
            $mirrored = [System.IO.Path]::Combine($live, [System.IO.Path]::GetRelativePath($ancestor, $full))
            if ([System.IO.Directory]::Exists($mirrored) -and -not $mirrored.Equals($full, [System.StringComparison]::OrdinalIgnoreCase)) {
                return Get-ModuleFullName -Path $mirrored -RepositoryRoot $RepositoryRoot
            }
            $ancestor = [System.IO.Path]::GetDirectoryName($ancestor)
        }
    }
    foreach ($loaded in Get-Module) {
        if ([System.IO.Path]::GetFullPath($loaded.ModuleBase).TrimEnd('\', '/') -eq $full) {
            return $loaded.Name
        }
    }
    [System.IO.Path]::GetFileName($full)
}
