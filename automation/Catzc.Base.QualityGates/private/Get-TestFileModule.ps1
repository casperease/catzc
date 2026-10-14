<#
.SYNOPSIS
    Names the unit a run file belongs to — the first path segment under automation/, or the module of a Go test
    folder.
.DESCRIPTION
    Maps an absolute run-file path to its owning unit for per-module protection
    ([ADR-REPO-PROTGLOB](/docs/adr/automation/protected-globs.md)): a module
    folder name ('Catzc.Base.Globs') or a dot-prefixed infra test unit ('.internal', '.scriptanalyzer'). A Go test
    folder (<goRoot>/tests/<module in kebab case>, Get-GoTestFolders) belongs to the catzc module it is named for,
    so its Go tests protect and invalidate that module.
.PARAMETER Path
    The absolute path of a file under <repo>/automation/, or of a Go test folder.
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
        foreach ($goFolder in @(Get-GoTestFolders)) {
            if ($goFolder.Folder -eq $folder) {
                return $goFolder.Module
            }
        }
        throw "'$Path' is neither under $automationRoot nor a Go test folder (Get-GoTestFolders)."
    }
    $relative = $Path.Substring($automationRoot.Length).TrimStart('\', '/')
    ($relative -split '[\\/]')[0]
}
