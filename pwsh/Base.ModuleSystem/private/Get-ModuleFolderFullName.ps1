function Get-ModuleFolderFullName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    # A module folder drops the namespace its full name carries: the loaded module names it, else the manifest the bootstrap
    # wrote from the resolver, else the folder is its own name (a local module carries no namespace).
    $full = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $loaded = Get-Module | Where-Object { [System.IO.Path]::GetFullPath($_.ModuleBase).TrimEnd('\', '/') -eq $full } |
        Select-Object -First 1
    if ($loaded) {
        return $loaded.Name
    }
    $manifests = @([System.IO.Directory]::EnumerateFiles($full, '*.psd1'))
    if ($manifests.Count -eq 1) {
        return [System.IO.Path]::GetFileNameWithoutExtension($manifests[0])
    }
    [System.IO.Path]::GetFileName($full)
}
