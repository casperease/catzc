[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-TestAutomationHeader' -Tag 'L0', 'logic' {
    # The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
    # information-stream output can be asserted (see console-output-matters).
    BeforeAll {
        $global:__PesterRunning = $false

        function Get-HeaderText {
            param($MinLevel = 0, $MaxLevel = 2, $Category = 'Both', $Modules = @())
            $text = InModuleScope Catzc.Base.QualityGates -Parameters @{ Min = $MinLevel; Max = $MaxLevel; Cat = $Category; Mod = $Modules } {
                param($Min, $Max, $Cat, $Mod)
                Write-TestAutomationHeader -MinLevel $Min -MaxLevel $Max -Category $Cat -Modules $Mod `
                    -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
                ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                        $_.MessageData
                    }
                    else {
                        $_.MessageData.Message
                    } }) -join "`n"
            }
            # Strip ANSI so assertions match on text, not color codes.
            $text -replace "`e\[[0-9;]*m", ''
        }
    }
    AfterAll { $global:__PesterRunning = $true }

    It 'names the tier range and the Test Automation title' {
        $text = Get-HeaderText -MinLevel 0 -MaxLevel 2
        $text | Should -Match 'Test Automation'
        $text | Should -Match 'L0-L2'
    }

    It 'collapses an equal min/max to a single tier' {
        $text = Get-HeaderText -MinLevel 2 -MaxLevel 2
        $text | Should -Match 'L2'
        $text | Should -Not -Match 'L2-'
    }

    It 'names the category only when narrowed from Both' {
        Get-HeaderText -Category 'Integrity' | Should -Match 'Integrity'
        Get-HeaderText -Category 'Both' | Should -Not -Match 'Both'
    }

    It 'names the modules when scoped' {
        Get-HeaderText -Modules @('Catzc.Base.Objects') | Should -Match 'modules: Catzc\.Base\.Objects'
    }
}
