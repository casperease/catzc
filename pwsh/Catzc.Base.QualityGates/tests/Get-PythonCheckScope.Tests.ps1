<#
---
catzc:
  immutable:
    with_body_sha: b429aa2c52b3
  edges:
    docs: "[Get-PythonCheckScope.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Get-PythonCheckScope.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-PythonCheckScope.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Get-PythonCheckScope' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
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
