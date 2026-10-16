<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/tests/Test-IsTimeoutExempt.Tests.ps1
    folder: tests
    name: test-is-timeout-exempt-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-IsTimeoutExempt' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
        $script:widget = 'a1d6e700-0000-0000-0000-' + '000000000000'
    }

    It 'is true when Get-TimeoutExemption finds an exemption' {
        Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { @{ reason = 'tuning' } }
        Test-IsTimeoutExempt $widget | Should -BeTrue
    }

    It 'is false when it finds none' {
        Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { }
        Test-IsTimeoutExempt $widget | Should -BeFalse
    }

    It 'asks for the given shell' {
        Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { }
        $null = Test-IsTimeoutExempt $widget -Shell Bash
        Should -Invoke Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Shell -eq 'Bash' }
    }
}
