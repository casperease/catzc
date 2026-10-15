<#
.SYNOPSIS
    Names the unit a run file belongs to — the first path segment under automation/, or the module of a language
    test folder.
.DESCRIPTION
    Maps an absolute run-file path to its owning unit for per-module protection: a module folder name...
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestFileModule.ps1.md#comment1)
.PARAMETER Path
    The absolute path of a file under <repo>/automation/, or of a language test folder.
#>
function Get-TestFileModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $automationRoot = [System.IO.Path]::Combine((Get-RepositoryRoot), 'automation')
    if (-not $Path.StartsWith($automationRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $folder = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        foreach ($testFolder in @(Get-LanguageTestFolders)) {
            if ($testFolder.Folder -eq $folder) {
                return $testFolder.Module
            }
        }
        throw "'$Path' is neither under $automationRoot nor a language test folder (Get-LanguageTestFolders)."
    }
    $relative = $Path.Substring($automationRoot.Length).TrimStart('\', '/')
    ($relative -split '[\\/]')[0]
}
