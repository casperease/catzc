Describe 'Get-BodyShaFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'body-sha' = @{ keys = @('with_body_sha') } } }).kinds[0]
    }

    It 'returns the body hash under the kind''s key' {
        $state = Get-MarkdownMetaState -Text "---`nname: widget`n---`n# docs/widget.md`n`nbody`n"
        $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
            param($State, $Kind)
            Get-BodyShaFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
        }
        $fact.Keys | Should -Be @('with_body_sha')
        $fact['with_body_sha'] | Should -BeExactly $state.BodyHash
        $fact['with_body_sha'] | Should -Match '^[0-9a-f]{12}$'
    }

    It 'does not move when only the front matter changes' {
        $plain = Get-MarkdownMetaState -Text "# docs/widget.md`n`nbody`n"
        $framed = Get-MarkdownMetaState -Text "---`nname: widget`n---`n# docs/widget.md`n`nbody`n"
        $hash = foreach ($state in $plain, $framed) {
            (InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-BodyShaFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            })['with_body_sha']
        }
        $hash[0] | Should -BeExactly $hash[1]
    }

    Context 'the shipped registry' {
        BeforeAll {
            $script:shipped = Get-Config -Config file-meta
            $script:bodySha = $script:shipped.kinds | Where-Object id -EQ 'body-sha'
        }

        It 'stamps a generated page and never an authored one, so a hand-kept hash on an authored page is no finding' -ForEach @(
            @{ Class = 'comment-page'; Selected = $false }
            @{ Class = 'glossary'; Selected = $true }
            @{ Class = 'index'; Selected = $true }
            @{ Class = 'adr'; Selected = $false }
            @{ Class = 'reference'; Selected = $false }
            @{ Class = 'explanation'; Selected = $false }
        ) {
            $script:shipped.Selects($script:bodySha, $Class, 'markdown') | Should -Be $Selected
        }

        It 'owns the key, so a hash in an authored page''s block is never reported as unowned' {
            $script:shipped.KeysOf('immutable') | Should -Contain 'with_body_sha'
        }
    }
}
