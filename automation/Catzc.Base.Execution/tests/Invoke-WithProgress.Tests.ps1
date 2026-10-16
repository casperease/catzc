<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/Invoke-WithProgress.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    relatives:
      source: automation/Catzc.Base.Execution/Invoke-WithProgress.ps1
---
#>

Describe 'Invoke-WithProgress' -Tag 'L0', 'logic' {
    It 'returns the scriptblock''s value untouched by the dots' {
        $result = Invoke-WithProgress { Start-Sleep -Milliseconds 150; 'widget' } -Message 'Working' -IntervalMs 20
        $result | Should -Be 'widget'
    }

    It 'rethrows a failing scriptblock and leaves no dot job behind' {
        $before = @(Get-Job).Count
        { Invoke-WithProgress { throw 'gadget failed' } -IntervalMs 20 } | Should -Throw '*gadget failed*'
        @(Get-Job).Count | Should -Be $before
    }

    It 'writes the prefix and the closing line through the writer chokepoint' {
        Mock Write-Message { } -ModuleName Catzc.Base.Execution
        Invoke-WithProgress { 'widget' } -Message 'Working' -IntervalMs 20 | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -eq 'Working' -and $NoHeader -and $NoNewline
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -eq '' -and $NoHeader
        }
    }
}
