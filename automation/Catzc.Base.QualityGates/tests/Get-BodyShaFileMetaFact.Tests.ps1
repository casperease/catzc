<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-BodyShaFileMetaFact.Tests.ps1
    folder: tests
    name: get-body-sha-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#3
---
#>

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
}
