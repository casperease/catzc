<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/tests/Assert-IsNotTimeoutExempt.Tests.ps1
    folder: tests
    name: assert-is-not-timeout-exempt-tests
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

Describe 'Assert-IsNotTimeoutExempt' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
        $script:widget = 'a1d6e700-0000-0000-0000-' + '000000000000'
    }

    It 'passes for a budget under its normal limit' {
        Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { }
        { Assert-IsNotTimeoutExempt $widget } | Should -Not -Throw
    }

    It 'throws naming the reason for an exempt budget' {
        Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { @{ reason = 'widget sync is being tuned' } }
        { Assert-IsNotTimeoutExempt $widget } | Should -Throw '*is exempt from its time limit here (widget sync is being tuned)*'
    }
}
