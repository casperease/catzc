<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/tests/Format-PropertyMetaHead.Tests.ps1
    folder: tests
    name: format-property-meta-head-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Format-PropertyMetaHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    It 'imprints the facts as the first property, and a second run changes nothing' {
        $facts = [ordered]@{ path = 'widget/gadget.json'; kind = 'other' }
        $once = Format-PropertyMetaHead -Text "{`n  `"name`": `"widget`"`n}`n" -Property '//' -Immutable $facts
        $once | Should -BeExactly "{`n  `"//`": `"catzc:\n  immutable:\n    path: widget/gadget.json\n    kind: other`",`n  `"name`": `"widget`"`n}`n"
        Format-PropertyMetaHead -Text $once -Property '//' -Immutable $facts | Should -BeExactly $once
    }

    It 'removes the property when no facts are given' {
        $text = "{`n  `"//`": `"catzc:\n  immutable:\n    path: a/b.json`",`n  `"name`": `"widget`"`n}`n"
        Format-PropertyMetaHead -Text $text -Property '//' | Should -BeExactly "{`n  `"name`": `"widget`"`n}`n"
    }

    It 'replaces an old value named by -Strip' {
        $text = '{"$comment": "GENERATED FILE — do not edit."}'
        Format-PropertyMetaHead -Text $text -Property '$comment' -Strip 'GENERATED FILE' -Immutable ([ordered]@{ path = 'a/b.json' }) |
            Should -BeExactly '{"$comment": "catzc:\n  immutable:\n    path: a/b.json"}'
    }
}

Describe 'Get-PropertyMetaState' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    It 'reports the sections, the place keys, the edge names and the config lines of the property' {
        $state = Get-PropertyMetaState -Text '{"//": "catzc:\n  immutable:\n    path: a/b.json\n    kind: other\n  edges:\n    page: docs/b.json.md\n  config:\n    note: kept"}' -Property '//'
        $state.IsObject | Should -BeTrue
        $state.HasHead | Should -BeTrue
        $state.Foreign | Should -BeFalse
        $state.Sections | Should -Be @('immutable', 'edges', 'config')
        $state.ImmutableKeys | Should -Be @('path', 'kind')
        $state.EdgeKeys | Should -Be @('page')
        $state.ConfigLines | Should -Be @('    note: kept')
    }

    It 'reports a foreign value, and no head, for a property that holds something else' {
        $state = Get-PropertyMetaState -Text '{"//": "a note"}' -Property '//'
        $state.Foreign | Should -BeTrue
        $state.HasHead | Should -BeFalse
    }

    It 'reports a text that is no object' {
        (Get-PropertyMetaState -Text '[1]' -Property '//').IsObject | Should -BeFalse
    }
}
