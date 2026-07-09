<#
.SYNOPSIS
    Names the unit a test file belongs to — the first path segment under automation/.
.DESCRIPTION
    Maps an absolute test-file path to its owning unit for per-module protection (ADR-REPO-PROTGLOB): a module
    folder name ('Catzc.Base.Globs') or a dot-prefixed infra test unit ('.internal', '.scriptanalyzer').
.PARAMETER Path
    The absolute path of a file under <repo>/automation/.
#>
function Get-TestFileModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $automationRoot = [System.IO.Path]::Combine($env:RepositoryRoot, 'automation')
    $relative = $Path.Substring($automationRoot.Length).TrimStart('\', '/')
    ($relative -split '[\\/]')[0]
}
