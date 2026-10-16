<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/tests/types/TimeLimitAttribute.Tests.ps1
    folder: tests/types
    name: time-limit-attribute-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-PWSH-ASSERT#1
---
#>

Describe 'TimeLimitAttribute' -Tag 'L0', 'logic', 'ADR-PWSH-ASSERT#1' {
    It 'carries a devbox limit and defaults the pipeline limit to it' {
        $limit = [Catzc.Base.Timeouts.TimeLimitAttribute]::new(360)
        $limit.SecondsFor('Devbox') | Should -Be 360
        $limit.SecondsFor('pipeline') | Should -Be 360
        $limit.Budget | Should -BeExactly ''
    }

    It 'carries a separate pipeline limit and a budget GUID' {
        $limit = [Catzc.Base.Timeouts.TimeLimitAttribute]::new(360)
        $limit.Pipeline = 3600
        # Built at runtime (not a literal), so the fixture needs no managed-GUID registry entry.
        $budget = 'a1d6e700-0000-0000-0000-' + '000000000001'
        $limit.Budget = $budget
        $limit.SecondsFor('Pipeline') | Should -Be 3600
        $limit.Budget | Should -Be $budget
    }

    It 'is read from a function''s param block' {
        function Get-Widget {
            [CmdletBinding()]
            [Catzc.Base.Timeouts.TimeLimit(120, Pipeline = 900)]
            param()
        }
        $limit = (Get-Command Get-Widget).ScriptBlock.Attributes | Where-Object { $_ -is [Catzc.Base.Timeouts.TimeLimitAttribute] }
        $limit.Devbox | Should -Be 120
        $limit.Pipeline | Should -Be 900
    }

    It 'rejects a limit that is not a positive whole number' {
        { [Catzc.Base.Timeouts.TimeLimitAttribute]::new(0) } | Should -Throw '*must be a positive whole number*'
    }

    It 'rejects a pipeline limit below the devbox limit' {
        $limit = [Catzc.Base.Timeouts.TimeLimitAttribute]::new(360)
        { $limit.Pipeline = 60 } | Should -Throw '*must be at least the devbox limit 360*'
    }

    It 'rejects a budget that is not a GUID, and an unknown environment' {
        $limit = [Catzc.Base.Timeouts.TimeLimitAttribute]::new(360)
        { $limit.Budget = 'widget' } | Should -Throw '*must be a GUID*'
        { $limit.SecondsFor('gadget') } | Should -Throw '*unknown environment*'
    }
}
