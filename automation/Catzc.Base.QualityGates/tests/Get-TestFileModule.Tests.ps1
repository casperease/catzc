<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-TestFileModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        function Get-RepoPath {
            param([string] $Relative)
            [System.IO.Path]::GetFullPath((Join-Path $script:repo $Relative))
        }
        function Get-Unit {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $Path } {
                param($Path)
                Get-TestFileModule $Path
            }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = (Get-RepoPath 'go/tests/catzc-widget'); Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Gadget'; Folder = (Get-RepoPath 'python/tests/catzc-gadget'); Name = 'catzc-gadget' }
        }
    }

    It 'names the module folder of a test file under automation/' {
        Get-Unit (Get-RepoPath 'automation/Catzc.Gadget/tests/Get-Gadget.Tests.ps1') | Should -Be 'Catzc.Gadget'
        Get-Unit (Get-RepoPath 'automation/.internal/tests/Get-Gadget.Tests.ps1') | Should -Be '.internal'
        Should -Invoke Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'names the catzc module of a <Language> test folder' -ForEach @(
        @{ Language = 'go'; Relative = 'go/tests/catzc-widget'; Module = 'Catzc.Widget' }
        @{ Language = 'python'; Relative = 'python/tests/catzc-gadget'; Module = 'Catzc.Gadget' }
    ) {
        Get-Unit (Get-RepoPath $Relative) | Should -Be $Module
    }

    It 'throws for a path that is neither under automation/ nor a language test folder' {
        { Get-Unit (Get-RepoPath 'go/tests/catzc-gadget') } | Should -Throw '*neither under*'
    }
}
