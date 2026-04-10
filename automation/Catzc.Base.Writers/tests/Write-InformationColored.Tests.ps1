[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-InformationColored' -Tag 'L0', 'logic' {
    # Write-InformationColored is a PRIVATE writer (the module's information-stream chokepoint), so it is
    # reached through InModuleScope rather than as an exported command.
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll { $global:__PesterRunning = $false }
    AfterAll { $global:__PesterRunning = $true }

    It 'writes message to the information stream' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored 'hello' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv | Should -HaveCount 1
            $iv[0].MessageData | Should -Match 'hello'
        }
    }

    It 'wraps text in ANSI escape codes when color specified' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored 'test' -ForegroundColor Red -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $text = $iv[0].MessageData
            $text | Should -Match '^\e\[91m'
            $text | Should -Match '\e\[0m$'
            $text | Should -Match 'test'
        }
    }

    It 'does not add ANSI codes when no color specified' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored 'plain' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv[0].MessageData | Should -Be 'plain'
        }
    }

    It 'maps Cyan to correct ANSI code' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored 'x' -ForegroundColor Cyan -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv[0].MessageData | Should -Match '^\e\[96m'
        }
    }
}
