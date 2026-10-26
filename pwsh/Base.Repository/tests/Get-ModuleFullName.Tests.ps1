Describe 'Get-ModuleFullName' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path (Join-Path $script:root 'Base.Widget'), (Join-Path $script:root 'Gadget') | Out-Null
        Set-Content -LiteralPath (Join-Path $script:root 'Base.Widget/Catzc.Base.Widget.psd1') -Value '@{}'
    }

    It 'names a folder by its manifest first, whatever a loaded module there is named' {
        Mock Get-Module -ModuleName Catzc.Base.Repository {
            [pscustomobject]@{ Name = 'Catzc.Base.Gizmo'; ModuleBase = (Join-Path $script:root 'Base.Widget') }
        }
        Get-ModuleFullName (Join-Path $script:root 'Base.Widget') | Should -BeExactly 'Catzc.Base.Widget'
        Should -Invoke Get-Module -ModuleName Catzc.Base.Repository -Times 0 -Exactly
    }

    It 'names a folder with no manifest by the module loaded from it, whatever its folder spells' {
        Mock Get-Module -ModuleName Catzc.Base.Repository {
            [pscustomobject]@{ Name = 'Catzc.Base.Gizmo'; ModuleBase = (Join-Path $script:root 'Gadget') }
        }
        Get-ModuleFullName (Join-Path $script:root 'Gadget') | Should -BeExactly 'Catzc.Base.Gizmo'
    }

    It 'names an unloaded folder by its manifest, and a folder with none by itself' {
        Mock Get-Module -ModuleName Catzc.Base.Repository { }
        Get-ModuleFullName (Join-Path $script:root 'Base.Widget') | Should -BeExactly 'Catzc.Base.Widget'
        Get-ModuleFullName (Join-Path $script:root 'Gadget/') | Should -BeExactly 'Gadget'
    }
}
