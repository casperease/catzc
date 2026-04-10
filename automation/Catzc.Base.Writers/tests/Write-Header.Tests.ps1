[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-Header' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll {
        $global:__PesterRunning = $false
        function script:StripAnsi {
            param([string]$Text)
            $Text -replace '\e\[[0-9;]*m', ''
        }
    }

    AfterAll { $global:__PesterRunning = $true }

    Context 'Curved (default)' {
        It 'renders box with message' {
            Write-Header 'test' -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { StripAnsi $_.MessageData }) -join "`n"
            $text | Should -Match '╭──'
            $text | Should -Match '│ test'
            $text | Should -Match '╰──'
        }

        It 'renders single top line without message' {
            Write-Header -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { StripAnsi $_.MessageData }) -join "`n"
            $text | Should -Match '╭──'
            $text | Should -Not -Match '│'
        }
    }

    Context 'Stars' {
        It 'renders stars with message' {
            Write-Header 'test' -Style Stars -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { StripAnsi $_.MessageData }) -join "`n"
            $text | Should -Match '^\*{20}'
            $text | Should -Match '\* test'
        }

        It 'renders single star line without message' {
            Write-Header -Style Stars -Width 20 -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { StripAnsi $_.MessageData }) -join "`n"
            $text | Should -Match '^\*{20}$'
        }
    }

    It 'applies foreground color' {
        Write-Header 'colored' -ForegroundColor Cyan -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $raw = $iv | ForEach-Object { $_.MessageData } | Out-String
        $raw | Should -Match '\e\[96m'
    }
}
