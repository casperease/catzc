Describe 'Test-ExpectedPackageManager — script-installed tools' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        $script:managedDir = Join-Path $TestDrive 'widget-managed'
        Mock Get-ScriptInstallDir { $script:managedDir } -ModuleName Catzc.Tooling.Core
        # The shape tools.yml gives a script-installed tool: the earlier manager kinds present and off.
        $script:config = [pscustomobject]@{ command = 'widget'; system_provided = $false; script_install = $true }
    }

    It 'judges -Path, not the command on PATH: <Description>' -ForEach @(
        @{ Description = 'the managed folder'; Relative = 'widget-managed'; Expected = $true }
        @{ Description = 'a folder under it'; Relative = 'widget-managed/sdk'; Expected = $true }
        @{ Description = 'a stray folder'; Relative = 'widget-stray'; Expected = $false }
        @{ Description = 'a sibling sharing the prefix'; Relative = 'widget-managed-old'; Expected = $false }
    ) {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = (Join-Path $script:managedDir 'widget.exe') } } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive $Relative) | Should -Be $Expected
    }

    It 'without -Path, judges the command on PATH as before' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = (Join-Path $script:managedDir 'widget.exe') } } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeTrue
    }

    It 'without -Path, is not managed when the command is absent' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeFalse
    }
}
