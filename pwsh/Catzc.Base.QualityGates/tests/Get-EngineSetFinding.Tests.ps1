Describe 'Get-EngineSetFinding' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:check = [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{
                count_phrases = @('\b{count} engines\b')
                name_phrases  = @('\b{name}(?:(?:,? and |,? or |, |/){name})+\b', '\[{name}\]')
            })
        $script:find = {
            param([string] $Path, [string] $Text)
            $ast = $null
            if ($Path -match '\.ps1$') {
                $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$null, [ref]$null)
            }
            & (Get-Module Catzc.Base.QualityGates) {
                Get-EngineSetFinding -Path $args[0] -Text $args[1] -Ast $args[2] -EngineName 'widget', 'gadget', 'sprocket' -Check $args[3]
            } $Path $Text $ast $script:check
        }
    }

    Context 'prose' {
        It 'flags a phrase that names some engines but not all of them, with its line' -Tag 'ADR-AUTO-ENGINE#1' {
            $found = @(& $find 'docs/notes.md' "# Notes`n`nIt runs under widget and gadget.`n")
            $found | Should -HaveCount 1
            $found[0] | Should -BeLike "docs/notes.md:3: 'widget and gadget' names 2 of the 3 engines*"
        }

        It 'passes a phrase that names every engine' -Tag 'ADR-AUTO-ENGINE#1' {
            @(& $find 'docs/notes.md' "It runs under widget, gadget and sprocket.`n") | Should -HaveCount 0
        }

        It 'flags a count that is not the model''s, and passes the model''s count' -Tag 'ADR-AUTO-ENGINE#1' {
            $found = @(& $find 'docs/notes.md' "Both engines agree.`nThe three engines agree.`nThe two engines differ.`n")
            $found | Should -HaveCount 2
            $found[0] | Should -BeLike "docs/notes.md:1: 'Both engines' restates the engine count*"
            $found[1] | Should -BeLike 'docs/notes.md:3:*'
        }

        It 'flags bracketed engine names on one line that leave one out' -Tag 'ADR-AUTO-ENGINE#1' {
            @(& $find 'docs/notes.md' "Titled <test> [widget] and <test> [gadget].`n") | Should -HaveCount 1
            @(& $find 'docs/notes.md' "Titled [widget], [gadget] and [sprocket].`n") | Should -HaveCount 0
        }

        It 'reads a code file''s comments as prose, never its code' -Tag 'ADR-AUTO-ENGINE#1' {
            $found = @(& $find 'src/Get-Widget.ps1' "# Runs under widget or gadget.`n`$label = 'widget or gadget'`n")
            $found | Should -HaveCount 1
            $found[0] | Should -BeLike 'src/Get-Widget.ps1:1:*'
        }
    }

    Context 'PowerShell code' {
        It 'flags a ValidateSet, an array literal, and a switch with no default that list engines' -Tag 'ADR-AUTO-ENGINE#1' {
            $text = @(
                'function Get-Widget {'
                '    param([ValidateSet(''widget'', ''gadget'')] [string] $Engine)'
                '    $all = ''widget'', ''gadget'', ''sprocket'''
                '    switch ($Engine) { ''widget'' { 1 } ''gadget'' { 2 } }'
                '}'
            ) -join "`n"
            $found = @(& $find 'src/Get-Widget.ps1' $text)
            $found | Should -HaveCount 3
            $found[0] | Should -BeLike 'src/Get-Widget.ps1:2: a ValidateSet lists engine names (widget, gadget)*'
            $found[1] | Should -BeLike 'src/Get-Widget.ps1:3: an array literal lists engine names*'
            $found[2] | Should -BeLike 'src/Get-Widget.ps1:4: a switch with no default*'
        }

        It 'passes one engine name, a switch with a default, and a list of other values' -Tag 'ADR-AUTO-ENGINE#1' {
            $text = @(
                '$one = @(''widget'')'
                'switch ($x) { ''widget'' { 1 } ''gadget'' { 2 } default { 3 } }'
                '$other = ''go'', ''python'', ''widget'''
            ) -join "`n"
            @(& $find 'src/Get-Gadget.ps1' $text) | Should -HaveCount 0
        }
    }

    Context 'C# code' {
        It 'flags two engine names as string literals on one line' -Tag 'ADR-AUTO-ENGINE#1' {
            $text = (@('namespace Widget;', 'class A { static readonly string[] Names = { "widget", "gadget" }; }', '') -join "`n")
            $found = @(& $find 'src/A.cs' $text)
            $found | Should -HaveCount 1
            $found[0] | Should -BeLike 'src/A.cs:2: a literal list of engine names (widget, gadget)*'
        }
    }
}
