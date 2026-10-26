Describe 'Get-JavaScriptTestCases' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Relative, [string[]] $Line)
            $path = Join-Path $TestDrive "catzc-widget/$Relative"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, ($Line -join "`n") + "`n")
        }
        New-FixtureFile 'spin.test.js' @(
            'test("spins", () => {});'
            "test('integrity: ships', () => {});"
            'test.skip(`stalls`, () => {});'
            '    test("indented, not a top-level case", () => {});'
            'test(`templated ${name}`, () => {});'
        )
        New-FixtureFile 'nested/gear.test.js' @('test("spins", () => {});', 'test("turns", () => {});')
        New-FixtureFile 'helper.js' @('test("not a test file", () => {});')
        $script:cases = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = (Join-Path $TestDrive 'catzc-widget') } {
                param($Folder)
                Get-JavaScriptTestCases -Folder $Folder
            })
    }

    It 'finds every top-level test() of every .test.js file, skipped ones too, and nothing else' {
        $script:cases.ForEach({ $_.Key }) | Should -Be @('nested/gear.test.js spins', 'nested/gear.test.js turns',
            'spin.test.js spins', 'spin.test.js integrity: ships', 'spin.test.js stalls')
    }

    It 'files a case under integrity by its name''s prefix, logic otherwise' {
        ($script:cases | Where-Object Name -EQ 'integrity: ships').Category | Should -Be 'integrity'
        ($script:cases | Where-Object Name -EQ 'turns').Category | Should -Be 'logic'
    }

    It 'titles a case by its name, with its package only when two files declare the same name' {
        ($script:cases | Where-Object Name -EQ 'turns').Title | Should -Be 'turns'
        @($script:cases | Where-Object Name -EQ 'spins').ForEach({ $_.Title }) |
            Should -Be @('nested/gear.test.js: spins', 'spin.test.js: spins')
    }
}
