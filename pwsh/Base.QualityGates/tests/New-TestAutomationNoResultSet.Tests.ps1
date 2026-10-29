Describe 'New-TestAutomationNoResultSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:resultsPath = Join-Path $TestDrive 'results-shard-1.xml'
        [System.IO.File]::WriteAllText($script:resultsPath,
            '<test-results name="Widget" total="6" errors="0" failures="2" not-run="1" />')
        $script:logPath = Join-Path $TestDrive 'worker-shard-1.log'
    }

    It 'records one failed row and one failed file per test path, with the results counts and the printed error' {
        $set = InModuleScope Catzc.Base.QualityGates -Parameters @{ Results = $script:resultsPath; Log = $script:logPath } {
            param($Results, $Log)
            New-TestAutomationNoResultSet -TestPath 'C:\repo\widget.Tests.ps1', 'C:\repo\gadget' -ResultsPath $Results `
                -LogPath $Log -PesterError "$([char] 27)[91mRuntimeException: gadget step failed$([char] 27)[0m"
        }
        $set.Rows | Should -HaveCount 2
        $set.Files | Should -HaveCount 2
        ($set.Rows | ForEach-Object Result) | Should -Be @('Failed', 'Failed')
        ($set.Files | ForEach-Object Result) | Should -Be @('Failed', 'Failed')
        $set.Rows[0].File | Should -Be 'C:\repo\widget.Tests.ps1'
        $set.Files[1].File | Should -Be 'C:\repo\gadget'
        $set.Files[0].DurationMs | Should -Be 0
        $message = $set.Files[0].ErrorMessage
        $message | Should -Match 'Invoke-Pester returned no result'
        $message | Should -Match 'total 6, failures 2, errors 0, not-run 1'
        $message | Should -Match ([regex]::Escape($script:logPath))
        $message | Should -Match 'RuntimeException: gadget step failed'
        $message | Should -Not -Match ([regex]::Escape([string] [char] 27))
        $set.Rows[0].ErrorMessage | Should -Be $message
    }

    It 'says so when the results file is absent or unreadable, and carries no printed error when none came' {
        $broken = Join-Path $TestDrive 'broken.xml'
        [System.IO.File]::WriteAllText($broken, '<test-results')
        $sets = InModuleScope Catzc.Base.QualityGates -Parameters @{ Broken = $broken; Log = $script:logPath } {
            param($Broken, $Log)
            New-TestAutomationNoResultSet -TestPath 'C:\repo\widget.Tests.ps1' -ResultsPath 'C:\absent\results.xml' -LogPath $Log
            New-TestAutomationNoResultSet -TestPath 'C:\repo\widget.Tests.ps1' -ResultsPath $Broken -LogPath $Log -PesterError ''
        }
        $sets[0].Files[0].ErrorMessage | Should -Match 'no results file'
        $sets[0].Files[0].ErrorMessage | Should -Not -Match "`n"
        $sets[1].Files[0].ErrorMessage | Should -Match 'results file unreadable'
    }
}
