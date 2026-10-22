<#
---
catzc:
  edges:
    cites:
      - ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION
      - ADR-REPO-FILEMETA-FILEISNODE
---
#>

Describe 'Get-FileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
    BeforeAll {
        # The one code the fixture cites, registered with ten rules, so the drs-codes kind keeps it.
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Drs.DrsCitationMap]::new(@{ 'ADR-GADGET' = @{ path = 'docs/drs/gadget.md'; rules = [string[]] @('ADR-GADGET-TURN', 'ADR-GADGET-SPIN', 'ADR-GADGET-FOLD', 'ADR-GADGET-LIFT') } }, @())
        }
        $script:state = Get-MarkdownMetaState -Text "# docs/widget.md`n`nSee ADR-GADGET-TURN.`n"
        # A fixture kind with a fixture processor, so a second kind writes into the edges beside the shipped one.
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetShadeFileMetaFact {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The engine passes State, Path and Kind by name; the fixture fact needs none')]
                param($State, $Path, $Kind)
                [ordered]@{ shade = 'blue' }
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
        }
    }

    It 'collects the facts of every kind that applies, in registry order' {
        $facts = Get-Facts @{ kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites'); section = 'edges' }; 'widget-shade' = @{ keys = @('shade') } } }
        $facts.Immutable.Count | Should -Be 0
        $facts.Edges.Keys | Should -Be @('cites', 'shade')
        $facts.Edges['cites'] | Should -Be @('ADR-GADGET-TURN')
    }

    It 'puts every key into the edges, the one part an imprint kind writes, in registry order' -Tag 'ADR-REPO-FILEMETA-FILEISNODE' {
        Mock Get-RelativeEdgesFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ 'widget-shade' = @{ keys = @('shade') }; 'drs-codes' = @{ keys = @('cites'); section = 'edges' }; gadget = @{ keys = @('role'); processor = 'Get-RelativeEdgesFileMetaFact' } } }
        $facts.Immutable.Count | Should -Be 0
        $facts.Edges.Keys | Should -Be @('shade', 'cites', 'role')
    }

    It 'skips a kind that selects neither the file''s class nor its language' -ForEach @(
        @{ Select = @(@{ classes = @('gadget') }) }
        @{ Select = @(@{ languages = @('yaml') }) }
        @{ Select = @(@{ classes = @('widget'); languages = @('yaml') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'widget-shade' = @{ keys = @('shade'); select = $Select }; 'drs-codes' = @{ keys = @('cites'); section = 'edges' } }
        }
        $facts.Edges.Keys | Should -Be @('cites')
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
        Mock Get-DrsCodesFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-DrsCodesFileMetaFact' } } }
        $facts.Edges['role'] | Should -BeExactly 'widget'
    }

    It 'reads each file in scope by its path, and a head on the file changes no fact' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites'); section = 'edges' } } })
        $body = "# docs/widget.md`n`nSee ADR-GADGET-TURN.`n"
        $headed = "---`ncatzc:`n  immutable:`n    with_body_sha: `"000000000000`"`n  edges:`n    cites:`n      - ADR-GADGET-SPIN`n---`n`n" + $body
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
        $facts[1].Edges['cites'] | Should -Be @('ADR-GADGET-TURN')
        $facts[1].Edges['cites'] | Should -Be $facts[0].Edges['cites']
    }

    It 'skips a file the index lists but the working tree has lost' {
        $carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::FrontMatter; key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/gone-widget.md'; Carrier = $carrier } }
        @(InModuleScope Catzc.Base.QualityGates { Get-FileMetaFact 'docs/gone-widget.md' }).Count | Should -Be 0
    }

    It 'skips a file whose carrier is a sidecar' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget.png'; Carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::Sidecar } } }
        @(InModuleScope Catzc.Base.QualityGates { Get-FileMetaFact 'docs/widget.png' }).Count | Should -Be 0
    }

    It 'rejects -State with more than one path' {
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $script:state } { param($State) Get-FileMetaFact -State $State -Path 'docs/widget.md', 'docs/gadget.md' } } |
            Should -Throw '*reads one file, but 2 paths were given*'
    }

    It 'rejects a processor that returns keys its kind does not declare' {
        Mock Get-DrsCodesFileMetaFact { [ordered]@{ surprise = 'x' } } -ModuleName Catzc.Base.QualityGates
        { Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-DrsCodesFileMetaFact' } } } } |
            Should -Throw "*returned keys ``[surprise``], but kind 'gadget' declares ``[role``]*"
    }
}
