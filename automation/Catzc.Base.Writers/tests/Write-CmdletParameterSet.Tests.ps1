[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-CmdletParameterSet' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll {
        $global:__PesterRunning = $false
        # Strip ANSI escape codes — non-interactive hosts embed them in Message
        function script:StripAnsi {
            param([string]$Text)
            $Text -replace '\e\[[0-9;]*m', ''
        }

        function Test-DummyFunc {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Params are used via $MyInvocation, not directly')]
            param([string]$Name, [string]$Secret, [switch]$Force)
            Write-CmdletParameterSet $MyInvocation -HiddenKeys 'Secret' -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
            $iv
        }
    }

    AfterAll { $global:__PesterRunning = $true }

    It 'outputs header with function name' {
        $iv = Test-DummyFunc -Name 'hello'
        StripAnsi $iv[0].MessageData | Should -Be '--- Test-DummyFunc Parameters ---'
    }

    It 'displays bound parameter values' {
        $iv = Test-DummyFunc -Name 'hello' -Force
        $messages = $iv | ForEach-Object { StripAnsi $_.MessageData }
        $messages | Should -Contain 'Force = True'
        $messages | Should -Contain 'Name = hello'
    }

    It 'masks hidden keys' {
        $iv = Test-DummyFunc -Name 'hello' -Secret 'password'
        $messages = $iv | ForEach-Object { StripAnsi $_.MessageData }
        $messages | Should -Contain 'Secret = Hidden'
        $messages | Should -Not -Contain 'Secret = password'
    }

    It 'only shows bound parameters' {
        $iv = Test-DummyFunc -Name 'hello'
        $messages = ($iv | ForEach-Object { StripAnsi $_.MessageData }) -join "`n"
        $messages | Should -Not -Match 'Secret'
        $messages | Should -Not -Match 'Force'
    }
}
