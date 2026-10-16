<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-MarkdownScope.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#5
      - ADR-REPO-FORMAT#6
  config:
    synopsis: Lists the repository-relative Markdown files in the file class the title and the meta block share.
    description: |-
      Every git-tracked *.md file — the repository as committed, so a gitignored generated README is never in scope while
      its tracked source is — minus the files the content tools leave as written (Get-ContentExemptPath: vendored,
      generated, fixture, or contract asset) and those whose OptOut attribute .gitattributes marks unset (the meta block's
      -catzc-meta; the title has none). No list of its own: a new exception is declared in the .gitattributes source
      like every other file class.
    parameters:
      RepositoryRoot: The repository root the returned paths are relative to.
      Path: Optional files or folders (absolute or relative to the current location) to limit the scope to.
      OptOut: 'A `.gitattributes` attribute whose `unset` value takes one file out of this scope. Default: none, every file of the class is in.'
    outputs: '[string[]] repository-relative, ''/''-separated paths.'
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
