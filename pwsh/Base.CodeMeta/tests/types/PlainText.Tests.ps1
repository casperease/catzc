Describe 'PlainText.Synopsis' -Tag 'L0', 'logic' {
    It 'reads the help synopsis of a comment page, its wrapped lines joined by one space' {
        $page = "# widget.ps1`n`n## help`n`n### synopsis`n`nReturns the widget`nof a gadget.`n`n### description`n`nMore.`n"
        [Catzc.Base.CodeMeta.PlainText]::Synopsis($page) | Should -BeExactly 'Returns the widget of a gadget.'
    }

    It 'returns empty for a page with no help, or help with no synopsis' {
        [Catzc.Base.CodeMeta.PlainText]::Synopsis("# widget.ps1`n`n## comment:3`n`nA note.`n") | Should -BeExactly ''
        [Catzc.Base.CodeMeta.PlainText]::Synopsis("## help`n`n### description`n`nMore.`n") | Should -BeExactly ''
        [Catzc.Base.CodeMeta.PlainText]::Synopsis('') | Should -BeExactly ''
    }

    It 'stops at the next heading of either level' {
        $page = "## help`n`n### synopsis`n`nChecks the widget.`n## comment:1`n`nNot part of it.`n"
        [Catzc.Base.CodeMeta.PlainText]::Synopsis($page) | Should -BeExactly 'Checks the widget.'
    }
}

Describe 'PlainText.Plain' -Tag 'L0', 'logic' {
    It 'reduces <Case>' -ForEach @(
        @{ Case = 'a link to its words'; Text = 'Checks the [widget rules](../widget.md#rule) of a gadget.'; Expected = 'Checks the widget rules of a gadget.' }
        @{ Case = 'a rule code and the brackets it leaves'; Text = 'Checks the widget (ADR-WIDGET-GADGETRULE).'; Expected = 'Checks the widget.' }
        @{ Case = 'two codes in one bracket'; Text = 'Checks the widget (ADR-WIDGET-ONE, DDR-GADGET-TWO).'; Expected = 'Checks the widget.' }
        @{ Case = 'a code span and emphasis'; Text = 'Checks the `widget` of a **gadget**.'; Expected = 'Checks the widget of a gadget.' }
        @{ Case = 'runs of white space'; Text = "Checks  the`nwidget ."; Expected = 'Checks the widget.' }
        @{ Case = 'nothing before a dot that starts a word'; Text = 'Installs the .NET widget with the .frozen gadget.'; Expected = 'Installs the .NET widget with the .frozen gadget.' }
    ) {
        [Catzc.Base.CodeMeta.PlainText]::Plain($Text) | Should -BeExactly $Expected
    }
}

Describe 'PlainText.PlainScalarFinding' -Tag 'L0', 'logic' {
    It 'passes a plain sentence of letters, digits, spaces and . , - ( ) only' {
        [Catzc.Base.CodeMeta.PlainText]::PlainScalarFinding("Checks the widget's 2 gadget-parts (both), then stops.") | Should -BeNullOrEmpty
    }

    It 'names why <Case> is no plain description' -ForEach @(
        @{ Case = 'an empty text'; Text = ''; Expected = 'is empty' }
        @{ Case = 'a second line'; Text = "Checks the widget.`nAnd more."; Expected = 'spans more than one line' }
        @{ Case = 'a colon'; Text = 'Quality gate: checks the widget.'; Expected = 'holds a character*' }
        @{ Case = 'a slash'; Text = 'Checks the widget/gadget.'; Expected = 'holds a character*' }
        @{ Case = 'a hash'; Text = 'Checks the C# widget.'; Expected = 'holds a character*' }
        @{ Case = 'a leading indicator'; Text = '-Checks the widget.'; Expected = 'does not start with a letter or digit' }
        @{ Case = 'surrounding white space'; Text = ' Checks the widget.'; Expected = 'starts or ends with white space' }
    ) {
        [Catzc.Base.CodeMeta.PlainText]::PlainScalarFinding($Text) | Should -BeLike $Expected
    }
}
