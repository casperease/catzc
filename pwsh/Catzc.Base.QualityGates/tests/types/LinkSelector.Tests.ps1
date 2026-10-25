# A selector is lists of facet values, an empty list meaning any; a class selects its subkinds and takes at most one '*'.
Describe 'LinkSelector' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-DIRECTIONSAREROWS', 'ADR-REPO-LINKS-ENDPOINTSAREFACETS' {
    BeforeAll {
        $script:end = {
            param([string] $Class, [string] $Aspect = '', [string] $Track = 'mods', [string] $TrackType = 'widgets', [string] $Module = 'Widget')
            [Catzc.Base.QualityGates.LinkEndpoint]::new('mods/Widget/Get-Widget.ps1', $Class, $Aspect, $Track, $TrackType, $Module)
        }
        $script:select = { param([hashtable] $Raw) [Catzc.Base.QualityGates.LinkSelector]::new($Raw, 'row 1.from') }
    }

    It 'matches any endpoint when it lists nothing' {
        (& $select @{}).Matches((& $end 'code/script')) | Should -BeTrue
    }

    It 'selects a role with its subkinds, a role/subkind exactly, and one star as any run' {
        (& $select @{ classes = @('reference') }).Matches((& $end 'reference/gadget')) | Should -BeTrue
        (& $select @{ classes = @('reference') }).Matches((& $end 'referenced')) | Should -BeFalse -Because 'a role selects its own subkinds, not a longer name'
        (& $select @{ classes = @('reference/gadget') }).Matches((& $end 'reference/widget')) | Should -BeFalse
        (& $select @{ classes = @('code/*-page') }).Matches((& $end 'code/comment-page')) | Should -BeTrue
    }

    It 'needs every listed facet to hold' {
        $selector = & $select @{ aspects = @('live'); track_types = @('widgets'); modules = @('Widget') }
        $selector.Matches((& $end 'code' 'live')) | Should -BeTrue
        $selector.Matches((& $end 'code' 'tests')) | Should -BeFalse
        $selector.Matches((& $end 'code' 'live' 'mods' 'widgets' 'Gadget')) | Should -BeFalse
    }

    It 'refuses a glob, a second star, a star outside a class and an unknown key' {
        { & $select @{ classes = @('code/**') } } | Should -Throw '*no facet value*'
        { & $select @{ tracks = @('mods/*') } } | Should -Throw '*no facet value*'
        { & $select @{ modules = @('Wid?et') } } | Should -Throw '*no facet value*'
        { & $select @{ paths = @('mods') } } | Should -Throw '*row 1.from: unknown key*'
    }
}
