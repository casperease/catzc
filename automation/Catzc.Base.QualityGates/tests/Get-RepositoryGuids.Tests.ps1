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

Describe 'Repository guid integrity' -Tag 'L2', 'integrity' {
    It 'every guid in tracked text is registered, and every registry entry is live' {
        # The scan reads nearly the whole tree plus its own config, so it protects against the
        # repository-wide set, like the spelling scan (ADR-REPO-PROTGLOB:6).
        if (Test-GlobSetProtection -Test 'guids' -Name 'automation') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }

        $entries = Get-ManagedGuids
        $registered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($name in @($entries.Keys)) {
            [void]$registered.Add("$($entries[$name].guid)")
        }
        $deniedEntries = (Get-Config -Config guids).denied
        if ($null -eq $deniedEntries) {
            $deniedEntries = [ordered]@{}
        }
        $denied = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($name in @($deniedEntries.Keys)) {
            [void]$denied.Add("$($deniedEntries[$name].guid)")
        }

        $found = @(Get-RepositoryGuids)

        $deniedFound = @($found | Where-Object { $denied.Contains($_.guid) })
        $deniedReport = @($deniedFound | ForEach-Object { "$($_.file):$($_.line) $($_.guid)" })
        $deniedReport | Should -BeNullOrEmpty -Because 'a denied guid (guids.yml `denied:`) is never a legitimate identity and must not appear in tracked text — construct it at runtime (e.g. [guid]::Empty) instead'

        $unregistered = @($found | Where-Object { -not $registered.Contains($_.guid) })
        $unregisteredReport = @($unregistered | ForEach-Object { "$($_.file):$($_.line) $($_.guid)" })
        $unregisteredReport | Should -BeNullOrEmpty -Because 'every guid in tracked text must be registered in Catzc.Base.QualityGates/configs/guids.yml — mint a readable placeholder with ConvertTo-Guid, or remove the guid'

        $foundValues = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($record in $found) {
            [void]$foundValues.Add($record.guid)
        }
        $deadEntries = @(@($entries.Keys) | Where-Object { -not $foundValues.Contains("$($entries[$_].guid)") })
        $deadEntries | Should -BeNullOrEmpty -Because 'a guids.yml entry no tracked file references is dead vocabulary and must be removed'

        Protect-GlobSet -Test 'guids' -Name 'automation'
    }
}
