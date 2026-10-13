Describe 'Get-MarkdownTitleFinding' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeAll {
        function script:Get-Finding([string] $Text) {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text } {
                param($Text)
                Get-MarkdownTitleFinding -RelativePath 'docs/widget.md' -Text $Text
            }
        }
    }

    It 'accepts a file already titled with its path' {
        $finding = Get-Finding "# docs/widget.md`n`nBody.`n"
        $finding.Kind | Should -Be 'Ok'
        $finding.Fixed | Should -Be "# docs/widget.md`n`nBody.`n"
    }

    It 'replaces an H1 with other text' {
        $finding = Get-Finding "# widget`n`nBody.`n"
        $finding.Kind | Should -Be 'Wrong'
        $finding.Actual | Should -Be '# widget'
        $finding.Line | Should -Be 1
        $finding.Fixed | Should -Be "# docs/widget.md`n`nBody.`n"
    }

    It 'is case-sensitive about the path' {
        (Get-Finding "# Docs/Widget.md`n").Kind | Should -Be 'Wrong'
    }

    It 'inserts the title when the file opens without an H1' {
        $finding = Get-Finding "Body.`n"
        $finding.Kind | Should -Be 'Missing'
        $finding.Fixed | Should -Be "# docs/widget.md`n`nBody.`n"
    }

    It 'treats a second-level heading as no title' {
        (Get-Finding "## widget`n").Fixed | Should -Be "# docs/widget.md`n`n## widget`n"
    }

    It 'titles after YAML front matter and leaves the front matter alone' {
        $finding = Get-Finding "---`nname: widget`n---`n`n# widget`n`nBody.`n"
        $finding.Kind | Should -Be 'Wrong'
        $finding.Line | Should -Be 5
        $finding.Fixed | Should -Be "---`nname: widget`n---`n`n# docs/widget.md`n`nBody.`n"
    }

    It 'never reads a # line in a later code fence as the title' {
        $text = "# docs/widget.md`n`n``````powershell`n# gadget comment`n```````n"
        (Get-Finding $text).Kind | Should -Be 'Ok'
    }

    It 'keeps CRLF line endings' {
        (Get-Finding "# widget`r`n`r`nBody.`r`n").Fixed | Should -Be "# docs/widget.md`r`n`r`nBody.`r`n"
    }

    It 'titles an empty file' {
        (Get-Finding '').Fixed | Should -Be "# docs/widget.md`n"
    }
}
