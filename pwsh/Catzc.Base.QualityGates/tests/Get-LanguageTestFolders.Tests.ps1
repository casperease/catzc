<#
---
catzc:
  immutable:
    with_body_sha: f4ec1795e427
  edges:
    docs: "[Get-LanguageTestFolders.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Get-LanguageTestFolders.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
    cites:
      - ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
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
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:repo "widget-modules/$module"))
        }
        New-FixtureFile $script:repo 'go/tests/catzcwidget/widget_test.go'
        New-FixtureFile $script:repo 'go/tests/catzcgadgetparts/nested/parts_test.go'
        New-FixtureFile $script:repo 'python/tests/catzc_widget/test_widget.py' -Text 'def test_widget(): pass'
        New-FixtureFile $script:repo 'bash/tests/catzc-gadget-parts/parts.bats' -Text '@test "parts" { true; }'
        New-FixtureFile $script:repo 'go/tests/.cache/cache_test.go'
        New-FixtureFile $script:repo 'go/tests/catzcgizmo/go.mod' -Text 'module catzc/go/tests/catzcgizmo'
        New-FixtureFile $script:repo 'python/tests/.venv/test_cache.py' -Text ''
        New-FixtureFile $script:repo 'python/tests/catzc_gadget_parts/helpers.py' -Text ''
        New-FixtureFile $script:repo 'bash/tests/catzc-widget/helpers.bash' -Text ''
        New-FixtureFile $script:repo 'bash/.vendor/bats-core/test/fixture.bats' -Text ''
        # A module of the python track with its own tests/ folder, and one without test files in it.
        New-FixtureFile $script:repo 'python/Widget.Kit/kit.py' -Text ''
        New-FixtureFile $script:repo 'python/Widget.Kit/tests/test_kit.py' -Text 'def test_kit(): pass'
        New-FixtureFile $script:repo 'python/Widget.Plain/plain.py' -Text ''
        New-FixtureFile $script:repo 'python/Widget.Plain/tests/helpers.py' -Text ''
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-CatzcModule -ModuleName Catzc.Base.QualityGates -ParameterFilter { $EngineTrack } {
            foreach ($name in 'Catzc.Widget', 'Catzc.Gadget.Parts', '.internal') {
                [Catzc.Base.Modules.Module]::new($name, 'widgets', 'widget-folder', 'widgetry', "widgetry/$name", 'folder', $null, $null, $null, $null)
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'go' } {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{})
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bash' } {
            [Catzc.Base.Languages.BashConfig]::new([ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('a' * 64) })
        }
    }

    It 'maps every holder test folder to the catzc module named for it in its language''s folder case, and a module''s own tests folder to that module, by registry language then folder' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' {
        $folders = @(InModuleScope Catzc.Base.QualityGates { Get-LanguageTestFolders })
        @($folders.ForEach({ "$($_.Language) $($_.Name)" })) | Should -Be @('python catzc_widget', 'python Widget.Kit', 'go catzcgadgetparts', 'go catzcwidget', 'bash catzc-gadget-parts')
        @($folders.Module) | Should -Be @('Catzc.Widget', 'Widget.Kit', 'Catzc.Gadget.Parts', 'Catzc.Widget', 'Catzc.Gadget.Parts')
        $folders[0].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'python/tests/catzc_widget')))
        $folders[1].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'python/Widget.Kit/tests')))
        $folders[3].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'go/tests/catzcwidget')))
    }

    It 'throws, naming the folder and its language''s case, when a test folder matches no catzc module: <Relative>' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' -ForEach @(
        @{ Relative = 'go/tests/catzcgizmo/gizmo_test.go'; Folder = 'go/tests/catzcgizmo/ (flat case)' }
        @{ Relative = 'python/tests/catzc_gizmo/test_gizmo.py'; Folder = 'python/tests/catzc_gizmo/ (snake case)' }
        @{ Relative = 'bash/tests/catzc-gizmo/gizmo.bats'; Folder = 'bash/tests/catzc-gizmo/ (kebab case)' }
        @{ Relative = 'python/tests/catzc-widget/test_widget.py'; Folder = 'python/tests/catzc-widget/ (snake case)' }
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
        [void][System.IO.Directory]::CreateDirectory((Join-Path $empty 'widget-modules/Catzc.Widget'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'empty' }
        @(InModuleScope Catzc.Base.QualityGates { Get-LanguageTestFolders }) | Should -HaveCount 0
    }
}
