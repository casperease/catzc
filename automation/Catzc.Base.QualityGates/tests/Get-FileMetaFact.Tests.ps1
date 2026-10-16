<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FileMetaFact.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1
    adrs:
      - ADR-REPO-FILEMETA#4
---
#>

Describe 'Get-FileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#4' {
    BeforeAll {
        # The one code the fixture cites, registered with ten rules, so the adr-codes kind keeps it.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{ 'ADR-GADGET' = @{ path = 'docs/adr/gadget.md'; rules = 1..10 } }, @())
        }
        $script:state = Get-MarkdownMetaState -Text "# docs/widget.md`n`nSee ADR-GADGET#1.`n"

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
        $facts = Get-Facts @{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('adrs') }; 'body-sha' = @{ keys = @('body_sha') } } }
        $facts.Keys | Should -Be @('adrs', 'body_sha')
        $facts['adrs'] | Should -Be @('ADR-GADGET#1')
    }

    It 'skips a kind that selects neither the file''s class nor its language' -ForEach @(
        @{ Select = @(@{ classes = @('gadget') }) }
        @{ Select = @(@{ languages = @('yaml') }) }
        @{ Select = @(@{ classes = @('widget'); languages = @('yaml') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'body-sha' = @{ keys = @('body_sha'); select = $Select }; 'adr-codes' = @{ keys = @('adrs') } }
        }
        $facts.Keys | Should -Be @('adrs')
    }

    It 'applies a kind when any select entry matches both the class and the language it names' -ForEach @(
        @{ Select = @(@{ classes = @('widget') }) }
        @{ Select = @(@{ classes = @('wid*') }) }
        @{ Select = @(@{ languages = @('markdown') }) }
        @{ Select = @(@{ classes = @('gadget') }, @{ classes = @('widget'); languages = @('markdown') }) }
    ) {
        $facts = Get-Facts @{
            classes = @(@{ class = 'widget'; files = @('docs/**') })
            kinds   = [ordered]@{ 'body-sha' = @{ keys = @('body_sha'); select = $Select } }
        }
        $facts.Keys | Should -Be @('body_sha')
    }

    It 'names the function a kind expected when no module ships it' {
        { Get-Facts @{ kinds = [ordered]@{ widget = @{} } } } |
            Should -Throw "*kind 'widget' is subscribed by 'Get-WidgetFileMetaFact', but no such function exists*"
    }

    It 'uses the function an entry names instead of the convention' {
        Mock Get-FileKindFileMetaFact { [ordered]@{ kind = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('kind'); processor = 'Get-FileKindFileMetaFact' } } }
        $facts['kind'] | Should -BeExactly 'widget'
    }

    It 'rejects a processor that returns keys its kind does not declare' {
        Mock Get-FileKindFileMetaFact { [ordered]@{ surprise = 'x' } } -ModuleName Catzc.Base.QualityGates
        { Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('kind'); processor = 'Get-FileKindFileMetaFact' } } } } |
            Should -Throw "*returned keys ``[surprise``], but kind 'gadget' declares ``[kind``]*"
    }
}
