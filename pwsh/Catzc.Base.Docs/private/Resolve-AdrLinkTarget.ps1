<#
---
catzc:
  immutable:
    with_body_sha: e420189d9fb5
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
    docs: "[Resolve-AdrLinkTarget.ps1.md](docs/references/pwsh/catzc-base-docs/private/Resolve-AdrLinkTarget.ps1.md)"
    cites:
      - ADR-REPO-LINK-MARKDOWNRELATIVE
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
