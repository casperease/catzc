<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
    folder: tests
    name: get-repository-guids-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-RepositoryGuids.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG
---
#>

Describe 'Get-RepositoryGuids' -Tag 'L0', 'logic' {
    BeforeAll {
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

Describe 'Repository guid integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every guid in tracked text is registered, every registry entry is live, and the repository globset covers the scan' -Tag 'ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG' {
        if (Test-GlobSetProtection -Test 'guids' -Name 'repository') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }

        $result = Test-ManagedGuids -PassThru -OutputFolder (Join-Path $TestDrive 'managed-guids')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")

        Protect-GlobSet -Test 'guids' -Name 'repository'
    }
}
