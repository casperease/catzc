<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#5
      - ADR-REPO-FORMAT#6
---
#>

<#
.SYNOPSIS
    Lists the repository-relative Markdown files in the file class the title and the meta block share.
.DESCRIPTION
    A gitignored generated README is out of scope while its tracked source is in, because only tracked files count.
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.PARAMETER OptOut
    A `.gitattributes` attribute whose `unset` value takes one file out of this scope. Default: none, every file of the class is in.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths.
#>
function Get-MarkdownScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [string] $OptOut
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-MarkdownScope

    $markdown = @(Get-GitTrackedPath $lookup | Where-Object { $_ -like '*.md' })
    if ($markdown.Count -eq 0) {
        return , [string[]] @()
    }

    # Get-ContentExemptPath returns one array, so it is assigned first and the set holds paths, not the array.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md#comment2)
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = if ($OptOut) {
        Get-GitAttributeValue -RepositoryRoot $root -Path $markdown -Attribute $OptOut
    }
    else {
        @{}
    }
    , [string[]] @($markdown | Where-Object {
            $classes = $attributes[$_]
            -not $exempt.Contains($_) -and -not ($OptOut -and $classes -and $classes[$OptOut] -eq 'unset')
        })
}
