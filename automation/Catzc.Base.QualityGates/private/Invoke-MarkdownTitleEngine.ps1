<#
.SYNOPSIS
    Checks every in-scope Markdown file's title — the one place Format-MarkdownTitle and Test-MarkdownTitle share.
.DESCRIPTION
    Resolves the scope (Get-MarkdownTitleScope), reads each file, and returns one finding per file
    (Get-MarkdownTitleFinding), so the formatter and the gate can never disagree on what a title should be.
.PARAMETER RepositoryRoot
    The repository root titles are relative to.
.PARAMETER Path
    Optional files or folders to limit the scope to.
.OUTPUTS
    [pscustomobject] @{ FileCount; Findings } — Findings holds every file's finding, Ok ones included.
#>
function Invoke-MarkdownTitleEngine {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $files = Get-MarkdownTitleScope -RepositoryRoot $RepositoryRoot -Path $Path
    $findings = foreach ($file in $files) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $file))
        Get-MarkdownTitleFinding -RelativePath $file -Text $text
    }

    [pscustomobject]@{
        FileCount = $files.Count
        Findings  = @($findings)
    }
}
