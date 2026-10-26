# Rests on [DDR-TRACKTYPE-DECLAREDONCE](/docs/drs/design/track-types.md#rule-ddr-tracktype-declaredonce).
Describe 'Test-TrackDeclaration' -Tag 'L0', 'logic', 'DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES' {
    BeforeAll {
        $script:trackTypes = [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{
                track_types = [ordered]@{
                    'widget-works' = [ordered]@{ definition = 'A deployable cluster of widgets.'; role = 'deployable'; admits = @('widget-folder') }
                    'gadget-shelf' = [ordered]@{ definition = 'A holder of gadgets.'; role = 'holder'; admits = @() }
                }
                vendors     = [ordered]@{ gizmo = [ordered]@{ definition = 'The gizmo platform.' } }
            })
        $script:moduleTypes = [Catzc.Base.Variants.ModuleTypesConfig]::new([ordered]@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{ definition = 'A widget folder.'; places = @(@{ root = 'widget'; name = 'folder' }) }
                    'gadget-tool'   = [ordered]@{ definition = 'A gadget tool.'; places = @(@{ root = 'gadget'; name = 'root' }, @{ root = 'nowhere'; name = 'root' }) }
                }
            })

        function script:Use-Variants {
            param($Tracks)
            $script:variants = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = $Tracks })
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:variants }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'track-types' } { $script:trackTypes }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'module-types' } { $script:moduleTypes }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'languages' } { [pscustomobject]@{ naming_normal_form = 'snake' } }
    }

    It 'names each track whose name is not in the normal form, and takes a dotted snake name' -Tag 'DDR-TRACKTYPE-NAMEFROMMEMBERS' {
        $script:moduleTypes = [Catzc.Base.Variants.ModuleTypesConfig]::new([ordered]@{ module_types = [ordered]@{} })
        Use-Variants ([ordered]@{
                'widget-works'      = [ordered]@{ members = @('widget'); type = 'widget-works' }
                '.gadget'           = [ordered]@{ members = @('gadget'); type = 'gadget-shelf' }
                'vendor_gizmo.cogs' = [ordered]@{ members = @('cogs'); type = 'gadget-shelf'; vendor = 'gizmo' }
            })
        $err = { Test-TrackDeclaration } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*track 'widget-works': the name is not in the repository normal form*"
        $err.Exception.Message | Should -BeLike "*track '.gadget': the name is not in the repository normal form*"
        $err.Exception.Message | Should -Not -BeLike "*vendor_gizmo.cogs*"
        $err.Exception.Message | Should -BeLike '*2 violation(s)*'
    }

    It 'passes when every type and vendor is declared and every module place lies in a track that admits it' {
        Use-Variants ([ordered]@{
                widget = [ordered]@{ members = @('widget'); type = 'widget-works' }
                gadget = [ordered]@{ members = @('gadget'); type = 'widget-works'; vendor = 'gizmo' }
            })
        { Test-TrackDeclaration } | Should -Throw '*gadget-tool*does not admit*'
        $script:moduleTypes = [Catzc.Base.Variants.ModuleTypesConfig]::new([ordered]@{
                module_types = [ordered]@{ 'widget-folder' = [ordered]@{ definition = 'A widget folder.'; places = @(@{ root = 'widget'; name = 'folder' }) } }
            })
        { Test-TrackDeclaration } | Should -Not -Throw
    }

    It 'names a track whose type is not declared and a vendor that is not declared' {
        Use-Variants ([ordered]@{ widget = [ordered]@{ members = @('widget'); type = 'sprocket-works'; vendor = 'cog' } })
        $err = { Test-TrackDeclaration } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*track type 'sprocket-works' is not declared*"
        $err.Exception.Message | Should -BeLike "*vendor 'cog' is not declared*"
    }

    It 'names a track type that admits a module type no registry declares' {
        $script:trackTypes = [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{
                track_types = [ordered]@{ 'widget-works' = [ordered]@{ definition = 'A deployable cluster of widgets.'; role = 'deployable'; admits = @('widget-folder', 'sprocket') } }
            })
        Use-Variants ([ordered]@{ widget = [ordered]@{ members = @('widget'); type = 'widget-works' } })
        { Test-TrackDeclaration } | Should -Throw "*admitted module type 'sprocket' is not declared*"
    }

    It 'names a namespace on a track whose type holds no modules, and takes one on a track that does' {
        $script:trackTypes = [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{
                track_types = [ordered]@{
                    'widget-works' = [ordered]@{ definition = 'A deployable cluster of widgets.'; role = 'deployable'; admits = @('widget-folder') }
                    'gadget-shelf' = [ordered]@{ definition = 'A holder of gadgets.'; role = 'holder'; admits = @() }
                }
            })
        Use-Variants ([ordered]@{
                widget = [ordered]@{ members = @('widget'); type = 'widget-works'; namespace = 'Widgets' }
                gadget = [ordered]@{ members = @('gadget'); type = 'gadget-shelf'; namespace = 'Gizmos' }
            })
        $err = { Test-TrackDeclaration } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*track 'gadget': namespace 'Gizmos' on a track of type 'gadget-shelf', which holds no modules*"
        $err.Exception.Message | Should -Not -BeLike "*namespace 'Widgets'*"
    }
}
