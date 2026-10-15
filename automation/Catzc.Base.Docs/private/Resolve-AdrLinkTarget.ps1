<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Resolve-AdrLinkTarget.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-LINK#2
---
#>

<#
.SYNOPSIS
    Resolves a markdown link's target, written in a file under docs/adr/, to its path under docs/adr/.
.DESCRIPTION
    Nothing comes back for anchors, URLs, rooted paths or paths that leave docs/adr/, so callers skip those links.
    [ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Resolve-AdrLinkTarget.ps1.md#comment1)
.PARAMETER AdrRoot
    The absolute docs/adr/ folder.
.PARAMETER From
    The linking file's path under docs/adr/ ('/'-separated).
.PARAMETER Target
    The link's target, as written between the parentheses.
.OUTPUTS
    [string] The target's path under docs/adr/, or nothing.
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
