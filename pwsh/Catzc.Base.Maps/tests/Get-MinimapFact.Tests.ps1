<#
---
catzc:
  immutable:
    with_body_sha: "0205243c2c87"
  edges:
    code: pwsh/Catzc.Base.Maps/Get-MinimapFact.ps1
---
#>

Describe 'Get-MinimapFact' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Track -ModuleName Catzc.Base.Maps {
            if ($Path -like 'widgets/*') {
                [pscustomobject]@{ name = 'widgets'; type = 'modules'; vendor = $null }
            }
            elseif ($Path -like 'gadgets/*') {
                [pscustomobject]@{ name = 'gadgets'; type = 'vendored'; vendor = 'Gadget Inc' }
            }
        }
        Mock Get-PathModule -ModuleName Catzc.Base.Maps {
            if ($Path -like 'widgets/Catzc.Widget/*') {
                [pscustomobject]@{ name = 'Catzc.Widget'; type = 'pwsh-folder' }
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'languages' } {
            [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name ForPath -Value {
                param($file)
                if ($file -like '*.ps1') {
                    [pscustomobject]@{ name = 'powershell' }
                }
            } -PassThru
        }
    }

    It 'places every path by its track, module and language, each read once' {
        $facts = Get-MinimapFact -Path 'widgets/Catzc.Widget/Get-Widget.ps1', 'gadgets/notes.md', 'widgets/Catzc.Widget/Get-Widget.ps1'
        @($facts.Keys | Sort-Object) | Should -Be @('gadgets/notes.md', 'widgets/Catzc.Widget/Get-Widget.ps1')
        Should -Invoke Get-Track -ModuleName Catzc.Base.Maps -Times 2 -Exactly
        $widget = $facts['widgets/Catzc.Widget/Get-Widget.ps1']
        $widget['track'], $widget['tracktype'], $widget['module'], $widget['moduletype'], $widget['language'] |
            Should -Be @('widgets', 'modules', 'Catzc.Widget', 'pwsh-folder', 'powershell')
        $facts['gadgets/notes.md']['vendor'] | Should -Be 'Gadget Inc'
    }

    It 'gives a path outside every track, module and language empty facts, so no minimap places it' {
        $facts = Get-MinimapFact -Path 'loose.txt'
        $facts['loose.txt'].Values | ForEach-Object { $_ | Should -Be '' }
    }

    It 'reads nothing for no paths' {
        (Get-MinimapFact -Path @()).Count | Should -Be 0
        Should -Invoke Get-Track -ModuleName Catzc.Base.Maps -Times 0 -Exactly
    }
}
