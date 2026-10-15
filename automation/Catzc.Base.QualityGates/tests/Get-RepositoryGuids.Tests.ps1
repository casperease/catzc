<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
    kind: test
---
#>

Describe 'Get-RepositoryGuids' -Tag 'L0', 'logic' {
    BeforeAll {
        # Unique sandbox per run; the seam mock returns ABSOLUTE fixture paths, which Resolve-RepoPath
        # passes through unchanged — so only the file-universe seam needs mocking.
        $script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())
        [void][System.IO.Directory]::CreateDirectory($script:sandbox)
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

        $script:alphaFile = Join-Path $script:sandbox 'alpha.yml'
        [System.IO.File]::WriteAllText($script:alphaFile, @(
                'tenant: a100a000-7e57-7e0a-0700-000000000000'
                'no guid on this line'
                'ids: 499B84AC-1321-427F-AA17-267CA6975798 and a100a000-7e57-7e0a-0700-000000000000'
            ) -join "`n", $utf8NoBom)

        $script:hashFile = Join-Path $script:sandbox 'hashes.txt'
        [System.IO.File]::WriteAllText($script:hashFile, @(
                'sha256: 3f79bb7b435b05321651daefd374cdc681dc06faa65e374e38337b88ca046dea'
                'bare hex: a1a7e577ea7000000000000000000000'
            ) -join "`n", $utf8NoBom)
    }

    BeforeEach {
        Mock Get-GuidScanFiles { @($script:alphaFile, $script:hashFile) } -ModuleName Catzc.Base.QualityGates
    }

    It 'finds every guid occurrence with file and line' {
        $found = @(Get-RepositoryGuids)
        $found.Count | Should -Be 3
        $found[0].file | Should -Be $script:alphaFile
        $found[0].line | Should -Be 1
        $found[0].guid | Should -BeExactly 'a100a000-7e57-7e0a-0700-000000000000'
    }

    It 'normalizes matched guids to lowercase' {
        $found = @(Get-RepositoryGuids)
        $found[1].guid | Should -BeExactly '499b84ac-1321-427f-aa17-267ca6975798'
    }

    It 'returns one record per occurrence, including repeats on one line' {
        $found = @(Get-RepositoryGuids)
        @($found | Where-Object { $_.line -eq 3 }).Count | Should -Be 2
    }

    It 'ignores unhyphenated hex — hashes and bare 32-hex never match' {
        $found = @(Get-RepositoryGuids)
        @($found | Where-Object { $_.file -eq $script:hashFile }).Count | Should -Be 0
    }

    It 'skips a listed file that is missing on disk' {
        Mock Get-GuidScanFiles { @((Join-Path $script:sandbox 'deleted.yml'), $script:alphaFile) } -ModuleName Catzc.Base.QualityGates
        @(Get-RepositoryGuids).Count | Should -Be 3
    }

    It 'returns an empty array when nothing matches' {
        Mock Get-GuidScanFiles { @($script:hashFile) } -ModuleName Catzc.Base.QualityGates
        @(Get-RepositoryGuids).Count | Should -Be 0
    }
}

# source-only: it scans the repository's tracked files, which give the same answer in both run modes. The check is the
# quality gate Test-ManagedGuids ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the
# scan against the registry, and the 'repository' globset covering everything the scan reads — so the protection
# skip below is sound ([ADR-REPO-PROTGLOB#6](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6)).
Describe 'Repository guid integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every guid in tracked text is registered, every registry entry is live, and the repository globset covers the scan' -Tag 'ADR-REPO-PROTGLOB#6' {
        if (Test-GlobSetProtection -Test 'guids' -Name 'repository') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }

        $result = Test-ManagedGuids -PassThru -OutputFolder (Join-Path $TestDrive 'managed-guids')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")

        Protect-GlobSet -Test 'guids' -Name 'repository'
    }
}
