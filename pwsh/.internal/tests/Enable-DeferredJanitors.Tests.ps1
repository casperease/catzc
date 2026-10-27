Describe 'Enable-DeferredJanitors' -Tag 'L0', 'logic', 'ADR-PWSH-TYPES-CONSOLEVERIFIESONLY' {
    BeforeEach {
        $script:savedPrompt = (Get-Command prompt -CommandType Function -ErrorAction Ignore).ScriptBlock
        Set-Item -Path function:global:prompt -Value { 'widget> ' }
        $script:runs = 0
    }

    AfterEach {
        if ($script:savedPrompt) {
            Set-Item -Path function:global:prompt -Value $script:savedPrompt
        }
        else {
            Remove-Item -Path function:global:prompt -ErrorAction Ignore
        }
    }

    It 'renders the existing prompt unchanged first, runs the action once before the second render, then removes itself' {
        Enable-DeferredJanitors -Action { $script:runs++ }

        prompt | Should -Be 'widget> '
        $script:runs | Should -Be 0

        prompt | Should -Be 'widget> '
        $script:runs | Should -Be 1

        prompt | Should -Be 'widget> '
        $script:runs | Should -Be 1
        (Get-Command prompt -CommandType Function).ScriptBlock.ToString().Trim() | Should -Be "'widget> '"
    }

    It 'restores the prompt before the action runs, so a failing action leaves a working prompt' {
        Enable-DeferredJanitors -Action { throw 'gadget failed' }

        prompt | Should -Be 'widget> '
        { prompt } | Should -Throw -ExpectedMessage 'gadget failed'
        (Get-Command prompt -CommandType Function).ScriptBlock.ToString().Trim() | Should -Be "'widget> '"
        prompt | Should -Be 'widget> '
    }

    It 'installs the janitor action when none is given' {
        Enable-DeferredJanitors
        (Get-Command prompt -CommandType Function).ScriptBlock.ToString() |
            Should -BeLike '*Invoke-DeferredJanitorsPrompt*'
        $state = InModuleScope Catzc.Internal.Loader { $script:deferredJanitors }
        $state.Action.ToString() | Should -BeLike '*Invoke-ImporterJanitors*'
        InModuleScope Catzc.Internal.Loader { $script:deferredJanitors = $null }
    }
}
