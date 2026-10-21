<#
---
catzc:
  immutable:
    with_body_sha: cf12ce03e978
  edges:
    code: pwsh/Catzc.Base.QualityGates/Get-FileMetaFact.ps1
    cites:
      - ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION
---
#>

Describe 'Get-FileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
    BeforeAll {
        # The one code the fixture cites, registered with ten rules, so the adr-codes kind keeps it.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{ 'ADR-GADGET' = @{ path = 'docs/adr/gadget.md'; rules = [string[]] @('ADR-GADGET-TURN', 'ADR-GADGET-SPIN', 'ADR-GADGET-FOLD', 'ADR-GADGET-LIFT') } }, @())
        }
        $script:state = Get-MarkdownMetaState -Text "# docs/widget.md`n`nSee ADR-GADGET-TURN.`n"

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

    It 'collects the facts of every kind that applies, in registry order' {
        $facts = Get-Facts @{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites'); section = 'edges' }; 'body-sha' = @{ keys = @('with_body_sha') } } }
        $facts.Immutable.Keys | Should -Be @('with_body_sha')
        $facts.Edges.Keys | Should -Be @('cites')
        $facts.Edges['cites'] | Should -Be @('ADR-GADGET-TURN')
    }

    It 'puts each key into the part its kind names, in registry order within the part' {
        Mock Get-RelativeEdgesFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ 'body-sha' = @{ keys = @('with_body_sha') }; 'adr-codes' = @{ keys = @('cites'); section = 'edges' }; gadget = @{ keys = @('role'); processor = 'Get-RelativeEdgesFileMetaFact' } } }
        $facts.Immutable.Keys | Should -Be @('with_body_sha', 'role')
        $facts.Edges.Keys | Should -Be @('cites')
    }

    It 'skips a kind that selects neither the file''s class nor its language' -ForEach @(
        @{ Select = @(@{ classes = @('gadget') }) }
        @{ Select = @(@{ languages = @('yaml') }) }
        @{ Select = @(@{ classes = @('widget'); languages = @('yaml') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'body-sha' = @{ keys = @('with_body_sha'); select = $Select }; 'adr-codes' = @{ keys = @('cites'); section = 'edges' } }
        }
        $facts.Immutable.Count | Should -Be 0
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
            kinds   = [ordered]@{ 'body-sha' = @{ keys = @('with_body_sha'); select = $Select } }
        }
        $facts.Immutable.Keys | Should -Be @('with_body_sha')
    }

    It 'names the function a kind expected when no module ships it' {
        { Get-Facts @{ kinds = [ordered]@{ widget = @{} } } } |
            Should -Throw "*kind 'widget' is subscribed by 'Get-WidgetFileMetaFact', but no such function exists*"
    }

    It 'uses the function an entry names instead of the convention' {
        Mock Get-BodyShaFileMetaFact { [ordered]@{ role = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-BodyShaFileMetaFact' } } }
        $facts.Immutable['role'] | Should -BeExactly 'widget'
    }

    It 'reads each file in scope by its path, and a head on the file changes no fact' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites'); section = 'edges' }; 'body-sha' = @{ keys = @('with_body_sha') } } })
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
        $facts[1].Immutable['with_body_sha'] | Should -BeExactly $facts[0].Immutable['with_body_sha']
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
        Mock Get-BodyShaFileMetaFact { [ordered]@{ surprise = 'x' } } -ModuleName Catzc.Base.QualityGates
        { Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('role'); processor = 'Get-BodyShaFileMetaFact' } } } } |
            Should -Throw "*returned keys ``[surprise``], but kind 'gadget' declares ``[role``]*"
    }
}
