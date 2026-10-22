[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-CallStack' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll { $global:__PesterRunning = $false }
    AfterAll { $global:__PesterRunning = $true }

    It 'outputs call stack information' {
        Write-CallStack -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $iv | Should -Not -BeNullOrEmpty
    }

    It 'includes line numbers in output' {
        Write-CallStack -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
        $text = ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                    $_.MessageData
                }
                else {
                    $_.MessageData.Message
                } }) -join "`n"
        $text | Should -Match ':\d+'
    }
}
