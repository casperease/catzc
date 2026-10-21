<#
---
catzc:
  immutable:
    with_body_sha: "57c0768eabfc"
  edges:
    code: pwsh/Catzc.Base.Maps/Get-EngineStripMinimapData.ps1
---
#>

Describe 'Get-EngineStripMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/catzc.base.maps/minimap.schema.json'))
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('gadget-shell', @('.sh'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('notes', @('.md'), $null, 'fixture', $null, $null, $null)
        }
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'widgets/Get-Widget.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'widget-script'; module = 'Widgets' } }
            [pscustomobject]@{ Path = 'tests/gadget.sh'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'gadget-shell' } }
            [pscustomobject]@{ Path = 'docs/widget.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'notes' } }
        }
    }

    It 'lights each engine beside the script language a subject file is written in' {
        $data = Get-EngineStripMinimapData -Adr 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @([Catzc.Base.Engines.ExecutionEngines]::Names)
        $data.Axes[1].Values | Should -Not -Contain 'notes'
        $lit = @($data.Lit | ForEach-Object { $_.At -join ' x ' })
        $lit | Should -Contain 'pwsh x widget-script'
        $lit | Should -Contain 'bash x gadget-shell'
        ($data.Lit | Where-Object { $_.At[1] -eq 'widget-script' }).Reasons[0].Note | Should -Be 'Widgets'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }
}
