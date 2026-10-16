<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/tests/types/PropertyHead.Tests.ps1
    folder: tests/types
    name: property-head-tests
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

Describe 'Catzc.Base.CodeMeta.PropertyHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        # '~' stands for a real line end in the single-quoted JSON below, so a JSON '\n' escape stays a backslash and an n.
        function Get-Lines {
            param([string] $Template, [string] $NewLine = "`n")
            $Template -replace '~', $NewLine
        }

        $script:facts = [ordered]@{ path = 'a/b.json'; kind = 'other' }
        $script:none = [ordered]@{}
        $script:member = '"//": "catzc:\n  immutable:\n    path: a/b.json\n    kind: other"'
    }

    It 'imprints the property first, and a second run changes nothing' {
        $text = Get-Lines '{~  "name": "widget"~}~'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $once | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '//').WithFacts($script:facts, $script:none) | Should -BeExactly $once
    }

    It 'reads back the keys of the block it wrote' {
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse('{"name": "widget"}', '//').WithFacts($script:facts, $script:none)
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '//')
        $head.HasHead | Should -BeTrue
        $head.Foreign | Should -BeFalse
        @($head.Sections) | Should -Be @('immutable')
        @($head.ImmutableKeys) | Should -Be @('path', 'kind')
        @($head.EdgeKeys).Count | Should -Be 0
    }

    It 'writes valid JSON that keeps the other members whatever they hold' {
        $text = '{"url": "http://widget/{gadget}", "list": [1, {"a": "}"}], "n": 2}'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $parsed = $once | ConvertFrom-Json -AsHashtable
        ($parsed.Keys | Select-Object -First 1) | Should -Be '//'
        $parsed['url'] | Should -Be 'http://widget/{gadget}'
        $parsed['n'] | Should -Be 2
        $parsed['//'] | Should -Be "catzc:`n  immutable:`n    path: a/b.json`n    kind: other"
    }

    It 'rewrites the property in place when the facts change' {
        $text = Get-Lines "{~  `"//`": `"catzc:\n  immutable:\n    path: old.json`",~  `"name`": `"widget`"~}~"
        $fixed = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $fixed | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
    }

    It 'moves a property that is not the first member to the front' {
        $text = Get-Lines "{~  `"name`": `"widget`",~  `"//`": `"catzc:\n  immutable:\n    path: old.json`"~}~"
        $fixed = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $fixed | Should -BeExactly (Get-Lines "{~  $($script:member),~  `"name`": `"widget`"~}~")
    }

    It 'keeps the authored config under the block when the facts change' {
        $text = '{"//": "catzc:\n  immutable:\n    path: old.json\n  config:\n    note: kept"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
        @($head.ConfigLines) | Should -Be @('    note: kept')
        $head.WithFacts($script:facts, $script:none) | Should -BeExactly '{"//": "catzc:\n  immutable:\n    path: a/b.json\n    kind: other\n  config:\n    note: kept"}'
    }

    It 'removes the property when there are no facts, with its comma' {
        $first = Get-Lines "{~  `"//`": `"catzc:\n  immutable:\n    path: a/b.json`",~  `"name`": `"widget`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($first, '//').WithFacts($script:none, $script:none) | Should -BeExactly (Get-Lines "{~  `"name`": `"widget`"~}~")

        $last = Get-Lines "{~  `"name`": `"widget`",~  `"//`": `"catzc:\n  immutable:\n    path: a/b.json`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($last, '//').WithFacts($script:none, $script:none) | Should -BeExactly (Get-Lines "{~  `"name`": `"widget`"~}~")

        $only = Get-Lines "{~  `"//`": `"catzc:\n  immutable:\n    path: a/b.json`"~}~"
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($only, '//').WithFacts($script:none, $script:none) | Should -BeExactly (Get-Lines '{}~')
    }

    It 'fills an empty object' {
        [Catzc.Base.CodeMeta.PropertyHead]::Parse((Get-Lines '{}~'), '//').WithFacts($script:facts, $script:none) | Should -BeExactly (Get-Lines "{~  $($script:member)~}~")
    }

    It 'follows the indent and the line end of the file' {
        $text = Get-Lines '{~    "name": "widget"~}~' "`r`n"
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $once | Should -BeExactly (Get-Lines "{~    $($script:member),~    `"name`": `"widget`"~}~" "`r`n")
    }

    It 'works with the property name of a JSON schema comment' {
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse('{"type": "object"}', '$comment').WithFacts($script:facts, $script:none)
        ($once | ConvertFrom-Json -AsHashtable).ContainsKey('$comment') | Should -BeTrue
        [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, '$comment').HasHead | Should -BeTrue
    }

    It 'leaves a foreign value of the property alone and says so' {
        $text = '{"//": "a note someone wrote"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
        $head.Foreign | Should -BeTrue
        $head.HasHead | Should -BeFalse
        $head.WithFacts($script:facts, $script:none) | Should -BeExactly $text
    }

    It 'replaces an old value that starts with a strip opener' {
        $text = '{"//": "GENERATED FILE — do not edit.", "name": "widget"}'
        $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//', [string[]] @('GENERATED FILE'))
        $head.Foreign | Should -BeFalse
        $head.WithFacts($script:facts, $script:none) | Should -BeExactly ('{' + $script:member + ', "name": "widget"}')
    }

    It 'never changes a text that is no JSON object' {
        foreach ($text in '[1, 2]', '', '"widget"', '{"a": ') {
            $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//')
            $head.IsObject | Should -BeFalse
            $head.WithFacts($script:facts, $script:none) | Should -BeExactly $text
        }
    }

    It 'reads past comments in a JSON file with comments' {
        $text = Get-Lines '// settings~{~  /* the name */ "name": "widget" // trailing~}~'
        $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts($script:facts, $script:none)
        $once | Should -BeLike '*"//": "catzc:*'
        $once | Should -BeLike '*"name": "widget" // trailing*'
    }

    Context 'an XML project' {
        BeforeAll {
            $script:project = "<!-- widget project -->~<Project Sdk=`"Widget.Sdk`">~~  <PropertyGroup>~    <Gadget>1</Gadget>~  </PropertyGroup>~</Project>~"
            $script:project = $script:project -replace '~', "`n"
        }

        It 'imprints a labelled first property group and a second run changes nothing' {
            $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($script:project, 'CatzcMeta').WithFacts($script:facts, $script:none)
            $once | Should -BeLike '*<Project Sdk="Widget.Sdk">*<PropertyGroup Label="catzc">*<CatzcMeta><![[]CDATA[[]catzc:*immutable:*path: a/b.json*kind: other]]></CatzcMeta>*<Gadget>1</Gadget>*'
            ([xml] $once).Project.PropertyGroup[0].CatzcMeta | Should -Be "catzc:`n  immutable:`n    path: a/b.json`n    kind: other"
            [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, 'CatzcMeta').WithFacts($script:facts, $script:none) | Should -BeExactly $once
        }

        It 'reads back the keys of the block it wrote' {
            $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($script:project, 'CatzcMeta').WithFacts($script:facts, $script:none)
            $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, 'CatzcMeta')
            $head.IsObject | Should -BeTrue
            $head.HasHead | Should -BeTrue
            $head.Foreign | Should -BeFalse
            @($head.ImmutableKeys) | Should -Be @('path', 'kind')
        }

        It 'removes the block when there are no facts and gives the original text back' {
            $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($script:project, 'CatzcMeta').WithFacts($script:facts, $script:none)
            [Catzc.Base.CodeMeta.PropertyHead]::Parse($once, 'CatzcMeta').WithFacts($script:none, $script:none) | Should -BeExactly $script:project
        }

        It 'leaves a foreign property of that name alone and says so' {
            $text = $script:project -replace '<Gadget>1</Gadget>', '<CatzcMeta>mine</CatzcMeta>'
            $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, 'CatzcMeta')
            $head.Foreign | Should -BeTrue
            $head.WithFacts($script:facts, $script:none) | Should -BeExactly $text
        }

        It 'places the block after a prolog and a comment before the root' {
            $text = "<?xml version=`"1.0`"?>`n" + $script:project
            $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, 'CatzcMeta').WithFacts($script:facts, $script:none)
            $once | Should -BeLike "<?xml version=`"1.0`"?>*<!-- widget project -->*<Project Sdk=`"Widget.Sdk`">*<PropertyGroup Label=`"catzc`">*"
            { [xml] $once } | Should -Not -Throw
        }

        It 'follows the line end of the file' {
            $text = $script:project -replace "`n", "`r`n"
            $once = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, 'CatzcMeta').WithFacts($script:facts, $script:none)
            $once | Should -BeLike "*`r`n  <PropertyGroup Label=`"catzc`">`r`n    <CatzcMeta>*</CatzcMeta>`r`n  </PropertyGroup>*"
        }
    }
}
