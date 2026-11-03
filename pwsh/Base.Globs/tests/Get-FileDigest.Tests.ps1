Describe 'Get-FileDigest' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        New-Item -ItemType Directory -Path $script:repo | Out-Null
        & git -C $script:repo init --quiet
        foreach ($name in 'widget.txt', 'gadget.txt', 'gone.txt') {
            [System.IO.File]::WriteAllText((Join-Path $script:repo $name), "$name`nbody`n")
        }
        & git -C $script:repo add widget.txt gadget.txt gone.txt
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'gadget.txt'), "gadget.txt`nchanged after add`n")
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'sprocket.txt'), "sprocket`n")
        Remove-Item (Join-Path $script:repo 'gone.txt')
        $script:widgetId = ((& git -C $script:repo ls-files -s widget.txt) -split '\s+')[1]
        $script:paths = 'widget.txt', 'gadget.txt', 'sprocket.txt', 'gone.txt', 'absent.txt'

        $script:digestOf = {
            param([string] $Relative)
            [Catzc.Base.Globs.DurableHash]::HashFile([System.IO.Path]::Combine($script:repo, $Relative))
        }
        $script:invoke = {
            & (Get-Module Catzc.Base.Globs) {
                param($Root, $Paths)
                Get-FileDigest -RepositoryRoot $Root -Path $Paths
            } $script:repo $script:paths
        }
    }

    BeforeEach {
        $script:out = Join-Path $TestDrive "out-$([guid]::NewGuid())"
        $script:cachePath = Join-Path $script:out 'cache/file-digests.json'
        Mock Get-OutputRoot { $script:out } -ModuleName Catzc.Base.Globs
    }

    It 'returns the DurableHash digest in order for a tracked, a modified, an untracked and a missing file' {
        $digests = & $script:invoke

        $digests.Count | Should -Be 5
        $digests[0] | Should -Be (& $script:digestOf 'widget.txt')
        $digests[1] | Should -Be (& $script:digestOf 'gadget.txt')
        $digests[2] | Should -Be (& $script:digestOf 'sprocket.txt')
        $digests[3] | Should -BeNullOrEmpty
        $digests[4] | Should -BeNullOrEmpty
    }

    It 'records only the unmodified tracked file, under its path and object id' {
        $null = & $script:invoke

        $stored = Get-Content $script:cachePath -Raw | ConvertFrom-Json -AsHashtable
        $stored.Keys | Should -Be @("widget.txt|$($script:widgetId)")
        $stored["widget.txt|$($script:widgetId)"] | Should -Be (& $script:digestOf 'widget.txt')
    }

    It 'answers a tracked file from the cache entry without reading the file' {
        New-Item -ItemType Directory -Path (Split-Path $script:cachePath) -Force | Out-Null
        $sentinel = 'f' * 64
        @{ "widget.txt|$($script:widgetId)" = $sentinel } | ConvertTo-Json | Set-Content $script:cachePath

        $digests = & $script:invoke

        # the sentinel is no digest of any bytes, so only a lookup keyed on path and object id can return it
        $digests[0] | Should -Be $sentinel
        $digests[1] | Should -Be (& $script:digestOf 'gadget.txt')
    }

    It 'drops an entry whose path or object id no longer appears in the index' {
        New-Item -ItemType Directory -Path (Split-Path $script:cachePath) -Force | Out-Null
        @{ 'widget.txt|0000000000000000000000000000000000000000' = 'a' * 64; 'removed.txt|1111' = 'b' * 64 } |
            ConvertTo-Json | Set-Content $script:cachePath

        $null = & $script:invoke

        $stored = Get-Content $script:cachePath -Raw | ConvertFrom-Json -AsHashtable
        $stored.Keys | Should -Be @("widget.txt|$($script:widgetId)")
    }

    It 'leaves no temporary file beside the cache' {
        $null = & $script:invoke

        Test-Path $script:cachePath | Should -BeTrue
        Test-Path (Join-Path (Split-Path $script:cachePath) '*.tmp') | Should -BeFalse
    }

    It 'hashes every file and writes no cache when git cannot answer' {
        Mock Invoke-Executable {
            [pscustomobject] @{ ExitCode = 128; Output = ''; Errors = 'fatal: not a git repository' }
        } -ModuleName Catzc.Base.Globs

        $digests = & $script:invoke

        $digests[0] | Should -Be (& $script:digestOf 'widget.txt')
        $digests[2] | Should -Be (& $script:digestOf 'sprocket.txt')
        $digests[3] | Should -BeNullOrEmpty
        Test-Path $script:out | Should -BeFalse
    }

    It 'returns an empty array for no paths without asking git' {
        Mock Invoke-Executable { throw 'git must not be asked' } -ModuleName Catzc.Base.Globs

        $digests = & (Get-Module Catzc.Base.Globs) {
            param($Root)
            Get-FileDigest -RepositoryRoot $Root -Path @()
        } $script:repo

        @($digests).Count | Should -Be 0
    }
}
