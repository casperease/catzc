# cspell:ignore Testlowercase  -- a Go function name that is not a test (lowercase after Test), on purpose
Describe 'Get-GoTestCases' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Relative, [string[]] $Line)
            $path = Join-Path $TestDrive "catzc-widget/$Relative"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, ($Line -join "`n") + "`n")
        }
        New-FixtureFile 'widget_test.go' @(
            'package widget'
            'func TestWidgetSpins(t *testing.T) {}'
            'func TestIntegrityWidgetShips(t *testing.T) {}'
            'func Testlowercase(t *testing.T) {}'
            'func TestMain(m *testing.M) {}'
            'func BenchmarkWidget(b *testing.B) {}'
            'func helperTest(t *testing.T) {}'
            '    func TestIndented(t *testing.T) {}'
        )
        New-FixtureFile 'gears/gear_test.go' @('package gears', 'func Test(t *testing.T) {}', 'func TestGear_Turns(tt *testing.T) {}')
        New-FixtureFile 'widget.go' @('package widget', 'func TestNotATestFile(t *testing.T) {}')
        New-FixtureFile 'testdata/data_test.go' @('func TestIgnoredData(t *testing.T) {}')
        New-FixtureFile '_scratch/scratch_test.go' @('func TestIgnoredScratch(t *testing.T) {}')
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'go' } {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{})
        }
    }

    It 'lists every top-level Go test of the *_test.go files, with its package, category, and title' {
        $cases = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = (Join-Path $TestDrive 'catzc-widget') } {
                param($Folder)
                Get-GoTestCases -Folder $Folder
            })
        @($cases.Title) | Should -Be @('gears/Test', 'gears/TestGear_Turns', 'TestWidgetSpins', 'TestIntegrityWidgetShips')
        @($cases.Category) | Should -Be @('logic', 'logic', 'logic', 'integrity')
        $cases[0].Package | Should -Be 'catzc/go/tests/catzc-widget/gears'
        $cases[2].Package | Should -Be 'catzc/go/tests/catzc-widget'
        $cases[3].Key | Should -Be 'catzc/go/tests/catzc-widget TestIntegrityWidgetShips'
    }

    It 'throws when the folder does not exist' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = (Join-Path $TestDrive 'catzc-gadget') } {
                param($Folder)
                Get-GoTestCases -Folder $Folder
            }
        } | Should -Throw
    }
}
