# Get-TestFileModule with Get-RepositoryRoot and Get-GoTestFolders mocked: a run file maps to its unit for
# per-module protection. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
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
        Mock Get-GoTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Module = 'Catzc.Widget'; Folder = (Get-RepoPath 'go/tests/catzc-widget'); Name = 'catzc-widget' }
        }
    }

    It 'names the module folder of a test file under automation/' {
        Get-Unit (Get-RepoPath 'automation/Catzc.Gadget/tests/Get-Gadget.Tests.ps1') | Should -Be 'Catzc.Gadget'
        Get-Unit (Get-RepoPath 'automation/.internal/tests/Get-Gadget.Tests.ps1') | Should -Be '.internal'
        Should -Invoke Get-GoTestFolders -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'names the catzc module of a Go test folder' {
        Get-Unit (Get-RepoPath 'go/tests/catzc-widget') | Should -Be 'Catzc.Widget'
    }

    It 'throws for a path that is neither under automation/ nor a Go test folder' {
        { Get-Unit (Get-RepoPath 'go/tests/catzc-gadget') } | Should -Throw '*neither under*'
    }
}
