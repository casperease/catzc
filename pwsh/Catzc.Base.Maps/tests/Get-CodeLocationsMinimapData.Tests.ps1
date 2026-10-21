<#
---
catzc:
  immutable:
    with_body_sha: c8d62e28430e
  edges:
    code: pwsh/Catzc.Base.Maps/Get-CodeLocationsMinimapData.ps1
---
#>

Describe 'Get-CodeLocationsMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/catzc.base.maps/minimap.schema.json'))
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/private/Get-Cog.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/private/Get-Sprocket.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/Get-Widget.ps1'; Requested = 'ADR-GADGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'gadgets/notes.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'gadgets' } }
            [pscustomobject]@{ Path = 'loose.txt'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = $null }
        }
    }

    It 'draws only the places a subject file sits in: track, module and folder, each lit by its files' {
        $data = Get-CodeLocationsMinimapData -Adr 'ADR-WIDGET', 'ADR-GADGET'
        @($data.Axes | ForEach-Object Name) | Should -Be @('track', 'module', 'folder')
        @($data.Cells | ForEach-Object { $_.At -join ' / ' }) | Should -Be @('gadgets / - / .', 'widgets / Catzc.Widget / .', 'widgets / Catzc.Widget / private')
        @($data.Lit | ForEach-Object { $_.Count }) | Should -Be @(1, 1, 2)
        $data.Lit[2].Reasons.Subject | Should -Be @('widgets/Catzc.Widget/private/Get-Cog.ps1', 'widgets/Catzc.Widget/private/Get-Sprocket.ps1')
    }

    It 'gives every lit cell its reason and serializes to the minimap contract' {
        $data = Get-CodeLocationsMinimapData -Adr 'ADR-WIDGET'
        @($data.Lit | Where-Object { $_.Reasons.Count -eq 0 }) | Should -BeNullOrEmpty
        Test-Json -Json (Get-CodeLocationsMinimapData -Adr 'ADR-WIDGET' -AsJson) -Schema $script:schema | Should -BeTrue
    }
}
