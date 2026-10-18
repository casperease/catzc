<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1
    folder: private
    name: get-test-file-module
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
    test: automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
    cites:
      - ADR-REPO-PROTGLOB
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
