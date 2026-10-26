<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-ModuleFullName.ps1.md"
  header: "generated"
---
#>

function Get-ModuleFullName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $full = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $manifests = @([System.IO.Directory]::EnumerateFiles($full, '*.psd1'))
    if ($manifests.Count -eq 1) {
        return [System.IO.Path]::GetFileNameWithoutExtension($manifests[0])
    }
    foreach ($loaded in Get-Module) {
        if ([System.IO.Path]::GetFullPath($loaded.ModuleBase).TrimEnd('\', '/') -eq $full) {
            return $loaded.Name
        }
    }
    [System.IO.Path]::GetFileName($full)
}
