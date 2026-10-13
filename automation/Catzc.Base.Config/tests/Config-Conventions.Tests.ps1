# Poka-yoke backstops for the config convention (see ADR module-config-loading):
#  - no orphan validators: every private Assert-<Name>Config maps to a real configs/<name>.yml (Test-ConfigValidators)
#  - wiring: each validated shipped config actually rejects a malformed file through Get-Config

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    # Title deliberately avoids Pester's <var> name-template syntax — under the importer's strict mode an
    # unmatched <name> token in an It title throws at name-expansion time instead of expanding to empty.
    It 'every Assert-*Config validator maps to a configs/*.yml in its module (no orphans)' {
        # The quality gate (Test-ConfigValidators, in Catzc.Base.QualityGates: Catzc.Base.Reports depends on
        # Catzc.Base.Config, so the gate cannot live here) lists every orphan over the loaded code root
        # ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
        $result = Test-ConfigValidators -PassThru -OutputFolder (Join-Path $TestDrive 'config-validators')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'every validated shipped config rejects a malformed file through Get-Config' {
        $cases = @(
            @{ Name = 'ado'; Module = 'Catzc.Azure.DevOps' }
            @{ Name = 'azure'; Module = 'Catzc.Azure' }
            @{ Name = 'network'; Module = 'Catzc.Azure' }
            @{ Name = 'dependencies'; Module = 'Catzc.Base.ModuleSystem' }
        )
        foreach ($case in $cases) {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir "$($case.Name).yml") -Value 'placeholder: true'   # missing required keys

            $entry = @{ Name = $case.Name; Module = $case.Module; Path = (Join-Path $dir "$($case.Name).yml") }
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq $entry.Name } -MockWith { $entry }

            { Get-Config -Config $case.Name } | Should -Throw -Because "$($case.Name)'s validator must reject a malformed file (proves it is wired)"
        }
    }
}
