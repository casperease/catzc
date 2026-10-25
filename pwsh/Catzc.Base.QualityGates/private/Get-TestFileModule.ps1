<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestFileModule.ps1.md"
  warning: "Generated Header"
---
#>

function Get-TestFileModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $modulesRoot = [System.IO.Path]::Combine((Get-RepositoryRoot), (Get-CatzcModulesFolder))
    if (-not $Path.StartsWith($modulesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $folder = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        foreach ($testFolder in @(Get-LanguageTestFolders)) {
            if ($testFolder.Folder -eq $folder) {
                return $testFolder.Module
            }
        }
        throw "'$Path' is neither under $modulesRoot nor a language test folder (Get-LanguageTestFolders)."
    }
    $relative = $Path.Substring($modulesRoot.Length).TrimStart('\', '/')
    ($relative -split '[\\/]')[0]
}
