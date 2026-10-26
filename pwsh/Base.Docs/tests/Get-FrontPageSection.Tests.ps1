Describe 'Get-FrontPageSection' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Docs.FrontPageConfig]::new(@{
                target   = 'widgets/README.md'
                title    = 't'
                tagline  = 't'
                closing  = 'c'
                sections = @(
                    @{ id = 'contents'; kind = 'contents'; title = 'Contents' }
                    @{ id = 'rest'; kind = 'fragment'; source = 'docs/widgets/rest.md' }
                    @{ id = 'axioms'; kind = 'records'; title = 'Gadget axioms'; intro = 'Each axiom.'; records = @('WDR-GADGET') }
                )
            })
        Mock Get-FrontPageFragment -ModuleName Catzc.Base.Docs -MockWith {
            [pscustomobject]@{ Title = 'Widgets at rest'; Body = "A widget rests.`n`n### Spin" }
        }
        Mock Format-FrontPageRecords -ModuleName Catzc.Base.Docs -MockWith { "Each axiom.`n`n| Record | Rule |" }
    }

    It 'renders every section with its heading, the fragment titled by its article' {
        $sections = @(Get-FrontPageSection -Config $script:config)
        $sections.Id | Should -Be @('contents', 'rest', 'axioms')
        $sections[1].Markdown | Should -BeLike "## Widgets at rest`n`nA widget rests.*"
        $sections[2].Markdown | Should -BeLike "## Gadget axioms`n`nEach axiom.*"
    }

    It 'lists every other section in the contents, linked by its anchor' {
        $contents = Get-FrontPageSection contents -Config $script:config
        $contents.Markdown | Should -Match '- \[Widgets at rest\]\(#widgets-at-rest\)'
        $contents.Markdown | Should -Match '- \[Gadget axioms\]\(#gadget-axioms\)'
        $contents.Markdown | Should -Not -Match '\[Contents\]'
    }

    It 'throws for a section the config does not declare' {
        { Get-FrontPageSection gadget -Config $script:config } | Should -Throw '*no section ''gadget''*'
    }
}
