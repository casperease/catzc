# Integrity — it reads the real shipped config (and derives from the real fixture configs).
Describe 'Test-ConfigIdentityHygiene' -Tag 'L1', 'integrity' {
    It 'the shipped config is free of test-fixture identities' {
        $result = Test-ConfigIdentityHygiene -PassThru
        $leaks = @($result.Findings | ForEach-Object { "$(ConvertTo-RepoRelativePath $_.File): $($_.Token) @ $($_.Location)" })
        $result.FindingCount | Should -Be 0 -Because "a shipped config must name live identities, not fixtures (ADR-LANG):`n$($leaks -join "`n")"
    }

    It 'catches a fixture identity planted in a config VALUE' {
        $path = Join-Path $TestDrive 'planted.yml'
        $yaml = @'
customers:
  acme:
    shortcode: ac
'@
        [System.IO.File]::WriteAllText($path, $yaml)
        $result = Test-ConfigIdentityHygiene -Path $path -PassThru
        $result.FindingCount | Should -BeGreaterThan 0
        $result.Findings.Token | Should -Contain 'acme'
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
        (Test-ConfigIdentityHygiene -Path $path -PassThru).FindingCount | Should -Be 0
    }
}
