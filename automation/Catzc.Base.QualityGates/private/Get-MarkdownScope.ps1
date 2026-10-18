<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1
    folder: private
    name: get-markdown-scope
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-MarkdownScope.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#5
      - ADR-REPO-FORMAT#6
---
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
