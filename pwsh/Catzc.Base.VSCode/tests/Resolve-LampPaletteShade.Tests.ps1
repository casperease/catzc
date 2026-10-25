Describe 'Resolve-LampPaletteShade' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:palette = [Catzc.Base.VSCode.LampPaletteConfig]::new([ordered]@{ ranges = [ordered]@{ staged = [ordered]@{ mark = '#112233'; background = '#11223344' } } })
    }

    It 'resolves every palette reference in a tree, an alpha suffix included, and leaves other values alone' {
        $tree = [ordered]@{ widget = 'palette.staged.mark'; gadget = @('palette.staged.background', 'palette.staged.mark/59'); plain = 'blue'; count = 3 }
        $resolved = InModuleScope Catzc.Base.VSCode -Parameters @{ Tree = $tree; Palette = $script:palette } {
            param($Tree, $Palette)
            Resolve-LampPaletteShade -InputObject $Tree -Palette $Palette
        }
        $resolved['widget'] | Should -Be '#112233'
        $resolved['gadget'] | Should -Be @('#11223344', '#11223359')
        $resolved['plain'] | Should -Be 'blue'
        $resolved['count'] | Should -Be 3
    }

    It 'throws on an unknown range or shade' {
        foreach ($ref in 'palette.widget.mark', 'palette.staged.gadget') {
            { InModuleScope Catzc.Base.VSCode -Parameters @{ Ref = $ref; Palette = $script:palette } {
                    param($Ref, $Palette)
                    Resolve-LampPaletteShade -InputObject $Ref -Palette $Palette
                } } | Should -Throw "*'$ref' names no*"
        }
    }
}
