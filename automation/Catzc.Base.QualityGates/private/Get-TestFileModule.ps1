<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1
    folder: private
    name: get-test-file-module
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
    cites:
      - ADR-REPO-PROTGLOB
  config:
    synopsis: |-
      Names the unit a run file belongs to — the first path segment under automation/, or the module of a language
      test folder.
    description: |-
      Maps an absolute run-file path to its owning unit for per-module protection
      ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a module
      folder name ('Catzc.Base.Globs') or a dot-prefixed infra test unit ('.internal', '.scriptanalyzer'). A Go or
      Python test folder (<root>/tests/<module in kebab case>, Get-LanguageTestFolders) belongs to the catzc module it
      is named for, so its tests protect and invalidate that module.
    parameters:
      Path: The absolute path of a file under <repo>/automation/, or of a language test folder.
---
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
