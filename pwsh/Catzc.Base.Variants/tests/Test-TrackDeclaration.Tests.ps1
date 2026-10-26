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
        # The index tracks one file under every member unless a case says otherwise.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Variants { "$Path/widget.txt" }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Variants { $TestDrive }
        foreach ($folder in 'widget', 'widget.cache', 'gadget') {
            [System.IO.Directory]::CreateDirectory((Join-Path $TestDrive $folder)) | Out-Null
        }
    }

    It 'passes a committed member git tracks and a not-committed member git does not, and names each that disagrees' -Tag 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
        Use-Variants ([ordered]@{
                widget = [ordered]@{ members = @('widget', [ordered]@{ path = 'widget.cache'; generated = $true; committed = $false }); type = 'widget-works' }
            })
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Variants -ParameterFilter { $Path -eq 'widget.cache' } { }
        { Test-TrackDeclaration } | Should -Not -Throw

        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Variants -ParameterFilter { $Path -eq 'widget.cache' } { 'widget.cache/stray.txt' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Variants -ParameterFilter { $Path -eq 'widget' } { }
        $err = { Test-TrackDeclaration } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*member 'widget' is declared committed, but git tracks none of it*"
        $err.Exception.Message | Should -BeLike "*member 'widget.cache' is declared not committed, but git tracks 1 file(s) of it, e.g. 'widget.cache/stray.txt'*"
    }

    It 'leaves a committed member alone while nothing of it is on disk yet' -Tag 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
        Use-Variants ([ordered]@{ widget = [ordered]@{ members = @('widget', '.landing'); type = 'widget-works' } })
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Variants -ParameterFilter { $Path -eq '.landing' } { }
        { Test-TrackDeclaration } | Should -Not -Throw
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
}
