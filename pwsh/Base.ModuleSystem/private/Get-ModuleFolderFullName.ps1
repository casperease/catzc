<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/private/Get-ModuleFolderFullName.ps1.md"
  header: "generated"
---
#>

function Get-ModuleFolderFullName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

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
