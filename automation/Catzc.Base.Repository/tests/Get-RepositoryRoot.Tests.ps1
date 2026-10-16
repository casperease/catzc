<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1
    folder: tests
    name: get-repository-root-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

# Get-RepositoryRoot reads $env:RepositoryRoot (set by importer.ps1); pinned against a $TestDrive root and restored.
Describe 'Get-RepositoryRoot' -Tag 'L0', 'logic' {
    It 'returns the repository root the importer set in $env:RepositoryRoot' {
        $saved = $env:RepositoryRoot
        try {
            $env:RepositoryRoot = Join-Path $TestDrive 'widget'
            Get-RepositoryRoot | Should -Be (Join-Path $TestDrive 'widget')
        }
        finally {
            $env:RepositoryRoot = $saved
        }
    }
}
