Describe 'Test-ConfigIdentityHygiene' -Tag 'L1', 'integrity', 'source-only' {
    It 'the shipped config is free of test-fixture identities, and no fixture identity is a live one' {
        $result = Test-ConfigIdentityHygiene -PassThru -OutputFolder (Join-Path $TestDrive 'config-identity-hygiene')
        $result.IssueCount | Should -Be 0 -Because "a shipped config must name live identities, not fixtures (ADR-REPO-LANG):`n$($result.Issues -join "`n")"
    }

    It 'catches a fixture identity planted in a config VALUE' {
        $path = Join-Path $TestDrive 'planted.yml'
        $yaml = @'
customers:
  acme:
    shortcode: ac
'@
        [System.IO.File]::WriteAllText($path, $yaml)
        $result = Test-ConfigIdentityHygiene -Path $path -PassThru -OutputFolder (Join-Path $TestDrive 'planted')
        $result.IssueCount | Should -BeGreaterThan 0
        ($result.Issues -join "`n") | Should -Match "fixture identity 'acme'"
    }

    It 'is comment-blind — a fixture identity in a config COMMENT is not a finding' {
        $path = Join-Path $TestDrive 'commented.yml'
        $yaml = @'
# syntax example: have_customers is [acme, globex]
customers:
  apex:
    shortcode: ap
'@
        [System.IO.File]::WriteAllText($path, $yaml)
        (Test-ConfigIdentityHygiene -Path $path -PassThru -OutputFolder (Join-Path $TestDrive 'commented')).IssueCount | Should -Be 0
    }
}

Describe 'Test-ConfigIdentityHygiene — gate shape' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-FixtureIdentityTokens -ModuleName Catzc.Base.QualityGates { 'gizmo' }
        Mock Get-LiveIdentityTokens -ModuleName Catzc.Base.QualityGates {
            , @([pscustomobject]@{ Token = 'sprocket'; Kind = 'customer-key'; Source = 'customer.yml'; Suggest = ''; MatchMode = 'exact' })
        }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
        $script:clean = Join-Path $TestDrive 'widget.yml'
        [System.IO.File]::WriteAllText($script:clean, "widgets:`n  - widget`n")
        $script:leaky = Join-Path $TestDrive 'gadget.yml'
        [System.IO.File]::WriteAllText($script:leaky, "gadgets:`n  gizmo:`n    name: gizmo`n")
    }

    It 'passes when no config names a fixture identity' -Tag 'ADR-AUTO-TEST#35' {
        { Test-ConfigIdentityHygiene -Path $script:clean -OutputFolder $script:reportBase } | Should -Not -Throw
    }

    It 'throws once listing every fixture identity, key and value' -Tag 'ADR-AUTO-TEST#35' {
        $thrown = { Test-ConfigIdentityHygiene -Path $script:clean, $script:leaky -OutputFolder $script:reportBase } |
            Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ConfigIdentityHygiene failed: 2 issue(s)*'
        $message | Should -Match "gadget.yml: fixture identity 'gizmo' at /gadgets/gizmo \(key\)"
        $message | Should -Match "gadget.yml: fixture identity 'gizmo' at /gadgets/gizmo/name"
    }

    It 'reports a fixture identity that is also a live identity, whatever the scanned files' {
        Mock Get-LiveIdentityTokens -ModuleName Catzc.Base.QualityGates {
            , @([pscustomobject]@{ Token = 'GIZMO'; Kind = 'customer-key'; Source = 'customer.yml'; Suggest = ''; MatchMode = 'exact' })
        }
        $result = Test-ConfigIdentityHygiene -Path $script:clean -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike "fixture identity 'GIZMO' is also a live identity (customer-key in customer.yml)*"
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $result = Test-ConfigIdentityHygiene -Path $script:clean, $script:leaky -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'config-identity-hygiene'
        $result.IssueCount | Should -Be 2
        $result.FileCount | Should -Be 2
        $result.LiveTokens | Should -Be 1
        Test-Path (Join-Path $result.ReportPath 'config-identity-hygiene.md') | Should -BeTrue
    }
}
