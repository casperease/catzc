Describe 'Get-ModuleFolderFullName' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path (Join-Path $script:root 'Base.Widget'), (Join-Path $script:root 'Gadget') | Out-Null
        Set-Content -LiteralPath (Join-Path $script:root 'Base.Widget/Catzc.Base.Widget.psd1') -Value '@{}'
    }

    It 'names a loaded module by its name, whatever its folder spells' {
        Mock Get-Module -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ Name = 'Catzc.Base.Gizmo'; ModuleBase = (Join-Path $script:root 'Gadget') }
        }
        InModuleScope Catzc.Base.ModuleSystem -Parameters @{ Path = (Join-Path $script:root 'Gadget') } {
            param($Path) Get-ModuleFolderFullName $Path
        } | Should -BeExactly 'Catzc.Base.Gizmo'
    }

    It 'names an unloaded folder by its manifest, and a folder with none by itself' {
        Mock Get-Module -ModuleName Catzc.Base.ModuleSystem { }
        InModuleScope Catzc.Base.ModuleSystem -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ModuleFolderFullName (Join-Path $Root 'Base.Widget')
            Get-ModuleFolderFullName (Join-Path $Root 'Gadget')
        } | Should -Be @('Catzc.Base.Widget', 'Gadget')
    }
}
