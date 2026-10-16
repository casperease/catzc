<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/tests/Get-TimeoutExemption.Tests.ps1
    folder: tests
    name: get-timeout-exemption-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-TimeoutExemption' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
        $script:widget = 'a1d6e700-0000-0000-0000-' + '000000000000'
        $script:gadget = 'ba000500-0000-0000-0000-' + '000000000000'
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts {
            [Catzc.Base.Timeouts.TimeoutExemptionsConfig]::new([ordered]@{
                    exempt = @(@{ single = $script:widget; scope = @{ environment = 'devbox'; shell = 'pwsh' }; reason = 'widget sync is being tuned' })
                })
        }
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Devbox' }
    }

    It 'returns the covering exemption' {
        (Get-TimeoutExemption $widget).reason | Should -Be 'widget sync is being tuned'
    }

    It 'returns nothing for a budget that is not exempt' {
        Get-TimeoutExemption $gadget | Should -BeNullOrEmpty
    }

    It 'returns nothing outside the exemption scope' {
        Get-TimeoutExemption $widget -Shell Bash | Should -BeNullOrEmpty
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Pipeline' }
        Get-TimeoutExemption $widget | Should -BeNullOrEmpty
    }

    It 'passes -EnvironmentAssertIs to Get-RunEnvironment' {
        $null = Get-TimeoutExemption $widget -EnvironmentAssertIs Devbox
        Should -Invoke Get-RunEnvironment -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $EnvironmentAssertIs -eq 'Devbox' }
    }

    It 'rejects a budget that is not a GUID' {
        { Get-TimeoutExemption 'widget' } | Should -Throw
    }
}
