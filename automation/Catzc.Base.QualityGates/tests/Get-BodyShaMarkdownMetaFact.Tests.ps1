Describe 'Get-BodyShaMarkdownMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{ kinds = [ordered]@{ 'body-sha' = @{ keys = @('body_sha') } } }).kinds[0]
    }

    It 'returns the body hash under the kind''s key' {
        $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`n---`n# docs/widget.md`n`nbody`n")
        $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ Document = $document; Kind = $script:kind } {
            param($Document, $Kind)
            Get-BodyShaMarkdownMetaFact -Document $Document -Path 'docs/widget.md' -Kind $Kind
        }
        $fact.Keys | Should -Be @('body_sha')
        $fact['body_sha'] | Should -BeExactly $document.BodyHash()
        $fact['body_sha'] | Should -Match '^[0-9a-f]{12}$'
    }

    It 'does not move when only the front matter changes' {
        $plain = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("# docs/widget.md`n`nbody`n")
        $framed = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`n---`n# docs/widget.md`n`nbody`n")
        $hash = foreach ($document in $plain, $framed) {
            (InModuleScope Catzc.Base.QualityGates -Parameters @{ Document = $document; Kind = $script:kind } {
                    param($Document, $Kind)
                    Get-BodyShaMarkdownMetaFact -Document $Document -Path 'docs/widget.md' -Kind $Kind
                })['body_sha']
        }
        $hash[0] | Should -BeExactly $hash[1]
    }
}
