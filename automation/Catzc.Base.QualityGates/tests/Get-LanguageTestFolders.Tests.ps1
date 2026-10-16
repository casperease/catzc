<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-LanguageTestFolders' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Root, [string] $Relative, [string] $Text = 'package widget')
            $path = Join-Path $Root $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
        }
        $script:repo = Join-Path $TestDrive 'repo'
        foreach ($module in 'Catzc.Widget', 'Catzc.Gadget.Parts', '.internal') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:repo "automation/$module"))
        }
        New-FixtureFile $script:repo 'go/tests/catzc-widget/widget_test.go'
        New-FixtureFile $script:repo 'go/tests/catzc-gadget-parts/nested/parts_test.go'
        New-FixtureFile $script:repo 'python/tests/catzc-widget/test_widget.py' -Text 'def test_widget(): pass'
        New-FixtureFile $script:repo 'bash/tests/catzc-gadget-parts/parts.bats' -Text '@test "parts" { true; }'
        New-FixtureFile $script:repo 'go/tests/.cache/cache_test.go'
        New-FixtureFile $script:repo 'go/tests/catzc-gizmo/go.mod' -Text 'module catzc/go/tests/catzc-gizmo'
        New-FixtureFile $script:repo 'python/tests/.venv/test_cache.py' -Text ''
        New-FixtureFile $script:repo 'python/tests/catzc-gadget-parts/helpers.py' -Text ''
        New-FixtureFile $script:repo 'bash/tests/catzc-widget/helpers.bash' -Text ''
        New-FixtureFile $script:repo 'bash/.vendor/bats-core/test/fixture.bats' -Text ''
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'go' } {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{})
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bash' } {
            [Catzc.Base.Languages.BashConfig]::new([ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('a' * 64) })
        }
    }

    It 'maps every test folder to the catzc module named for it in kebab case, by language then folder' {
        $folders = @(InModuleScope Catzc.Base.QualityGates { Get-LanguageTestFolders })
        @($folders | ForEach-Object { "$($_.Language) $($_.Name)" }) | Should -Be @('go catzc-gadget-parts', 'go catzc-widget', 'python catzc-widget', 'bash catzc-gadget-parts')
        @($folders.Module) | Should -Be @('Catzc.Gadget.Parts', 'Catzc.Widget', 'Catzc.Widget', 'Catzc.Gadget.Parts')
        $folders[1].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'go/tests/catzc-widget')))
        $folders[2].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'python/tests/catzc-widget')))
    }

    It 'throws, naming the folder, when a test folder matches no catzc module: <Relative>' -ForEach @(
        @{ Relative = 'go/tests/catzc-gizmo/gizmo_test.go'; Folder = 'go/tests/catzc-gizmo/' }
        @{ Relative = 'python/tests/catzc-gizmo/test_gizmo.py'; Folder = 'python/tests/catzc-gizmo/' }
        @{ Relative = 'bash/tests/catzc-gizmo/gizmo.bats'; Folder = 'bash/tests/catzc-gizmo/' }
    ) {
        New-FixtureFile $script:repo $Relative
        try {
            { InModuleScope Catzc.Base.QualityGates { Get-LanguageTestFolders } } | Should -Throw "*$Folder*"
        }
        finally {
            [System.IO.File]::Delete((Join-Path $script:repo $Relative))
        }
    }

    It 'returns nothing when the repository has no test folder' {
        $empty = Join-Path $TestDrive 'empty'
        [void][System.IO.Directory]::CreateDirectory((Join-Path $empty 'automation/Catzc.Widget'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'empty' }
        @(InModuleScope Catzc.Base.QualityGates { Get-LanguageTestFolders }) | Should -HaveCount 0
    }
}
