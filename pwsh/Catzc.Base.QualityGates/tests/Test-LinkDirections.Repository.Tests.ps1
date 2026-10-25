Describe 'Repository link directions (every tracked file)' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:gitMissing = -not (Get-Command git -ErrorAction Ignore)
        if (-not $script:gitMissing) {
            $script:result = Test-LinkDirections -PassThru -OutputFolder (Join-Path $TestDrive 'link-directions')
        }
    }

    It 'every relation in a tracked file points a way its first matching row allows' -Tag 'ADR-REPO-LINKS-DIRECTIONSAREROWS', 'ADR-REPO-LINKS-CHECKEDBYONEGATE' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result.Facts['EdgeCount'] | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'fix the link, correct its row with a because, or exempt the file with its reason'
        $result.IssueCount | Should -Be 0
    }
}
