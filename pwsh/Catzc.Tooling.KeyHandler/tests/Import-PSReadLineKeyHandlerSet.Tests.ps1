<#
---
catzc:
  immutable:
    with_body_sha: b03beb362092
  edges:
    docs: "[Import-PSReadLineKeyHandlerSet.Tests.ps1.md](docs/references/pwsh/catzc-tooling-keyhandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1.md)"
    code: pwsh/Catzc.Tooling.KeyHandler/Import-PSReadLineKeyHandlerSet.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Import-PsReadLineKeyHandlerSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $sequence = [System.Collections.Generic.List[object]]::new()
        $sequence.Add([ordered]@{ key = 'Ctrl+w'; function = 'Widget' })
        $sequence.Add([ordered]@{ key = 'Alt+g'; function = 'Gadget' })
        $sequence.Add([ordered]@{ key = 'Ctrl+g'; function = 'gadget' })
        $script:bindings = [Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig]::new($sequence)
        $script:supported = [Catzc.Tooling.KeyHandler.KeyHandlerSupportedConfig]::new([ordered]@{ functions = @('Widget') })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Tooling.KeyHandler -ParameterFilter { $Config -eq 'key-handler-bindings' } { $script:bindings }
        Mock Get-Config -ModuleName Catzc.Tooling.KeyHandler -ParameterFilter { $Config -eq 'key-handler-supported' } { $script:supported }
        Mock Set-PSReadLineKeyHandler -ModuleName Catzc.Tooling.KeyHandler { }
    }

    It 'plans every binding in file order, supported exactly when its function is in the allow-list' {
        $plan = @(Import-PsReadLineKeyHandlerSet -DryRun)
        @($plan | ForEach-Object { "$($_.Key)=$($_.Function):$($_.Supported)" }) |
            Should -Be @('Ctrl+w=Widget:True', 'Alt+g=Gadget:False', 'Ctrl+g=gadget:False')
    }

    It 'the DryRun plan applies nothing to the session' {
        Import-PsReadLineKeyHandlerSet -DryRun | Out-Null
        Should -Invoke Set-PSReadLineKeyHandler -ModuleName Catzc.Tooling.KeyHandler -Times 0
    }
}
