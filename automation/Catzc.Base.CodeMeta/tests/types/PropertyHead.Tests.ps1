<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/tests/types/PropertyHead.Tests.ps1
    kind: test
---
#>

Describe 'Catzc.Base.CodeMeta.PropertyHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        # '~' stands for a real line end in the single-quoted JSON below, so a JSON '\n' escape stays a backslash and an n.
        function Get-Lines {
            param([string] $Template, [string] $NewLine = "`n")
            $Template -replace '~', $NewLine
        }

        $script:facts = [ordered]@{ path = 'a/b.json'; kind = 'other' }
        $script:member = '"//": "catzc:\n  derived:\n    path: a/b.json\n    kind: other"'
    }

    It 'imprints the property first, and a second run changes nothing' {
        $text = Get-Lines '{~  "name": "widget"~}~'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $once | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '//').WithFacts($script:facts) | Should -BeExactly $once
    }

    It 'reads back the keys of the block it wrote' {
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse('{"name": "widget"}', '//').WithFacts($script:facts)
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '//')
        $head.HasHead | Should -BeTrue
        $head.Foreign | Should -BeFalse
        @($head.Sections) | Should -Be @('derived')
        @($head.DerivedKeys) | Should -Be @('path', 'kind')
    }

    It 'writes valid JSON that keeps the other members whatever they hold' {
        $text = '{"url": "http://widget/{gadget}", "list": [1, {"a": "}"}], "n": 2}'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $parsed = $once | ConvertFrom-Json -AsHashtable
        @($parsed.Keys)[0] | Should -Be '//'
        $parsed['url'] | Should -Be 'http://widget/{gadget}'
        $parsed['n'] | Should -Be 2
        $parsed['//'] | Should -Be "catzc:`n  derived:`n    path: a/b.json`n    kind: other"
    }

    It 'rewrites the property in place when the facts change' {
        $text = Get-Lines "{~  `"//`": `"catzc:\n  derived:\n    path: old.json`",~  `"name`": `"widget`"~}~"
        $fixed = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $fixed | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
    }

    It 'moves a property that is not the first member to the front' {
        $text = Get-Lines "{~  `"name`": `"widget`",~  `"//`": `"catzc:\n  derived:\n    path: old.json`"~}~"
        $fixed = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $fixed | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
    }

    It 'keeps the authored config under the block when the facts change' {
        $text = '{"//": "catzc:\n  derived:\n    path: old.json\n  config:\n    note: kept"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
        @($head.ConfigLines) | Should -Be @('    note: kept')
        $head.WithFacts($script:facts) | Should -BeExactly '{"//": "catzc:\n  derived:\n    path: a/b.json\n    kind: other\n  config:\n    note: kept"}'
    }

    It 'removes the property when there are no facts, with its comma' {
        $first = Get-Lines "{~  `"//`": `"catzc:\n  derived:\n    path: a/b.json`",~  `"name`": `"widget`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($first, '//').WithFacts([ordered]@{}) | Should -BeExactly (Get-Lines "{~  `"name`": `"widget`"~}~")

        $last = Get-Lines "{~  `"name`": `"widget`",~  `"//`": `"catzc:\n  derived:\n    path: a/b.json`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($last, '//').WithFacts([ordered]@{}) | Should -BeExactly (Get-Lines "{~  `"name`": `"widget`"~}~")

        $only = Get-Lines "{~  `"//`": `"catzc:\n  derived:\n    path: a/b.json`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($only, '//').WithFacts([ordered]@{}) | Should -BeExactly (Get-Lines '{}~')
    }

    It 'fills an empty object' {
        [Catzc.Base.CodeMeta.PropertyHead]::Parse((Get-Lines '{}~'), '//').WithFacts($script:facts) | Should -BeExactly (Get-Lines "{~  $($script:member)~}~")
    }

    It 'follows the indent and the line end of the file' {
        $text = Get-Lines '{~    "name": "widget"~}~' "`r`n"
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $once | Should -BeExactly (Get-Lines "{~    $($script:member),~    `"name`": `"widget`"~}~" "`r`n")
    }

    It 'works with the property name of a JSON schema comment' {
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse('{"type": "object"}', '$comment').WithFacts($script:facts)
        ($once | ConvertFrom-Json -AsHashtable).ContainsKey('$comment') | Should -BeTrue
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '$comment').HasHead | Should -BeTrue
    }

    It 'leaves a foreign value of the property alone and says so' {
        $text = '{"//": "a note someone wrote"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
        $head.Foreign | Should -BeTrue
        $head.HasHead | Should -BeFalse
        $head.WithFacts($script:facts) | Should -BeExactly $text
    }

    It 'replaces an old value that starts with a strip opener' {
        $text = '{"//": "GENERATED FILE — do not edit.", "name": "widget"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//', [string[]] @('GENERATED FILE'))
        $head.Foreign | Should -BeFalse
        $head.WithFacts($script:facts) | Should -BeExactly ('{' + $script:member + ', "name": "widget"}')
    }

    It 'never changes a text that is no JSON object' {
        foreach ($text in '[1, 2]', '', '"widget"', '{"a": ') {
            $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
            $head.IsObject | Should -BeFalse
            $head.WithFacts($script:facts) | Should -BeExactly $text
        }
    }

    It 'reads past comments in a JSON file with comments' {
        $text = Get-Lines '// settings~{~  /* the name */ "name": "widget" // trailing~}~'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts)
        $once | Should -BeLike '*"//": "catzc:*'
        $once | Should -BeLike '*"name": "widget" // trailing*'
    }
}
