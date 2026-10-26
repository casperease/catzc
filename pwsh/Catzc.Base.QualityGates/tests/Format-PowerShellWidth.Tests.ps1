Describe 'Format-PowerShellWidth' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:wrap = {
            param([string] $Text, [int] $Width = 60)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Text; W = $Width } { param($T, $W) Format-PowerShellWidth -Text $T -Width $W }
        }
        $script:tokens = {
            param([string] $Text)
            $found = $null
            $null = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref] $found, [ref] $null)
            @($found | Where-Object { $_.Kind -notin 'NewLine', 'LineContinuation', 'EndOfInput', 'Comment' } | ForEach-Object { "$($_.Kind)|$($_.Text)" }) -join "`n"
        }
    }

    It 'breaks a long pipeline after a pipe, a continued line keeping its indent, and changes no token' {
        $source = 'Get-Widget -Name $gadget | Where-Object { $_.Size -gt 0 } | Sort-Object -Unique | Select-Object -First 1'
        $result = & $script:wrap $source
        $result.Changed | Should -BeTrue
        $lines = $result.Text -split "`n"
        @($lines | Where-Object { $_.Length -gt 60 }) | Should -BeNullOrEmpty
        $lines.Count | Should -BeGreaterThan 1
        $lines | Select-Object -Skip 1 | ForEach-Object { $_ | Should -Match '^    \S' }
        & $script:tokens $result.Text | Should -BeExactly (& $script:tokens $source)
    }

    It 'breaks inside parentheses after a comma, never at statement level' {
        $source = '$widget = [System.IO.Path]::Combine($gadgetRoot, ''sprocket'', ''cog'', ''gear'')'
        $result = & $script:wrap $source
        $result.Changed | Should -BeTrue
        ($result.Text -split "`n")[0] | Should -Match ',$'
        & $script:tokens $result.Text | Should -BeExactly (& $script:tokens $source)
    }

    It 'reflows a whole-line comment into a second comment line with the same words' {
        $source = '    # A widget comment that runs past the width of the line so that it wraps once'
        $result = & $script:wrap $source
        $result.Changed | Should -BeTrue
        $lines = $result.Text -split "`n"
        $lines | ForEach-Object { $_ | Should -Match '^    # ' }
        (($lines -replace '^\s*#\s*', '') -join ' ') | Should -BeExactly 'A widget comment that runs past the width of the line so that it wraps once'
    }

    It 'leaves a line with no safe break, a short line, and a file that does not parse as they are' {
        $string = '$widget = ''a single string literal that is far too long for the width and cannot be split'''
        (& $script:wrap $string).Changed | Should -BeFalse
        (& $script:wrap '$short = 1').Changed | Should -BeFalse
        $broken = 'Get-Widget -Name ( | Sort-Object -Unique | Select-Object -First 1 | Where-Object { $_ }'
        $result = & $script:wrap $broken
        $result.Changed | Should -BeFalse
        $result.Refused | Should -BeExactly 'the file does not parse'
    }

    It 'keeps the CRLF line ending of a CRLF source' {
        $source = "`$a = 1`r`nGet-Widget -Name `$gadget | Where-Object { `$_.Size -gt 0 } | Sort-Object -Unique | Select-Object -First 1`r`n"
        $result = & $script:wrap $source
        $result.Changed | Should -BeTrue
        $result.Text | Should -Not -Match "[^`r]`n"
    }
}
