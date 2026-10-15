<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
    kind: pester-test
---
#>

# Get-BashTestCases over fixture .bats files in $TestDrive: the @test declarations of every .bats file, with the file
# path bats reports as their package. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-BashTestCases' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Relative, [string] $Text)
            $path = Join-Path $script:folder $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
        }
        $script:folder = Join-Path $TestDrive 'bash/tests/catzc-widget'
        New-FixtureFile 'widget.bats' @'
setup() {
    true
}

@test "widget spins" {
    true
}

  @test 'widget waits' {
    true
}

@test "integrity: widget ships" { true; }

# @test "commented out" {
'@
        New-FixtureFile 'gadget/gadget.bats' "@test `"widget spins`" {`n  true`n}`n"
        New-FixtureFile '.cache/ignored.bats' "@test `"ignored`" {`n  true`n}`n"
        New-FixtureFile 'helpers.bash' "@test `"not a bats file`" {`n  true`n}`n"
    }

    It 'lists the @test declarations of every .bats file, with the file path bats reports' {
        $cases = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = $script:folder } { param($Folder) Get-BashTestCases -Folder $Folder })
        @($cases.Key) | Should -Be @(
            'gadget/gadget.bats widget spins'
            'widget.bats widget spins'
            'widget.bats widget waits'
            'widget.bats integrity: widget ships'
        )
    }

    It 'takes the category from the name: "integrity:" is integrity' {
        $cases = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = $script:folder } { param($Folder) Get-BashTestCases -Folder $Folder })
        ($cases | Where-Object Name -EQ 'integrity: widget ships').Category | Should -Be 'integrity'
        ($cases | Where-Object Name -EQ 'widget waits').Category | Should -Be 'logic'
    }

    It 'titles a test by its name, and by file and name when two files declare it' {
        $cases = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = $script:folder } { param($Folder) Get-BashTestCases -Folder $Folder })
        @($cases.Title) | Should -Be @(
            'gadget/gadget.bats: widget spins'
            'widget.bats: widget spins'
            'widget waits'
            'integrity: widget ships'
        )
    }
}
