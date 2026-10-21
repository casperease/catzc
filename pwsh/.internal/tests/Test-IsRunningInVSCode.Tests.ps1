<#
---
catzc:
  immutable:
    with_body_sha: cae882634b29
---
#>

Describe 'Test-IsRunningInVSCode' -Tag 'L0', 'logic' {
    It 'detects a terminal VS Code opened via TERM_PROGRAM' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = 'vscode'
            Test-IsRunningInVSCode | Should -BeTrue
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }

    It 'returns false for another terminal program' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = 'WindowsTerminal'
            Test-IsRunningInVSCode | Should -BeFalse
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }

    It 'returns false when no terminal program is set' {
        $original = $env:TERM_PROGRAM
        try {
            $env:TERM_PROGRAM = $null
            Test-IsRunningInVSCode | Should -BeFalse
        }
        finally {
            $env:TERM_PROGRAM = $original
        }
    }
}
