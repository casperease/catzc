<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Resolve-AdrLinkTarget.ps1
    folder: private
    name: resolve-adr-link-target
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
    cites:
      - ADR-REPO-LINK#2
---
#>

function Resolve-AdrLinkTarget {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $AdrRoot,

        [Parameter(Mandatory)]
        [string] $From,

        [Parameter(Mandatory, Position = 0)]
        [string] $Target
    )

    $file = $Target.Split('#')[0]
    if ($file -eq '' -or $file.StartsWith('/') -or $file -match '^[A-Za-z][A-Za-z0-9+.-]*:') {
        return
    }

    $root = [System.IO.Path]::GetFullPath($AdrRoot).TrimEnd('\', '/')
    $folder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::Combine($root, $From))
    $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($folder, $file))
    $prefix = $root + [System.IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return
    }
    $full.Substring($prefix.Length).Replace('\', '/')
}
