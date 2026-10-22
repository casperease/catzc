Describe 'Test-IsRunningInVsCode' -Tag 'L0', 'logic' {
    It 'detects a terminal VS Code opened via TERM_PROGRAM' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = 'vscode'
            Test-IsRunningInVsCode | Should -BeTrue
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }

    It 'returns false for another terminal program' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = 'WindowsTerminal'
            Test-IsRunningInVsCode | Should -BeFalse
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }

    It 'returns false when no terminal program is set' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = $null
            Test-IsRunningInVsCode | Should -BeFalse
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }
}
