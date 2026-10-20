<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1
    folder: private
    name: get-markdown-scope
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-MarkdownScope.Tests.ps1
    docs: "[Get-MarkdownScope.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-KINDSCOPE
      - ADR-REPO-FORMAT-MARKDOWNTITLE
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
