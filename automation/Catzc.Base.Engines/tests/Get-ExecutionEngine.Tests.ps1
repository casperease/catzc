Describe 'Get-ExecutionEngine' -Tag 'L0', 'logic' {
    It 'returns both engines, pwsh first, when no name is given' {
        @(Get-ExecutionEngine).Name | Should -Be @('pwsh', 'bash')
    }

    It 'returns the engine of that name' {
        (Get-ExecutionEngine -Name bash).ImporterEntry | Should -Be 'importer.sh'
    }

    It 'throws, naming the engines, for an unknown name' {
        { Get-ExecutionEngine -Name zsh } | Should -Throw '*one of: pwsh, bash*'
    }
}
