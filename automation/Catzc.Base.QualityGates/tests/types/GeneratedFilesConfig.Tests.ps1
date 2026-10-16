<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/types/GeneratedFilesConfig.Tests.ps1
    folder: tests/types
    name: generated-files-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Catzc.Base.QualityGates.GeneratedFilesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.QualityGates.GeneratedFilesConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the GeneratedFilesConfig constructor to throw'
        }
    }

    It 'declares every default once: a writer with no keys is a file check reading Path' {
        $config = [Catzc.Base.QualityGates.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null } })
        $config.writers['Build-Widget'].check | Should -Be 'file'
        $config.writers['Build-Widget'].result_path | Should -Be 'Path'
    }

    It 'keeps the writers in declaration order and honours a named result path and check' {
        $config = [Catzc.Base.QualityGates.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget' = [ordered]@{ result_path = 'Gadget' }
                    'Build-Gadget' = [ordered]@{ check = 'root-config' }
                }
            })
        @($config.writers.Keys) | Should -Be @('Build-Widget', 'Build-Gadget')
        $config.writers['Build-Widget'].result_path | Should -Be 'Gadget'
        $config.writers['Build-Gadget'].check | Should -Be 'root-config'
        $config.writers['Build-Gadget'].result_path | Should -BeNullOrEmpty
    }

    It 'rejects an unknown top-level key, an empty registry and a missing writers key' {
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null }; gadgets = 1 }) | Should -BeLike "*unknown top-level key 'gadgets' (allowed: writers)*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{} }) | Should -BeLike "*'writers' must be a non-empty map*"
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike "*'writers' must be a non-empty map*"
    }

    It 'rejects a name that is not a command name, an unknown key, an unknown check and a result path on a check that reads none' {
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ widget = $null } }) | Should -BeLike "*writer name 'widget' is invalid*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ gadget = 1 } } }) | Should -BeLike "*writer 'Build-Widget' carries unknown key 'gadget'*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ check = 'gadget' } } }) | Should -BeLike "*writer 'Build-Widget' has unknown check 'gadget'*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ check = 'root-config'; result_path = 'Path' } } }) | Should -BeLike "*writer 'Build-Widget' sets result_path*"
    }

    It 'loads the shipped generated-files.yml' {
        $config = Get-Config -Config generated-files
        $config.writers.Contains('Build-RootConfig') | Should -BeTrue
        $config.writers['Build-Readme'].result_path | Should -Be 'Readme'
    }
}
