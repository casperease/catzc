Describe 'Get-MarkdownTitleFinding' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeAll {
        # Fixture text is built from lines, so every escape stays apart from the words around it.
        function script:Join-Lines {
            param([string[]] $Lines, [string] $Newline = "`n")
            $Lines -join $Newline
        }

        function script:Get-Finding {
            param([string] $Text)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text } {
                param($Text)
                Get-MarkdownTitleFinding -RelativePath 'docs/widget.md' -Text $Text
            }
        }
    }

    It 'accepts a file already titled with its path' {
        $text = Join-Lines '# docs/widget.md', '', 'Body.', ''
        $finding = Get-Finding $text
        $finding.Kind | Should -Be 'Ok'
        $finding.Fixed | Should -Be $text
    }

    It 'replaces an H1 with other text and keeps the old title fenced as the first body block' {
        $finding = Get-Finding (Join-Lines '# widget', '', 'Body.', '')
        $finding.Kind | Should -Be 'Wrong'
        $finding.Actual | Should -Be '# widget'
        $finding.Line | Should -Be 1
        $finding.Fixed | Should -Be (Join-Lines '# docs/widget.md', '', '```text', 'widget', '```', '', 'Body.', '')
    }

    It 'fences an old title that holds backticks of its own' {
        (Get-Finding (Join-Lines '# Widget (`gadget.yml`)', '')).Fixed | Should -Be (Join-Lines '# docs/widget.md', '', '```text', 'Widget (`gadget.yml`)', '```', '')
    }

    It 'pads the kept old title from a body line that followed the heading directly' {
        (Get-Finding (Join-Lines '# widget', 'Body.', '')).Fixed | Should -Be (Join-Lines '# docs/widget.md', '', '```text', 'widget', '```', '', 'Body.', '')
    }

    It 'keeps an old title that ends the file' {
        (Get-Finding (Join-Lines '# widget', '')).Fixed | Should -Be (Join-Lines '# docs/widget.md', '', '```text', 'widget', '```', '')
    }

    It 'is case-sensitive about the path' {
        (Get-Finding (Join-Lines '# Docs/Widget.md', '')).Kind | Should -Be 'Wrong'
    }

    It 'inserts the title when the file opens without an H1' {
        $finding = Get-Finding (Join-Lines 'Body.', '')
        $finding.Kind | Should -Be 'Missing'
        $finding.Fixed | Should -Be (Join-Lines '# docs/widget.md', '', 'Body.', '')
    }

    It 'treats a second-level heading as no title' {
        (Get-Finding (Join-Lines '## widget', '')).Fixed | Should -Be (Join-Lines '# docs/widget.md', '', '## widget', '')
    }

    It 'titles after YAML front matter and leaves the front matter alone' {
        $finding = Get-Finding (Join-Lines '---', 'name: widget', '---', '', '# widget', '', 'Body.', '')
        $finding.Kind | Should -Be 'Wrong'
        $finding.Line | Should -Be 5
        $finding.Fixed | Should -Be (Join-Lines '---', 'name: widget', '---', '', '# docs/widget.md', '', '```text', 'widget', '```', '', 'Body.', '')
    }

    It 'never reads a # line in a later code fence as the title' {
        $text = Join-Lines '# docs/widget.md', '', '```powershell', '# gadget comment', '```', ''
        (Get-Finding $text).Kind | Should -Be 'Ok'
    }

    It 'keeps CRLF line endings' {
        $fixed = (Get-Finding (Join-Lines '# widget', '', 'Body.', '' -Newline "`r`n")).Fixed
        $fixed | Should -Be (Join-Lines '# docs/widget.md', '', '```text', 'widget', '```', '', 'Body.', '' -Newline "`r`n")
    }

    It 'titles an empty file' {
        (Get-Finding '').Fixed | Should -Be (Join-Lines '# docs/widget.md', '')
    }
}
