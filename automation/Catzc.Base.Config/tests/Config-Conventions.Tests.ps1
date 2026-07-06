# Poka-yoke backstops for the config convention (see ADR module-config-loading):
#  - no orphan validators: every private Assert-<Name>Config maps to a real configs/<name>.yml
#  - wiring: each validated shipped config actually rejects a malformed file through Get-Config

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    # Title deliberately avoids Pester's <var> name-template syntax — under the importer's strict mode an
    # unmatched <name> token in an It title throws at name-expansion time instead of expanding to empty.
    It 'every Assert-*Config validator maps to a configs/*.yml in its module (no orphans)' {
        $automation = Join-Path $env:RepositoryRoot 'automation'
        foreach ($moduleDir in (Get-ChildItem $automation -Directory | Where-Object { $_.Name -notmatch '^\.' })) {
            $mod = Get-Module $moduleDir.Name
            if (-not $mod) {
                continue
            }

            # Private functions are scope-isolated, so this lists only THIS module's validators.
            $validators = @(& $mod { (Get-Item Function:\Assert-*Config -ErrorAction Ignore).Name })
            if (-not $validators) {
                continue
            }

            $expected = @()
            $configsDir = Join-Path $moduleDir.FullName 'configs'
            if (Test-Path $configsDir) {
                foreach ($file in (Get-ChildItem $configsDir -Filter '*.yml')) {
                    $title = -join ($file.BaseName -split '-' | ForEach-Object {
                            [cultureinfo]::InvariantCulture.TextInfo.ToTitleCase($_)
                        })
                    $expected += "Assert-${title}Config"
                }
            }

            # One Should over the violating set — a Should per validator pays Pester's per-assertion
            # cost times every discovered module's validators.
            $violations = foreach ($validator in $validators) {
                if ($validator -notin $expected) {
                    "validator '$validator' in $($moduleDir.Name) has no matching configs/*.yml — rename it to Assert-<TitleCase(name)>Config or add the config"
                }
            }
            @($violations) | Should -BeNullOrEmpty
        }
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
