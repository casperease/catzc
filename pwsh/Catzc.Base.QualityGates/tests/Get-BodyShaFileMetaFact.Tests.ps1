<#
---
catzc:
  immutable:
    with_body_sha: "4e405bdd1813"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-BodyShaFileMetaFact.ps1
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
---
#>

Describe 'Get-BodyShaFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
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

    It 'hashes the text below a comment head, the same with or without the head' {
        $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<#', '#>')
        $body = "function Get-Gadget { }`n"
        $hash = foreach ($text in $body, "<#`n---`ncatzc:`n  immutable:`n    with_body_sha: `"000000000000`"`n---`n#>`n`n$body") {
            $state = Get-CodeMetaState -Text $text -Form $form
            (InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-BodyShaFileMetaFact -State $State -Path 'widgets/Get-Gadget.ps1' -Kind $Kind
            })['with_body_sha']
        }
        $hash[0] | Should -Match '^[0-9a-f]{12}$'
        $hash[1] | Should -BeExactly $hash[0]
    }

    It 'hashes a JSON file without its head property, the same with or without the head' {
        $hash = foreach ($text in "{`n  `"name`": `"widget`"`n}`n", "{`n  `"//`": `"catzc:\n  immutable:\n    with_body_sha: \`"000000000000\`"`",`n  `"name`": `"widget`"`n}`n") {
            $state = Get-PropertyMetaState -Text $text -Property '//'
            (InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-BodyShaFileMetaFact -State $State -Path 'widgets/widget.json' -Kind $Kind
            })['with_body_sha']
        }
        $hash[0] | Should -Match '^[0-9a-f]{12}$'
        $hash[1] | Should -BeExactly $hash[0]
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

        It 'selects every file, so the head policy alone decides which files carry the stamp' -ForEach @(
            @{ Class = 'glossary'; Language = 'markdown' }
            @{ Class = 'index'; Language = 'markdown' }
            @{ Class = 'function'; Language = 'powershell' }
            @{ Class = 'type'; Language = 'csharp' }
            @{ Class = 'config'; Language = 'yaml' }
        ) {
            $script:shipped.Selects($script:bodySha, $Class, $Language) | Should -BeTrue
        }

        It 'owns the key, so a hash in an authored page''s block is never reported as unowned' {
            $script:shipped.KeysOf('immutable') | Should -Contain 'with_body_sha'
        }
    }
}
