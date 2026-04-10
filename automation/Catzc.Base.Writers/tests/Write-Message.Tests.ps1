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
}
