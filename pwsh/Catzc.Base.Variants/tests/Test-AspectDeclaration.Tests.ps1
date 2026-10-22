Describe 'Test-AspectDeclaration' -Tag 'L0', 'logic' {

    BeforeAll {
        $script:widgetAspects = [System.Collections.Generic.Dictionary[string, object]]::new()
        $script:widgetAspects['widget'] = @('live')
    }

    It 'is true when the variants config holds aspects for the track' {
        Mock Get-AspectDeclaration -ModuleName Catzc.Base.Variants { , $script:widgetAspects }
        Test-AspectDeclaration widget | Should -BeTrue
    }

    It 'is false when the variants config holds no aspects for the track' {
        Mock Get-AspectDeclaration -ModuleName Catzc.Base.Variants { , $script:widgetAspects }
        Test-AspectDeclaration gadget | Should -BeFalse
    }

    It 'is false when the variants config holds no aspects at all' {
        Mock Get-AspectDeclaration -ModuleName Catzc.Base.Variants { $null }
        Test-AspectDeclaration widget | Should -BeFalse
    }
}
