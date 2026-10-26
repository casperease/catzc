Describe 'Get-StringOverflowLine' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:lines = {
            param([string] $Text, [string] $Language, [int] $Width = 40)
            InModuleScope Catzc.Base.FileLimits -Parameters @{ T = $Text; L = $Language; W = $Width } {
                param($T, $L, $W)
                Get-StringOverflowLine -Text $T -Width $W -Language $L
            }
        }
    }

    It 'exempts a PowerShell line whose overflow lies wholly inside one string literal' {
        $text = "`$widget = 'a gadget message that runs far past the width of the line'"
        @(& $script:lines $text 'powershell') | Should -Be @(1)
    }

    It 'does not exempt a line whose overflow runs on past the end of its string' {
        $text = "`$widget = 'a gadget message past the width' + `$sprocketsAndCogsAndGears"
        @(& $script:lines $text 'powershell') | Should -BeNullOrEmpty
    }

    It 'does not exempt a line whose overflow spans two strings' {
        $text = "Write-Widget 'a gadget message that runs' 'and a second string past the width'"
        @(& $script:lines $text 'powershell') | Should -BeNullOrEmpty
    }

    It 'exempts a YAML scalar that runs past the width, and not one followed by more text' {
        $text = "widget:`n  pattern: '^(gadget|sprocket|cog|gear)-[0-9]+-widget$'`n  other: short # a comment that runs past the width"
        @(& $script:lines $text 'yaml') | Should -Be @(2)
    }

    It 'exempts an XML attribute value that runs past the width to the end of its line, and not one the tag continues after' {
        $text = "<widget>`n  <gadget style=`"shape=sprocket;fill=#123456;stroke=#654321;rounded=1`"`n    />`n</widget>"
        @(& $script:lines $text 'xml') | Should -Be @(2)
        $closed = "<widget>`n  <gadget style=`"shape=sprocket;fill=#123456;stroke=#654321;rounded=1`" />`n</widget>"
        @(& $script:lines $closed 'xml') | Should -BeNullOrEmpty
    }

    It 'exempts a JSON string that runs past the width, not a line that runs on past its string, and not two strings' {
        $text = "{`n  `"`$comment`": `"a widget schema comment that runs far past the width`"`n}"
        @(& $script:lines $text 'json') | Should -Be @(2)
        $after = "{`n  `"widget`": `"a gadget value past the width of the line`", `"cog`": 1`n}"
        @(& $script:lines $after 'json') | Should -BeNullOrEmpty
        $two = "[`"a gadget string that runs`", `"and a second string past the width`"]"
        @(& $script:lines $two 'json') | Should -BeNullOrEmpty
    }

    It 'exempts a JSON string followed by only its comma, not one followed by another member' {
        $comma = "{`n  `"`$comment`": `"a widget schema comment that runs far past the width`",`n  `"cog`": 1`n}"
        @(& $script:lines $comma 'json') | Should -Be @(2)
        $more = "{`n  `"widget`": `"a gadget value past the width of the line`", `"x`": 1`n}"
        @(& $script:lines $more 'json') | Should -BeNullOrEmpty
    }

    It 'reads an escaped quote inside a JSON string, and a // comment outside one, as JSONC settings write them' {
        $escaped = "{ `"widget`": `"a \`"quoted\`" gadget that runs far past the width of a line`" }"
        @(& $script:lines $escaped 'json' -Width 60) | Should -BeNullOrEmpty
        $string = "  `"widget`": `"a \`"quoted\`" gadget value that runs far past the width`""
        @(& $script:lines $string 'json') | Should -Be @(1)
        $comment = "  `"cog`": 1, // a long `"comment`" with quotes that runs well past the width of the line"
        @(& $script:lines $comment 'json') | Should -BeNullOrEmpty
    }

    It 'exempts nothing in a language with no tokenizer, or in text the tokenizer cannot read' {
        @(& $script:lines ('x' * 80) 'markdown') | Should -BeNullOrEmpty
        @(& $script:lines "<widget><unclosed style=`"$('a' * 80)`"></widget>" 'xml') | Should -BeNullOrEmpty
    }
}
