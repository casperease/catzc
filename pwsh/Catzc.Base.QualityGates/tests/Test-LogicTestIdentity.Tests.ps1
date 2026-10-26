<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-LogicTestIdentity.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Test-LogicTestIdentity' -Tag 'L1', 'integrity', 'source-only' {
    It 'the automation test tree is free of live-identity leaks in logic tests' {
        $result = Test-LogicTestIdentity -PassThru -OutputFolder (Join-Path $TestDrive 'logic-test-identity')
        $result.IssueCount |
            Should -Be 0 -Because "logic tests must use fixtures, not live identities (ADR-REPO-LANG):`n$($result.Issues -join "`n")"
    }

    It 'catches a live customer planted in a logic-test file' {
        $path = Join-Path $TestDrive 'Planted.Tests.ps1'
        [System.IO.File]::WriteAllText($path,
            "Describe 'X' -Tag 'L0', 'logic' { It 'a' { Do-Thing -Customer 'apex' | Should -Be 1 } }")
        $result = Test-LogicTestIdentity -Path $path -PassThru -OutputFolder (Join-Path $TestDrive 'planted')
        $result.IssueCount | Should -BeGreaterThan 0
        $result.Issues[0] | Should -Match "live identity 'apex'"
        $result.Issues[0] | Should -Match 'fixture'
    }

    It 'passes a planted fixture-only logic-test file' {
        $path = Join-Path $TestDrive 'Clean.Tests.ps1'
        [System.IO.File]::WriteAllText($path,
            "Describe 'X' -Tag 'L0', 'logic' { It 'a' { Do-Thing -Customer 'acme' | Should -Be 1 } }")
        (Test-LogicTestIdentity -Path $path -PassThru -OutputFolder (Join-Path $TestDrive 'clean')).IssueCount |
            Should -Be 0
    }
}

Describe 'Test-LogicTestIdentity — gate shape' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-LiveIdentityTokens -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Token = 'gizmo'; Kind = 'customer-key'; Source = 'widget.yml'; Suggest = 'a fixture widget'; MatchMode = 'exact' }
        }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
        $script:clean = Join-Path $TestDrive 'Widget.Tests.ps1'
        [System.IO.File]::WriteAllText($script:clean,
            "Describe 'X' -Tag 'L0', 'logic' { It 'a' { Do-Thing -Name 'widget' | Should -Be 1 } }")
        $script:leaky = Join-Path $TestDrive 'Gadget.Tests.ps1'
        [System.IO.File]::WriteAllText($script:leaky,
            "Describe 'X' -Tag 'L0', 'logic' {`n It 'a' { Do-Thing -Name 'gizmo' | Should -Be 1 }`n}")
    }

    It 'passes when no logic test names a live identity' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-LogicTestIdentity -Path $script:clean -OutputFolder $script:reportBase } | Should -Not -Throw
    }

    It 'throws once listing every live-identity use with its file and line' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-LogicTestIdentity -Path $script:clean, $script:leaky -OutputFolder $script:reportBase } |
            Should -Throw "Test-LogicTestIdentity failed: 1 issue(s)*Gadget.Tests.ps1:2: logic test uses live identity 'gizmo'*a fixture widget*"
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Test-LogicTestIdentity -Path $script:clean, $script:leaky -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'logic-test-identity'
        $result.IssueCount | Should -Be 1
        $result.Facts['FileCount'] | Should -Be 2
        Test-Path (Join-Path $result.ReportPath 'logic-test-identity.md') | Should -BeTrue
    }
}
