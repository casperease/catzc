# The <base>-rainbow colour profile (ADR-CONSOLE:7): char 0 is the anchor, the walk steps a chromatic-only
# ring (legible on a dark ground), and the profile side-grades to its base ConsoleColor.
Describe 'RainbowColor' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:green = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor]::Green)
        $script:black = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor]::Black)
    }

    It 'char 0 is the anchor colour' {
        $script:green.ColorAt(0) | Should -Be ([System.ConsoleColor]::Green)
        $script:black.ColorAt(0) | Should -Be ([System.ConsoleColor]::Black)
    }

    It 'a chromatic anchor continues along the ring from its own position' {
        # Ring: Red DarkYellow Yellow Green Cyan Blue Magenta — Green is index 3.
        $script:green.ColorAt(1) | Should -Be ([System.ConsoleColor]::Cyan)
        $script:green.ColorAt(2) | Should -Be ([System.ConsoleColor]::Blue)
        $script:green.ColorAt(3) | Should -Be ([System.ConsoleColor]::Magenta)
        $script:green.ColorAt(4) | Should -Be ([System.ConsoleColor]::Red)
    }

    It 'a non-chromatic anchor walks from the ring head' {
        $script:black.ColorAt(1) | Should -Be ([System.ConsoleColor]::Red)
        $script:black.ColorAt(2) | Should -Be ([System.ConsoleColor]::DarkYellow)
    }

    It 'the walk never lands on a neutral or dark colour (legible on a dark ground)' {
        $dark = [System.ConsoleColor]::Black, [System.ConsoleColor]::DarkGray, [System.ConsoleColor]::Gray,
        [System.ConsoleColor]::White, [System.ConsoleColor]::DarkBlue, [System.ConsoleColor]::DarkGreen
        foreach ($i in 1..21) {
            $script:green.ColorAt($i) | Should -Not -BeIn $dark
        }
    }

    It 'side-grades to its base ConsoleColor (the single-colour cast)' {
        [System.ConsoleColor]$script:green | Should -Be ([System.ConsoleColor]::Green)
        [System.ConsoleColor]$script:black | Should -Be ([System.ConsoleColor]::Black)
    }

    It 'Wrap colours each character and resets once at the end' {
        # 'a' at the anchor (green), 'b' the next ring step (cyan), one trailing reset.
        $script:green.Wrap('ab') | Should -BeExactly "`e[92ma`e[96mb`e[0m"
    }

    It 'an empty string wraps to empty' {
        $script:green.Wrap('') | Should -BeExactly ''
    }

    It 'names itself with the base-colour prefix' {
        $script:green.ToString() | Should -BeExactly 'green-rainbow'
    }
}
