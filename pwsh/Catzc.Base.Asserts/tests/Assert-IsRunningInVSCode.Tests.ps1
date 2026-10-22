Describe 'Assert-IsRunningInVsCode' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:originalTerminalProgram = $env:TERM_PROGRAM
    }

    AfterEach {
        $env:TERM_PROGRAM = $script:originalTerminalProgram
    }

    It 'passes in a terminal VS Code opened' {
        $env:TERM_PROGRAM = 'vscode'
        { Assert-IsRunningInVsCode } | Should -Not -Throw
    }

    It 'throws outside VS Code with the default message' {
        $env:TERM_PROGRAM = $null
        { Assert-IsRunningInVsCode } | Should -Throw -ExpectedMessage '*requires a terminal inside VS Code*'
    }

    It 'uses custom error text when provided' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        { Assert-IsRunningInVsCode -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
