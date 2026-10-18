Describe 'Get-CombinedTypeHash' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force

        function script:New-TypesRoot {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            foreach ($pair in @(@('Widget', 'Alpha'), @('Widget', 'Beta'), @('Gadget', 'Gamma'))) {
                $folder = Join-Path (Join-Path $root $pair[0]) 'types'
                [System.IO.Directory]::CreateDirectory($folder) | Out-Null
                [System.IO.File]::WriteAllText((Join-Path $folder "$($pair[1]).cs"), "namespace $($pair[0]);`npublic class $($pair[1]) { }`n")
            }
            $root
        }
    }

    It 'hashes every file and writes no memo when no stamp path is given' {
        $root = New-TypesRoot
        $result = Get-CombinedTypeHash $root
        $result.Files.Count | Should -Be 3
        $result.Rehashed | Should -Be 3
        $result.CombinedHash | Should -Match '^[0-9a-f]{8}$'
        @(Get-ChildPath $root -Depth 3 -File -Filter '*.json' -Exclude @() -PruneVendor $false).Count | Should -Be 0
    }

    It 'writes the memo on the first call and rehashes nothing on the second, with the same hash and snapshot' {
        $root = New-TypesRoot
        $stamp = Join-Path $TestDrive "stamp-$([guid]::NewGuid().ToString('N')).json"
        $first = Get-CombinedTypeHash $root -StampPath $stamp
        $first.Rehashed | Should -Be 3
        [System.IO.File]::Exists($stamp) | Should -BeTrue

        $second = Get-CombinedTypeHash $root -StampPath $stamp
        $second.Rehashed | Should -Be 0
        $second.CombinedHash | Should -Be $first.CombinedHash
        $second.CombinedHash | Should -Be (Get-CombinedTypeHash $root).CombinedHash
        @($second.Snapshot.Keys) | Should -Be @($first.Snapshot.Keys)
        foreach ($key in $first.Snapshot.Keys) {
            $second.Snapshot[$key] | Should -Be $first.Snapshot[$key]
        }
    }

    It 'rehashes a file whose length or last write changed, and only that file' {
        $root = New-TypesRoot
        $stamp = Join-Path $TestDrive "stamp-$([guid]::NewGuid().ToString('N')).json"
        $before = Get-CombinedTypeHash $root -StampPath $stamp
        $alpha = Join-Path $root 'Widget/types/Alpha.cs'
        [System.IO.File]::WriteAllText($alpha, "namespace Widget;`npublic class Alpha { public int Tag; }`n")

        $after = Get-CombinedTypeHash $root -StampPath $stamp
        $after.Rehashed | Should -Be 1
        $after.CombinedHash | Should -Not -Be $before.CombinedHash
        $after.Snapshot['Widget/Alpha'] | Should -Not -Be $before.Snapshot['Widget/Alpha']
        $after.Snapshot['Widget/Beta'] | Should -Be $before.Snapshot['Widget/Beta']
        $after.CombinedHash | Should -Be (Get-CombinedTypeHash $root).CombinedHash
    }

    It 'rewrites the memo when a file is added or removed' {
        $root = New-TypesRoot
        $stamp = Join-Path $TestDrive "stamp-$([guid]::NewGuid().ToString('N')).json"
        $null = Get-CombinedTypeHash $root -StampPath $stamp
        [System.IO.File]::WriteAllText((Join-Path $root 'Gadget/types/Delta.cs'), "namespace Gadget;`npublic class Delta { }`n")
        (Get-CombinedTypeHash $root -StampPath $stamp).Rehashed | Should -Be 1
        [System.IO.File]::Delete((Join-Path $root 'Gadget/types/Delta.cs'))
        $removed = Get-CombinedTypeHash $root -StampPath $stamp
        $removed.Rehashed | Should -Be 0
        $removed.Files.Count | Should -Be 3
        (Get-CombinedTypeHash $root -StampPath $stamp).Rehashed | Should -Be 0
        (([System.IO.File]::ReadAllText($stamp) | ConvertFrom-Json -AsHashtable)['files']).Count | Should -Be 3
    }

    It 'names one memo per modules root beside the shadow copies, the same with or without a trailing separator' {
        Mock Get-TypesShadowRoot { Join-Path $TestDrive 'shadow' } -ModuleName Catzc.Internal.Types
        $root = New-TypesRoot
        $path = Get-TypesStampPath -ModulesRoot $root
        [System.IO.Path]::GetDirectoryName($path) | Should -Be (Join-Path $TestDrive 'shadow')
        [System.IO.Path]::GetFileName($path) | Should -Match '^stamp-[0-9a-f]{12}\.json$'
        Get-TypesStampPath -ModulesRoot ($root + [System.IO.Path]::DirectorySeparatorChar) | Should -Be $path
        Get-TypesStampPath -ModulesRoot (Join-Path $TestDrive 'elsewhere') | Should -Not -Be $path
    }

    It 'ignores a memo it cannot read and hashes every file' {
        $root = New-TypesRoot
        $stamp = Join-Path $TestDrive "stamp-$([guid]::NewGuid().ToString('N')).json"
        [System.IO.File]::WriteAllText($stamp, 'not json {')
        $result = Get-CombinedTypeHash $root -StampPath $stamp
        $result.Rehashed | Should -Be 3
        $result.CombinedHash | Should -Be (Get-CombinedTypeHash $root).CombinedHash
        (([System.IO.File]::ReadAllText($stamp) | ConvertFrom-Json -AsHashtable)['combined']) | Should -Be $result.CombinedHash
    }

    It 'returns the hash and leaves no temporary file when another process holds the memo open' {
        $root = New-TypesRoot
        $stamp = Join-Path $TestDrive "stamp-$([guid]::NewGuid().ToString('N')).json"
        [System.IO.File]::WriteAllText($stamp, 'not json {')
        $held = [System.IO.File]::Open($stamp, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
        try {
            $result = Get-CombinedTypeHash $root -StampPath $stamp
        }
        finally {
            $held.Dispose()
        }
        $result.CombinedHash | Should -Be (Get-CombinedTypeHash $root).CombinedHash
        @(Get-ChildPath $TestDrive -Depth 1 -File -Filter '*.tmp' -Exclude @() -PruneVendor $false).Count | Should -Be 0
    }
}
