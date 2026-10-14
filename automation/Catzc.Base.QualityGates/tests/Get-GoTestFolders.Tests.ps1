# Get-GoTestFolders over a fixture repository in $TestDrive (Get-RepositoryRoot and the go config mocked): catzc
# modules under automation/, and Go test folders under the go/ root. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GoTestFolders' -Tag 'L0', 'logic' {
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
        # Not Go test folders: a dot-prefixed folder, and a folder left with only generated files.
        New-FixtureFile $script:repo 'go/tests/.cache/cache_test.go'
        New-FixtureFile $script:repo 'go/tests/catzc-gizmo/go.mod' -Text 'module catzc/go/tests/catzc-gizmo'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'go' } {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{})
        }
    }

    It 'maps every Go test folder to the catzc module named for it in kebab case, ordinal by folder' {
        $folders = @(InModuleScope Catzc.Base.QualityGates { Get-GoTestFolders })
        @($folders.Name) | Should -Be @('catzc-gadget-parts', 'catzc-widget')
        @($folders.Module) | Should -Be @('Catzc.Gadget.Parts', 'Catzc.Widget')
        $folders[1].Folder | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $script:repo 'go/tests/catzc-widget')))
    }

    It 'throws, naming the folder, when a Go test folder matches no catzc module' {
        New-FixtureFile $script:repo 'go/tests/catzc-gizmo/gizmo_test.go'
        try {
            { InModuleScope Catzc.Base.QualityGates { Get-GoTestFolders } } | Should -Throw '*go/tests/catzc-gizmo/*'
        }
        finally {
            [System.IO.File]::Delete((Join-Path $script:repo 'go/tests/catzc-gizmo/gizmo_test.go'))
        }
    }

    It 'returns nothing when the repository has no Go test folder' {
        $empty = Join-Path $TestDrive 'empty'
        [void][System.IO.Directory]::CreateDirectory((Join-Path $empty 'automation/Catzc.Widget'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'empty' }
        @(InModuleScope Catzc.Base.QualityGates { Get-GoTestFolders }) | Should -HaveCount 0
    }
}
