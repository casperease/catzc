<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
---
#>

# Get-PythonCheckScope with the test folders and the git index mocked: the Python checks read the test folders and...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md#comment1)
Describe 'Get-PythonCheckScope' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = (Join-Path $script:repo 'go/tests/catzc-widget'); Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = (Join-Path $script:repo 'python/tests/catzc-widget'); Name = 'catzc-widget' }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'python/tests/catzc-widget/test_widget.py'
            '.claude/widget/sprocket.py'
            '.claude/widget/gadget.py'
            'docs/widget.md'
        }
    }

    It 'lists the Python test folders, then the tracked .py files outside the Python root in ordinal order' {
        $scope = @(InModuleScope Catzc.Base.QualityGates { Get-PythonCheckScope })
        $scope | Should -Be @(
            (Join-Path $script:repo 'python/tests/catzc-widget')
            [System.IO.Path]::GetFullPath((Join-Path $script:repo '.claude/widget/gadget.py'))
            [System.IO.Path]::GetFullPath((Join-Path $script:repo '.claude/widget/sprocket.py'))
        )
    }

    It 'lists nothing when the repository holds no Python' {
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'docs/widget.md' }
        @(InModuleScope Catzc.Base.QualityGates { Get-PythonCheckScope }) | Should -HaveCount 0
    }
}
