[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-Message' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll { $global:__PesterRunning = $false }
    AfterAll { $global:__PesterRunning = $true }

    It 'writes with caller header by default' {
        Write-Message 'hello' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $text = ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                    $_.MessageData
                }
                else {
                    $_.MessageData.Message
                } }) -join ''
        $text | Should -Match '\['
        $text | Should -Match 'hello'
    }

    It 'includes timestamp when CATZC_MESSAGE_TIMESTAMPS is set' {
        $env:CATZC_MESSAGE_TIMESTAMPS = '1'
        try {
            Write-Message 'hello' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                        $_.MessageData
                    }
                    else {
                        $_.MessageData.Message
                    } }) -join ''
            $text | Should -Match '\[\d{2}[.:]\d{2}[.:]\d{2}[.:]\d{3}'
        }
        finally {
            Remove-Item env:CATZC_MESSAGE_TIMESTAMPS
        }
    }

    It 'omits timestamp by default' {
        Write-Message 'hello' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $text = ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                    $_.MessageData
                }
                else {
                    $_.MessageData.Message
                } }) -join ''
        $text | Should -Not -Match '\d{2}[.:]\d{2}[.:]\d{2}[.:]\d{3}'
    }

    It 'omits header with -NoHeader' {
        Write-Message 'bare' -NoHeader -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $text = ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                    $_.MessageData
                }
                else {
                    $_.MessageData.Message
                } }) -join ''
        $text | Should -Not -Match '\['
        $text | Should -Match 'bare'
    }

    It 'routes -Verbose to the verbose stream (with header), not the information stream' {
        $verbose = Write-Message 'v-detail' -Verbose -InformationVariable iv -InformationAction SilentlyContinue 4>&1
        $verboseText = ($verbose | ForEach-Object { $_.Message }) -join ''
        $verboseText | Should -Match 'v-detail'
        $verboseText | Should -Match '\['
        $iv | Should -BeNullOrEmpty
    }

    It 'stays silent with -Verbose:$false (a suppressed verbose message)' {
        $verbose = Write-Message 'hidden' -Verbose:$false -InformationVariable iv -InformationAction SilentlyContinue 4>&1
        (($verbose | ForEach-Object { $_.Message }) -join '') | Should -Not -Match 'hidden'
        $iv | Should -BeNullOrEmpty
    }

    It '-Warning routes to the information stream (yellow ANSI), not the terminating warning stream' {
        # 3>&1 would surface any Write-Warning; capture it too and assert nothing lands there.
        $warn = Write-Message 'attention' -Warning -InformationVariable iv -InformationAction SilentlyContinue 3>&1
        $text = ($iv | ForEach-Object { [string]$_.MessageData }) -join ''
        $text | Should -Match 'attention'
        $text | Should -Match ([regex]::Escape("`e[93m"))   # yellow
        $warn | Should -BeNullOrEmpty                         # nothing on the warning stream
    }

    It '-Warn is an alias for -Warning' {
        Write-Message 'heads-up' -Warn -InformationVariable iv -InformationAction SilentlyContinue | Out-Null
        $text = ($iv | ForEach-Object { [string]$_.MessageData }) -join ''
        $text | Should -Match 'heads-up'
        $text | Should -Match ([regex]::Escape("`e[93m"))
    }

    It '-Warning and -ForegroundColor are mutually exclusive' {
        { Write-Message 'x' -Warning -ForegroundColor Green } | Should -Throw
    }

    Context '-ForegroundColor accepts rainbow input, side-grading to its base colour' {
        It 'a plain ConsoleColor name still renders that colour' {
            Write-Message 'plain' -ForegroundColor Green -NoHeader -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            (($iv | ForEach-Object { [string]$_.MessageData }) -join '') | Should -Match ([regex]::Escape("`e[92m"))
        }

        It 'a RainbowColor profile renders its base colour (a status line is solid, not a gradient)' {
            $green = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor]::Green)
            Write-Message 'solid' -ForegroundColor $green -NoHeader -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = ($iv | ForEach-Object { [string]$_.MessageData }) -join ''
            $text | Should -Match ([regex]::Escape("`e[92m"))   # green base
            @([regex]::Matches($text, '\e\[(9[0-9])m')).Count | Should -Be 1   # one colour, no gradient
        }

        It "a 'rainbow' bareword side-grades to the ring head, red" {
            Write-Message 'bare' -ForegroundColor rainbow -NoHeader -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            (($iv | ForEach-Object { [string]$_.MessageData }) -join '') | Should -Match ([regex]::Escape("`e[91m"))   # red
        }

        It "a '<base>-rainbow' bareword side-grades to that base" {
            Write-Message 'based' -ForegroundColor green-rainbow -NoHeader -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            (($iv | ForEach-Object { [string]$_.MessageData }) -join '') | Should -Match ([regex]::Escape("`e[92m"))   # green
        }
    }
}
