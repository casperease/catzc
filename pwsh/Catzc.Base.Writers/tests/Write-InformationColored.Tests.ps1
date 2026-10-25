<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-writers/tests/Write-InformationColored.Tests.ps1.md"
  warning: "Generated Header"
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-InformationColored' -Tag 'L0', 'logic' {
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

    It 'writes an inline record the host renders without a line break under -NoNewline' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored '.' -NoNewline -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv | Should -HaveCount 1
            $iv[0].MessageData | Should -BeOfType [System.Management.Automation.HostInformationMessage]
            $iv[0].MessageData.Message | Should -Be '.'
            $iv[0].MessageData.NoNewLine | Should -BeTrue
        }
    }

    It 'keeps the colour inside the inline record under -NoNewline' {
        InModuleScope Catzc.Base.Writers {
            Write-InformationColored '.' -NoNewline -ForegroundColor Red -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv[0].MessageData.Message | Should -Match '^\e\[91m\.'
        }
    }

    It 'never emits an inline record into the pipeline' {
        InModuleScope Catzc.Base.Writers {
            $piped = Write-InformationColored '.' -NoNewline -InformationAction SilentlyContinue
            $piped | Should -BeNullOrEmpty
        }
    }
}
