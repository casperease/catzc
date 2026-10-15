<#
.SYNOPSIS
    Lists the files whose long comments live in a comment page, each with its file language and page.
.DESCRIPTION
    The one scope Export-Comments, Build-CommentView, Format-Comments and Test-Comments share, so the converter, the...
    [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-CommentScope.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.PARAMETER Path
    Optional files or folders to limit the scope to.
.OUTPUTS
    [pscustomobject] { File, Extension, Language, Page } per file, in path order.
#>
function Get-CommentScope {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $config = Get-Config -Config comments
    $languages = [System.Collections.Generic.HashSet[string]]::new([string[]] @($config.languages), [System.StringComparer]::OrdinalIgnoreCase)
    foreach ($file in @(Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path | Sort-Object)) {
        if ($config.IsExcluded($file)) {
            continue
        }
        $language = Get-FileLanguage -Path $file
        if (-not $language -or -not $languages.Contains($language.name)) {
            continue
        }
        $page = $config.PageFor($file)
        if (-not $page) {
            continue
        }
        [pscustomobject]@{
            File      = $file
            Extension = [Catzc.Base.QualityGates.CommentLexer]::ExtensionOf($file)
            Language  = $language.name
            Page      = $page
        }
    }
}
