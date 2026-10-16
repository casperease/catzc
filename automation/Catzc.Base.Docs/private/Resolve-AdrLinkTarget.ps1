<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Resolve-AdrLinkTarget.ps1
    folder: private
    name: resolve-adr-link-target
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
    adrs:
      - ADR-REPO-LINK#2
  config:
    synopsis: Resolves a markdown link's target, written in a file under docs/adr/, to its path under docs/adr/.
    description: |-
      A markdown link is relative to its own file ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). This
      drops the target's #fragment, resolves the rest against the linking file's folder, and returns the result relative to docs/adr/
      ('/'-separated). It returns nothing for a link that names no file under docs/adr/: an in-page anchor, an absolute URL, a
      repository-rooted path, or a relative path that leaves docs/adr/.

      Private helper for the citation-graph and DORA-coverage checks of Test-AdrRegistry; not exported.
    parameters:
      AdrRoot: The absolute docs/adr/ folder.
      From: The linking file's path under docs/adr/ ('/'-separated).
      Target: The link's target, as written between the parentheses.
    outputs: '[string] The target''s path under docs/adr/, or nothing.'
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
