<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/tests/Test-IsRunningAsAgent.Tests.ps1
    folder: tests
    name: test-is-running-as-agent-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-IsRunningAsAgent' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:originalClaudeCode = $env:CLAUDECODE
        $script:originalAiAgent = $env:AI_AGENT
        $env:CLAUDECODE = $null
        $env:AI_AGENT = $null
    }

    AfterEach {
        $env:CLAUDECODE = $script:originalClaudeCode
        $env:AI_AGENT = $script:originalAiAgent
    }

    It 'detects Claude Code via CLAUDECODE' {
        $env:CLAUDECODE = '1'
        Test-IsRunningAsAgent | Should -BeTrue
    }

    It 'detects an agent harness via AI_AGENT' {
        $env:AI_AGENT = 'widget-agent'
        Test-IsRunningAsAgent | Should -BeTrue
    }

    It 'returns false in a person''s session, with no agent variables set' {
        Test-IsRunningAsAgent | Should -BeFalse
    }
}
