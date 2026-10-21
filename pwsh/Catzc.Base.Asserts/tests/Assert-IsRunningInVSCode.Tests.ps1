<#
---
catzc:
  immutable:
    with_body_sha: "4751f096d69b"
  edges:
    code: pwsh/Catzc.Base.Asserts/Assert-IsRunningInVSCode.ps1
---
#>

Describe 'Assert-IsRunningInVSCode' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:originalTerminalProgram = $env:TERM_PROGRAM
    }

    AfterEach {
        $env:TERM_PROGRAM = $script:originalTerminalProgram
    }

    It 'passes in a terminal VS Code opened' {
        $env:TERM_PROGRAM = 'vscode'
        { Assert-IsRunningInVSCode } | Should -Not -Throw
    }

    It 'throws outside VS Code with the default message' {
        $env:TERM_PROGRAM = $null
        { Assert-IsRunningInVSCode } | Should -Throw -ExpectedMessage '*requires a terminal inside VS Code*'
    }

    It 'uses custom error text when provided' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        { Assert-IsRunningInVSCode -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
