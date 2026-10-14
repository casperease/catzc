# CommentLexer finds the comment spans a code link may live in
# ([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)) and must never mistake a string for
# one ([ADR-REPO-LINK#6](/docs/adr/repository/markdown-links.md#rule-adr-repo-link6)). Each case asserts the comment
# texts found in a short widget/gadget snippet.
Describe 'CommentLexer' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:commentTexts = {
            param([string] $Text, [string] $Extension)
            foreach ($span in [Catzc.Base.QualityGates.CommentLexer]::Comments($Text, $Extension)) {
                $Text.Substring($span.Item1, $span.Item2)
            }
        }
    }

    It 'finds PowerShell line comments and help blocks, not a # inside a string or a here-string' -Tag 'ADR-REPO-LINK#1' {
        $source = @(
            '<#'
            '.SYNOPSIS'
            '    Widget help.'
            '#>'
            "`$tag = '#not-a-comment'   # widget comment"
            "`$block = @'"
            '# not a comment either'
            "'@"
        ) -join "`n"
        $found = @(& $commentTexts $source '.ps1')
        $found.Count | Should -Be 2
        $found[0] | Should -BeLike '<#*#>'
        $found[1] | Should -BeExactly '# widget comment'
    }

    It 'finds C# //, ///, and /* */ comments, never the same text inside a string' -Tag 'ADR-REPO-LINK#1' {
        $source = @(
            '/// <summary>Widget.</summary>'
            'var url = "http://gadget"; // trailing'
            'var raw = """'
            '  // not a comment'
            '  """;'
            'var verbatim = @"C:\// not either";'
            'char slash = ''/'';'
            '/* block'
            '   widget */'
        ) -join "`n"
        $found = @(& $commentTexts $source '.cs')
        $found | Should -Be @('/// <summary>Widget.</summary>', '// trailing', "/* block`n   widget */")
    }

    It 'finds YAML comments, not a # inside a quoted scalar or a block scalar' -Tag 'ADR-REPO-LINK#1' {
        $source = @(
            '# widget header'
            'key: "a # b"   # trailing'
            "other: 'it''s # fine'"
            'text: |'
            '  # literal content'
            '  more'
            'next: widget#gadget'
            '# gadget footer'
        ) -join "`n"
        $found = @(& $commentTexts $source '.yml')
        $found | Should -Be @('# widget header', '# trailing', '# gadget footer')
    }

    It 'finds XML comments in a project file' -Tag 'ADR-REPO-LINK#1' {
        $found = @(& $commentTexts '<Project><!-- widget --><PropertyGroup /></Project>' '.csproj')
        $found | Should -Be @('<!-- widget -->')
    }

    It 'returns PowerShell string literals as data spans' -Tag 'ADR-REPO-LINK#6' {
        $source = "`$path = 'docs/adr/widget.md'   # see gadget"
        $strings = @(foreach ($span in [Catzc.Base.QualityGates.CommentLexer]::PowerShellStrings($source)) {
                $source.Substring($span.Item1, $span.Item2)
            })
        $strings | Should -Be @("'docs/adr/widget.md'")
    }

    Context 'string literals of every code family' {
        BeforeAll {
            $script:stringTexts = {
                param([string] $Text, [string] $Extension)
                foreach ($span in [Catzc.Base.QualityGates.CommentLexer]::Strings($Text, $Extension)) {
                    $Text.Substring($span.Item1, $span.Item2)
                }
            }
        }

        It 'returns C# regular, verbatim, interpolated, and raw literals, never a comment' -Tag 'ADR-REPO-LINK#6' {
            $source = @(
                'var a = "widget"; // "not data"'
                'var b = @"gad""get";'
                'var c = $"sp{x}";'
                'var d = """raw""";'
            ) -join "`n"
            @(& $stringTexts $source '.cs') | Should -Be @('"widget"', '@"gad""get"', '$"sp{x}"', '"""raw"""')
        }

        It 'returns a YAML line''s text before its comment, and a block scalar''s lines' -Tag 'ADR-REPO-LINK#6' {
            $source = (@('widget: one   # a comment', '# only a comment', 'gadget: |', '  line two', '') -join "`n")
            @(& $stringTexts $source '.yml') | Should -Be @('widget: one', 'gadget: |', 'line two')
        }

        It 'returns nothing for XML' -Tag 'ADR-REPO-LINK#6' {
            @(& $stringTexts '<Project Name="widget" />' '.csproj') | Should -HaveCount 0
        }
    }
}
