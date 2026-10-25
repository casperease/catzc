Describe 'Get-FileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
    BeforeAll {
        $script:state = Get-MarkdownMetaState -Text "# docs/widget.md`n`nA gadget tint.`n"
        # Two fixture kinds with fixture processors: a fixed shade, and a tint read from the file's body, never from its head.
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetShadeFileMetaFact {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The engine passes State, Path and Kind by name; the fixture fact needs none')]
                param($State, $Path, $Kind)
                [ordered]@{ shade = 'blue' }
            }
            function script:Get-WidgetTintFileMetaFact {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The engine passes State, Path and Kind by name; the fixture fact reads the body alone')]
                param($State, $Path, $Kind)
                $body = if ($State.PSObject.Properties['Body']) {
                    $State.Body
                }
                else {
                    $State.Rest
                }
                [ordered]@{ tint = ($body -split "`n" | Where-Object { $_ -like '*tint*' } | Select-Object -First 1) }
            }
        }

        # A fixture registry: the `classes` of a test's raw config become the kinds the file-kinds registry names, and none leaves every file other.
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{})
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        function script:Get-Facts {
            param($Raw, [string] $Path = 'docs/widget.md')
            $kindMap = [ordered]@{}
            foreach ($entry in @($Raw['classes'])) {
                if ($entry) {
                    $kindMap[$entry.class] = [ordered]@{ definition = "A $($entry.class) file."; files = $entry.files }
                }
            }
            $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{ kinds = $kindMap })
            $meta = @{}
            foreach ($key in $Raw.Keys) {
                if ($key -ne 'classes') {
                    $meta[$key] = $Raw[$key]
                }
            }
            $config = [Catzc.Base.QualityGates.FileMetaConfig]::new($meta)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $script:state; Config = $config; Path = $Path } {
                param($State, $Config, $Path)
                Get-FileMetaFact -State $State -Path $Path -Config $Config
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetShadeFileMetaFact -ErrorAction Ignore
            Remove-Item Function:\Get-WidgetTintFileMetaFact -ErrorAction Ignore
        }
    }

    It 'collects the facts of every kind that applies, in registry order' {
        $facts = Get-Facts @{ kinds = [ordered]@{ 'widget-tint' = @{ keys = @('tint') }; 'widget-shade' = @{ keys = @('shade') } } }
        @($facts.PSObject.Properties.Name) | Should -Be @('Edges') -Because 'an imprint kind writes edges only, so no immutable part comes back'
        $facts.Edges.Keys | Should -Be @('tint', 'shade')
        $facts.Edges['tint'] | Should -BeExactly 'A gadget tint.'
    }

    It 'puts every key into the edges, the one part an imprint kind writes, in registry order' -Tag 'ADR-REPO-FILEMETA-FILEISNODE' {
        Mock Get-RelativeEdgesFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ 'widget-shade' = @{ keys = @('shade') }; 'widget-tint' = @{ keys = @('tint') }; gadget = @{ keys = @('role'); processor = 'Get-RelativeEdgesFileMetaFact' } } }
        @($facts.PSObject.Properties.Name) | Should -Be @('Edges') -Because 'an imprint kind writes edges only, so no immutable part comes back'
        $facts.Edges.Keys | Should -Be @('shade', 'tint', 'role')
    }

    It 'skips a kind that selects neither the file''s class nor its language' -ForEach @(
        @{ Select = @(@{ classes = @('gadget') }) }
        @{ Select = @(@{ languages = @('yaml') }) }
        @{ Select = @(@{ classes = @('widget'); languages = @('yaml') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'widget-shade' = @{ keys = @('shade'); select = $Select }; 'widget-tint' = @{ keys = @('tint') } }
        }
        $facts.Edges.Keys | Should -Be @('tint')
    }

    It 'applies a kind when any select entry matches both the class and the language it names' -ForEach @(
        @{ Select = @(@{ classes = @('widget') }) }
        @{ Select = @(@{ classes = @('wid*') }) }
        @{ Select = @(@{ languages = @('markdown') }) }
        @{ Select = @(@{ classes = @('gadget') }, @{ classes = @('widget'); languages = @('markdown') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'widget-shade' = @{ keys = @('shade'); select = $Select } }
        }
        $facts.Edges.Keys | Should -Be @('shade')
    }

    It 'names the function a kind expected when no module ships it' {
        { Get-Facts @{ kinds = [ordered]@{ widget = @{} } } } |
            Should -Throw "*kind 'widget' is subscribed by 'Get-WidgetFileMetaFact', but no such function exists*"
    }

    It 'uses the function an entry names instead of the convention' {
        Mock Get-RelativeEdgesFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-RelativeEdgesFileMetaFact' } } }
        $facts.Edges['role'] | Should -BeExactly 'widget'
    }

    It 'reads each file in scope by its path, and a head on the file changes no fact' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'widget-tint' = @{ keys = @('tint') } } })
        $body = "# docs/widget.md`n`nA gadget tint.`n"
        $headed = "---`ncatzc:`n  tint: a head tint`n  immutable:`n    with_body_sha: `"000000000000`"`n---`n`n" + $body
        $carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::FrontMatter; key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates { foreach ($item in $Path) {
                [pscustomobject]@{ Path = $item; Carrier = $carrier }
            } }
        New-Item -ItemType Directory -Force -Path (Join-Path $TestDrive 'docs') | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'docs/widget.md'), $body)
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'docs/gadget.md'), $headed)
        $facts = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Config = $config } { param($Config) Get-FileMetaFact 'docs/widget.md', 'docs/gadget.md' -Config $Config })
        $facts.Path | Should -Be @('docs/widget.md', 'docs/gadget.md')
        $facts[1].Edges['tint'] | Should -BeExactly 'A gadget tint.'
        $facts[1].Edges['tint'] | Should -Be $facts[0].Edges['tint']
    }

    It 'skips a file the index lists but the working tree has lost' {
        $carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::FrontMatter; key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/gone-widget.md'; Carrier = $carrier } }
        @(InModuleScope Catzc.Base.QualityGates { Get-FileMetaFact 'docs/gone-widget.md' }).Count | Should -Be 0
    }

    It 'rejects -State with more than one path' {
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $script:state } { param($State) Get-FileMetaFact -State $State -Path 'docs/widget.md', 'docs/gadget.md' } } |
            Should -Throw '*reads one file, but 2 paths were given*'
    }

    It 'rejects a processor that returns keys its kind does not declare' {
        Mock Get-RelativeEdgesFileMetaFact { [ordered]@{ surprise = 'x' } } -ModuleName Catzc.Base.QualityGates
        { Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-RelativeEdgesFileMetaFact' } } } } |
            Should -Throw "*returned keys ``[surprise``], but kind 'gadget' declares ``[role``]*"
    }
}
