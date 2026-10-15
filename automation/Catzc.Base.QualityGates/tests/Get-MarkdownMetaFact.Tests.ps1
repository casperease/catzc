Describe 'Get-MarkdownMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#4' {
    BeforeAll {
        $script:document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("# docs/widget.md`n`nSee ADR-GADGET#1.`n")

        function script:Get-Facts {
            param($Raw, [string] $Path = 'docs/widget.md')
            $config = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new($Raw)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Document = $script:document; Config = $config; Path = $Path } {
                param($Document, $Config, $Path)
                Get-MarkdownMetaFact -Document $Document -Path $Path -Config $Config
            }
        }
    }

    It 'collects the facts of every kind that applies, in registry order' {
        $facts = Get-Facts @{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('adrs') }; 'body-sha' = @{ keys = @('body_sha') } } }
        $facts.Keys | Should -Be @('adrs', 'body_sha')
        $facts['adrs'] | Should -Be @('ADR-GADGET#1')
    }

    It 'skips a kind whose globs do not match the file' {
        $facts = Get-Facts @{ kinds = [ordered]@{ 'body-sha' = @{ keys = @('body_sha'); files = @('other/**') }; 'adr-codes' = @{ keys = @('adrs') } } }
        $facts.Keys | Should -Be @('adrs')
    }

    It 'names the function a kind expected when no module ships it' {
        { Get-Facts @{ kinds = [ordered]@{ widget = @{} } } } |
            Should -Throw "*kind 'widget' is subscribed by 'Get-WidgetMarkdownMetaFact', but no such function exists*"
    }

    It 'uses the function an entry names instead of the convention' {
        Mock Get-DocumentKindMarkdownMetaFact { [ordered]@{ kind = 'widget' } } -ModuleName Catzc.Base.QualityGates
        $facts = Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('kind'); processor = 'Get-DocumentKindMarkdownMetaFact' } } }
        $facts['kind'] | Should -BeExactly 'widget'
    }

    It 'rejects a processor that returns keys its kind does not declare' {
        Mock Get-DocumentKindMarkdownMetaFact { [ordered]@{ surprise = 'x' } } -ModuleName Catzc.Base.QualityGates
        { Get-Facts @{ kinds = [ordered]@{ gadget = @{ keys = @('kind'); processor = 'Get-DocumentKindMarkdownMetaFact' } } } } |
            Should -Throw "*returned keys [surprise], but kind 'gadget' declares [kind]*"
    }
}
