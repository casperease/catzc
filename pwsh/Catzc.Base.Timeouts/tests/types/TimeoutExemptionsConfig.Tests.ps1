Describe 'TimeoutExemptionsConfig' -Tag 'L0' {

    Context 'integrity (shipped timeout-exemptions.yml)' -Tag 'integrity' {
        It 'passes for the shipped timeout-exemptions.yml' {
            Get-Config -Config timeout-exemptions | Should -BeOfType [Catzc.Base.Timeouts.TimeoutExemptionsConfig]
        }

        It 'names only registered budget GUIDs (each single, and both ends of each range)' {
            foreach ($entry in (Get-Config -Config timeout-exemptions).exempt) {
                Test-ManagedGuid $entry.from | Should -BeTrue -Because "exemption from '$($entry.from)' must be a registered budget"
                Test-ManagedGuid $entry.to | Should -BeTrue -Because "exemption to '$($entry.to)' must be a registered budget"
            }
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
            function script:New-FixtureGuid {
                param([string] $FirstGroup)
                "$FirstGroup-0000-0000-0000-" + '000000000000'
            }
            function script:New-ExemptionsConfig {
                param([System.Collections.IDictionary] $Data)
                [Catzc.Base.Timeouts.TimeoutExemptionsConfig]::new($Data)
            }
            $script:widget = New-FixtureGuid 'a1d6e700'
            $script:gadgetFrom = New-FixtureGuid 'ba000000'
            $script:gadgetInside = New-FixtureGuid 'ba000500'
            $script:gadgetTo = New-FixtureGuid 'ba00ffff'
        }

        It 'resolves the sensible ceiling defaults for every environment and shell from an empty config' {
            $config = New-ExemptionsConfig ([ordered]@{})
            $config.CeilingFor('Devbox', 'Bash') | Should -Be 600
            $config.CeilingFor('Devbox', 'Pwsh') | Should -Be 600
            $config.CeilingFor('Pipeline', 'Bash') | Should -Be 3600
            $config.CeilingFor('Pipeline', 'Pwsh') | Should -Be 3600
            $config.exempt.Count | Should -Be 0
        }

        It 'overrides one ceiling and keeps the other defaults' {
            $config = New-ExemptionsConfig ([ordered]@{ ceiling = @{ devbox = @{ pwsh = 120 } } })
            $config.CeilingFor('Devbox', 'Pwsh') | Should -Be 120
            $config.CeilingFor('Devbox', 'Bash') | Should -Be 600
            $config.ceiling.pipeline.pwsh | Should -Be 3600
        }

        It 'gives zsh its own ceiling, defaulting like the others' {
            $config = New-ExemptionsConfig ([ordered]@{ ceiling = @{ pipeline = @{ zsh = 1200 } } })
            $config.CeilingFor('Devbox', 'Zsh') | Should -Be 600
            $config.CeilingFor('Pipeline', 'zsh') | Should -Be 1200
            $config.ceiling.pipeline.pwsh | Should -Be 3600
        }

        It 'finds a single exemption in every cell when it has no scope' {
            $config = New-ExemptionsConfig ([ordered]@{ exempt = @(@{ single = $widget; reason = 'widget sync is being tuned' }) })
            foreach ($environment in 'Devbox', 'Pipeline') {
                foreach ($shell in [Catzc.Base.Engines.ExecutionEngines]::Names) {
                    $config.Find($widget, $environment, $shell).reason | Should -Be 'widget sync is being tuned'
                }
            }
            $config.Find($gadgetInside, 'Devbox', 'Pwsh') | Should -BeNullOrEmpty
        }

        It 'finds a range exemption for a GUID inside it and at both ends, in any case or braces' {
            $config = New-ExemptionsConfig ([ordered]@{ exempt = @(@{ range = @{ from = $gadgetFrom; to = $gadgetTo }; reason = 'gadget family' }) })
            $config.Find($gadgetFrom, 'Devbox', 'Pwsh').kind | Should -Be 'range'
            $config.Find($gadgetTo, 'Devbox', 'Pwsh') | Should -Not -BeNullOrEmpty
            $config.Find('{' + $gadgetInside.ToUpperInvariant() + '}', 'Devbox', 'Pwsh') | Should -Not -BeNullOrEmpty
            $config.Find((New-FixtureGuid 'ba010000'), 'Devbox', 'Pwsh') | Should -BeNullOrEmpty
        }

        It 'limits an exemption to its scope' {
            $config = New-ExemptionsConfig ([ordered]@{
                    exempt = @(@{ single = $widget; scope = @{ environment = 'Devbox'; shell = 'pwsh' }; reason = 'cold type compile' })
                })
            $config.Find($widget, 'Devbox', 'Pwsh') | Should -Not -BeNullOrEmpty
            $config.Find($widget, 'Devbox', 'Bash') | Should -BeNullOrEmpty
            $config.Find($widget, 'Pipeline', 'Pwsh') | Should -BeNullOrEmpty
        }

        It 'allows the same budget in disjoint scopes' {
            $config = New-ExemptionsConfig ([ordered]@{
                    exempt = @(
                        @{ single = $widget; scope = @{ environment = 'devbox' }; reason = 'devbox tuning' }
                        @{ single = $widget; scope = @{ environment = 'pipeline' }; reason = 'pipeline tuning' }
                    )
                })
            $config.Find($widget, 'Pipeline', 'Bash').reason | Should -Be 'pipeline tuning'
        }

        It 'throws on a budget that is not a GUID when finding' {
            { (New-ExemptionsConfig ([ordered]@{})).Find('widget', 'Devbox', 'Pwsh') } | Should -Throw "*budget 'widget' is not a GUID*"
        }

        It 'throws on <case>' -ForEach @(
            @{ case = 'an unknown top-level key'; entry = $null; data = @{ nope = 1 }; expected = "*unknown key 'nope'*" }
            @{ case = 'exempt that is not a list'; entry = $null; data = @{ exempt = 'widget' }; expected = '*invalid exempt (must be a list*' }
            @{ case = 'a non-positive ceiling'; entry = $null; data = @{ ceiling = @{ devbox = @{ pwsh = 0 } } }; expected = "*invalid ceiling.devbox.pwsh '0'*" }
            @{ case = 'a quoted ceiling'; entry = $null; data = @{ ceiling = @{ devbox = @{ bash = '600' } } }; expected = "*invalid ceiling.devbox.bash '600'*" }
            @{ case = 'an unknown ceiling shell'; entry = $null; data = @{ ceiling = @{ devbox = @{ widget = 1 } } }; expected = "*unknown key 'ceiling.devbox.widget'*" }
        ) {
            { New-ExemptionsConfig $data } | Should -Throw $expected
        }

        It 'throws on an entry with <case>' -ForEach @(
            @{ case = 'neither single nor range'; entry = @{ reason = 'r' }; expected = '*needs exactly one of single | range*' }
            @{ case = 'both single and range'; entry = @{ single = 'S'; range = @{ from = 'S'; to = 'S' }; reason = 'r' }; expected = '*needs exactly one of single | range*' }
            @{ case = 'a non-canonical GUID'; entry = @{ single = 'UPPER'; reason = 'r' }; expected = '*must be a canonical GUID*' }
            @{ case = 'the all-zeros GUID'; entry = @{ single = 'ZERO'; reason = 'r' }; expected = '*the all-zeros GUID is never a budget*' }
            @{ case = 'a reversed range'; entry = @{ range = @{ from = 'TO'; to = 'FROM' }; reason = 'r' }; expected = '*is after to*' }
            @{ case = 'an empty reason'; entry = @{ single = 'S'; reason = ' ' }; expected = '*needs a non-empty reason*' }
            @{ case = 'an unknown scope value'; entry = @{ single = 'S'; scope = @{ environment = 'laptop' }; reason = 'r' }; expected = "*scope.environment 'laptop'*" }
            @{ case = 'an unknown entry key'; entry = @{ single = 'S'; reason = 'r'; until = 'friday' }; expected = "*unknown key 'exempt[[]0].until'*" }
        ) {
            # Placeholders stand in for the fixture GUIDs, which BeforeAll builds after -ForEach data is bound.
            $map = @{ S = $widget; UPPER = $widget.ToUpperInvariant(); ZERO = [guid]::Empty.ToString(); FROM = $gadgetFrom; TO = $gadgetTo }
            $resolve = {
                param($value)
                if ($value -is [string] -and $map.ContainsKey($value)) {
                    $map[$value]
                }
                else {
                    $value
                }
            }
            $concrete = @{}
            foreach ($key in $entry.Keys) {
                $value = $entry[$key]
                if ($key -eq 'range') {
                    $value = @{ from = & $resolve $value.from; to = & $resolve $value.to }
                }
                $concrete[$key] = & $resolve $value
            }
            { New-ExemptionsConfig ([ordered]@{ exempt = @($concrete) }) } | Should -Throw $expected
        }

        It 'throws on two entries covering the same GUID in the same scope' {
            { New-ExemptionsConfig ([ordered]@{
                        exempt = @(
                            @{ range = @{ from = $gadgetFrom; to = $gadgetTo }; reason = 'gadget family' }
                            @{ single = $gadgetInside; scope = @{ shell = 'pwsh' }; reason = 'one gadget' }
                        )
                    }) } | Should -Throw '*overlapping exemptions: exempt[[]0]*exempt[[]1]*'
        }

        It 'orders ranges the same way Test-IsGuidInRange does' {
            $config = New-ExemptionsConfig ([ordered]@{ exempt = @(@{ range = @{ from = $gadgetFrom; to = $gadgetTo }; reason = 'gadget family' }) })
            foreach ($candidate in (New-FixtureGuid 'b9ffffff'), $gadgetInside, (New-FixtureGuid 'ba010000')) {
                ($null -ne $config.Find($candidate, 'Devbox', 'Pwsh')) | Should -Be (Test-IsGuidInRange $candidate -From $gadgetFrom -To $gadgetTo)
            }
        }

        It 'reports every violation in one throw' {
            $err = { New-ExemptionsConfig ([ordered]@{ nope = 1; exempt = @(@{ reason = '' }) }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike '*needs exactly one of single | range*'
            $err.Exception.Message | Should -BeLike '*needs a non-empty reason*'
        }
    }
}
