[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-Footer' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll {
        $global:__PesterRunning = $false
        function script:StripAnsi {
            param([string]$Text)
            $Text -replace '\e\[[0-9;]*m', ''
        }
    }

    AfterAll { $global:__PesterRunning = $true }

    It 'Curved renders closing bottom line' {
        Write-Footer -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        StripAnsi $iv[0].MessageData | Should -Match '╰─{18}╯'
    }

    It 'Stars renders star line' {
        Write-Footer -Style Stars -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        StripAnsi $iv[0].MessageData | Should -Match '^\*{20}$'
    }

    It 'applies foreground color' {
        Write-Footer -ForegroundColor Cyan -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $iv[0].MessageData | Should -Match '\e\[96m'
    }

    It 'draws a rainbow closing rule as a per-character gradient' {
        $green = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor]::Green)
        Write-Footer -Width 20 -ForegroundColor $green -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $codes = [regex]::Matches($iv[0].MessageData, '\e\[(\d+)m') | ForEach-Object { $_.Groups[1].Value } |
            Where-Object { $_ -ne '0' } | Select-Object -Unique
        @($codes).Count | Should -BeGreaterThan 3
        StripAnsi $iv[0].MessageData | Should -Match '╰─{18}╯'
        $iv[0].MessageData | Should -Match '\e\[92m╰'
    }
}
