Describe 'Get-GitTrackedPath' -Tag 'L0', 'logic' {
    BeforeAll {
        # A minimal index is enough here: the seam, the pathspec and the content-keyed cache are what this file proves.
        function Set-GitIndexFile {
            param([string[]] $Path)
            $bytes = [System.Collections.Generic.List[byte]]::new()
            $bigEndian = {
                param([long] $Value, [int] $Size)
                for ($shift = ($Size - 1) * 8; $shift -ge 0; $shift -= 8) {
                    $bytes.Add([byte](($Value -shr $shift) -band 0xFF))
                }
            }
            $bytes.AddRange([System.Text.Encoding]::ASCII.GetBytes('DIRC'))
            & $bigEndian 2 4
            & $bigEndian $Path.Count 4
            foreach ($item in $Path) {
                $name = [System.Text.Encoding]::UTF8.GetBytes($item)
                $start = $bytes.Count
                $bytes.AddRange([byte[]]::new(24))
                & $bigEndian 0x81A4 4
                $bytes.AddRange([byte[]]::new(32))
                & $bigEndian $name.Length 2
                $bytes.AddRange($name)
                $padded = ($bytes.Count - $start + 8) -band -bnot 7
                while ($bytes.Count - $start -lt $padded) {
                    $bytes.Add(0)
                }
            }
            $bytes.AddRange([System.Security.Cryptography.SHA1]::HashData($bytes.ToArray()))
            [System.IO.File]::WriteAllBytes($script:indexPath, $bytes.ToArray())
        }

        $script:indexPath = Join-Path $TestDrive 'index'
        Mock Get-GitIndexPath { $script:indexPath } -ModuleName Catzc.Base.Files
    }

    BeforeEach {
        InModuleScope Catzc.Base.Files { $script:gitIndexCache = $null }
        Set-GitIndexFile @('widgets/widget/configs/gadget.yml', 'widgets/widget/configs/widget.yml', 'docs/widget.md')
    }

    It 'returns every tracked path at or under the given paths' {
        Get-GitTrackedPath 'widgets/widget/configs' |
            Should -Be @('widgets/widget/configs/gadget.yml', 'widgets/widget/configs/widget.yml')
    }

    It "returns the whole tracked set for '.'" {
        @(Get-GitTrackedPath '.').Count | Should -Be 3
    }

    It 'returns nothing when git tracks none of the paths' {
        @(Get-GitTrackedPath 'widgets/widget/configs/missing.yml').Count | Should -Be 0
    }

    It 'returns nothing when the repository has no index yet (nothing added)' {
        [System.IO.File]::Delete($script:indexPath)
        @(Get-GitTrackedPath '.').Count | Should -Be 0
    }

    It 'returns nothing, and never reads an index, in a working root with no repository' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'no-repo' } -ModuleName Catzc.Base.Files
        New-Item -ItemType Directory -Path (Join-Path $TestDrive 'no-repo') | Out-Null
        @(Get-GitTrackedPath '.').Count | Should -Be 0
        Should -Invoke Get-GitIndexPath -ModuleName Catzc.Base.Files -Times 0
    }

    It 'reflects the index as it is on disk now — a changed index re-keys the cache' {
        @(Get-GitTrackedPath 'docs').Count | Should -Be 1
        Set-GitIndexFile @('docs/gadget.md', 'docs/widget.md')
        Get-GitTrackedPath 'docs' | Should -Be @('docs/gadget.md', 'docs/widget.md')
    }

    It 'reuses the parsed index while the bytes on disk are unchanged' {
        Get-GitTrackedPath '.' | Out-Null
        $first = InModuleScope Catzc.Base.Files { $script:gitIndexCache[(Get-GitIndexPath)] }
        Get-GitTrackedPath 'docs' | Out-Null
        $second = InModuleScope Catzc.Base.Files { $script:gitIndexCache[(Get-GitIndexPath)] }
        [object]::ReferenceEquals($first, $second) | Should -BeTrue
    }

    Context 'the installed code root' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        BeforeEach {
            $script:fixtureRoot = Join-Path $TestDrive 'repo'
            # The fixture root is a checkout: a .git folder, with the index itself mocked above.
            New-Item -ItemType Directory -Path (Join-Path $script:fixtureRoot '.git') -Force | Out-Null
            Mock Get-RepositoryRoot { $script:fixtureRoot } -ModuleName Catzc.Base.Files
            Mock Get-CatzcModulesRoot { Join-Path $script:fixtureRoot '.vendor/Catzc/1.0.0' } -ModuleName Catzc.Base.Files
            Set-GitIndexFile @('.vendor/Catzc/1.0.0/widget/gadget.sh', 'widget/gadget.sh')
        }

        It 'is dropped from the listing in build mode' {
            Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Files
            Get-GitTrackedPath '.' | Should -Be @('widget/gadget.sh')
        }

        It 'is listed in source mode' {
            Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Files
            Get-GitTrackedPath '.' | Should -Be @('.vendor/Catzc/1.0.0/widget/gadget.sh', 'widget/gadget.sh')
        }

        It 'drops nothing in build mode when the code root lies outside the repository' {
            Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Files
            Mock Get-CatzcModulesRoot { Join-Path $TestDrive 'elsewhere' } -ModuleName Catzc.Base.Files
            @(Get-GitTrackedPath '.').Count | Should -Be 2
        }
    }

    Context 'the root files catzc renders' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        BeforeEach {
            $script:fixtureRoot = Join-Path $TestDrive 'repo'
            New-Item -ItemType Directory -Path (Join-Path $script:fixtureRoot '.git') -Force | Out-Null
            Mock Get-RepositoryRoot { $script:fixtureRoot } -ModuleName Catzc.Base.Files
            Mock Get-CatzcModulesRoot { Join-Path $script:fixtureRoot '.vendor/Catzc/1.0.0' } -ModuleName Catzc.Base.Files
            Mock Get-GeneratedTarget {
                [Catzc.Base.Variants.GeneratedTarget]::new('widget.yml', 'Build-Widget', 'widget')
                [Catzc.Base.Variants.GeneratedTarget]::new('*/README.md', 'Build-Gadget', 'widget')
            } -ModuleName Catzc.Base.Files
            $importer = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.ImporterEntry
            Set-GitIndexFile @($importer, 'widget.yml', 'gadget.yml', 'widget/gadget.sh')
        }

        It 'are dropped from the listing in build mode, the engine importer and the exact generated target, and a file that is no generated target is kept' {
            Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Files
            Get-GitTrackedPath '.' | Should -Be @('gadget.yml', 'widget/gadget.sh')
        }

        It 'are listed in source mode' {
            Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Files
            @(Get-GitTrackedPath '.').Count | Should -Be 4
        }
    }
}

# Byte for byte what git ls-files prints, an unmerged path counted once though git repeats it per stage.
Describe 'Get-GitTrackedPath (real git)' -Tag 'L2', 'integrity', 'source-only' {
    It 'equals git ls-files for the whole repository and for a pathspec' {
        $git = @((Invoke-Executable 'git -c core.quotepath=off ls-files' -PassThru -Silent).Output -split "`r?`n" |
                Where-Object { $_ -ne '' } | Select-Object -Unique)
        @(Get-GitTrackedPath '.') | Should -Be $git

        $gitDocs = @((Invoke-Executable 'git -c core.quotepath=off ls-files -- "docs" "importer.ps1"' -PassThru -Silent).Output -split "`r?`n" |
                Where-Object { $_ -ne '' } | Select-Object -Unique)
        @(Get-GitTrackedPath 'docs', 'importer.ps1') | Should -Be $gitDocs
    }

    It 'with -ExecutableOnly, equals the 100755 entries git ls-files -s lists' {
        $git = @((Invoke-Executable 'git -c core.quotepath=off ls-files -s' -PassThru -Silent).Output -split "`r?`n" |
                Where-Object { $_ -like '100755 *' } | ForEach-Object { ($_ -split "`t", 2)[1] } |
                Select-Object -Unique)
        @(Get-GitTrackedPath '.' -ExecutableOnly) | Should -Be $git
    }
}
