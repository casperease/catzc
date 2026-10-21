<#
---
catzc:
  immutable:
    with_body_sha: e092871a0102
  edges:
    code: pwsh/Catzc.Base.Maps/Get-MinimapFact.ps1
---
#>

Describe 'Get-MinimapFact' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-FileMetaFact -ModuleName Catzc.Base.Maps {
            foreach ($file in $Path) {
                if ($file -ne 'gadgets/ignored.txt') {
                    [pscustomobject]@{ Path = $file; Immutable = @{ track = $file.Split('/')[0] }; Edges = @{} }
                }
            }
        }
    }

    It 'reads every path once, in one call, and maps each to its immutable facts' {
        $facts = Get-MinimapFact -Path 'widgets/Get-Widget.ps1', 'gadgets/Get-Gadget.ps1', 'widgets/Get-Widget.ps1'
        Should -Invoke Get-FileMetaFact -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { $Path.Count -eq 2 }
        @($facts.Keys | Sort-Object) | Should -Be @('gadgets/Get-Gadget.ps1', 'widgets/Get-Widget.ps1')
        $facts['widgets/Get-Widget.ps1']['track'] | Should -Be 'widgets'
    }

    It 'leaves out a path the read skips, so it has no facts' {
        $facts = Get-MinimapFact -Path 'gadgets/ignored.txt', 'gadgets/Get-Gadget.ps1'
        $facts.ContainsKey('gadgets/ignored.txt') | Should -BeFalse
        $facts['gadgets/Get-Gadget.ps1']['track'] | Should -Be 'gadgets'
    }

    It 'reads nothing for no paths' {
        $facts = Get-MinimapFact -Path @()
        $facts.Count | Should -Be 0
        Should -Invoke Get-FileMetaFact -ModuleName Catzc.Base.Maps -Times 0 -Exactly
    }
}
