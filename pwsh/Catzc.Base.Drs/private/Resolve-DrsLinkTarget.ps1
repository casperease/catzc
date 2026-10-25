<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/private/Resolve-DrsLinkTarget.ps1.md"
  warning: "Generated Header"
---
#>

function Resolve-DrsLinkTarget {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $DrsRoot,

        [Parameter(Mandatory)]
        [string] $From,

        [Parameter(Mandatory, Position = 0)]
        [string] $Target
    )

    $file = $Target.Split('#')[0]
    if ($file -eq '' -or $file.StartsWith('/') -or $file -match '^[A-Za-z][A-Za-z0-9+.-]*:') {
        return
    }

    $root = [System.IO.Path]::GetFullPath($DrsRoot).TrimEnd('\', '/')
    $folder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::Combine($root, $From))
    $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($folder, $file))
    $prefix = $root + [System.IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return
    }
    $full.Substring($prefix.Length).Replace('\', '/')
}
