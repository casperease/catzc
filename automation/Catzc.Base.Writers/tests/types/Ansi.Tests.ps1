# The single ConsoleColor -> ANSI SGR map (ADR-AUTO-CONSOLE:7): the escape codes Write-InformationColored and
# RainbowColor both resolve through, asserted in one place so the two can never disagree.
Describe 'Ansi' -Tag 'L0', 'logic' {
    It 'maps <color> to its SGR foreground escape' -ForEach @(
        @{ color = 'Red'; code = "`e[91m" }
        @{ color = 'Green'; code = "`e[92m" }
        @{ color = 'Cyan'; code = "`e[96m" }
        @{ color = 'Yellow'; code = "`e[93m" }
        @{ color = 'Black'; code = "`e[30m" }
        @{ color = 'DarkYellow'; code = "`e[33m" }
        @{ color = 'DarkGray'; code = "`e[90m" }
        @{ color = 'White'; code = "`e[97m" }
    ) {
        [Catzc.Base.Writers.Ansi]::Code([System.ConsoleColor]$color) | Should -BeExactly $code
    }

    It 'Reset is the SGR reset sequence' {
        [Catzc.Base.Writers.Ansi]::Reset | Should -BeExactly "`e[0m"
    }

    It 'Wrap brackets text in the colour and a reset' {
        [Catzc.Base.Writers.Ansi]::Wrap('hi', [System.ConsoleColor]::Green) | Should -BeExactly "`e[92mhi`e[0m"
    }
}
