<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-GitTrackedPath' -Tag 'L0', 'logic' {
    BeforeAll {
        # A minimal version-2 index of stage-0 regular files — the reader's own shapes are pinned in
        # Catzc.Base.Git/tests/types/GitIndex.Tests.ps1; here only the seam, the pathspec, and the content-keyed cache matter.
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
        Set-GitIndexFile @('automation/widget/configs/gadget.yml', 'automation/widget/configs/widget.yml', 'docs/widget.md')
    }

    It 'returns every tracked path at or under the given paths' {
        Get-GitTrackedPath 'automation/widget/configs' |
            Should -Be @('automation/widget/configs/gadget.yml', 'automation/widget/configs/widget.yml')
    }

    It "returns the whole tracked set for '.'" {
        @(Get-GitTrackedPath '.').Count | Should -Be 3
    }

    It 'returns nothing when git tracks none of the paths' {
        @(Get-GitTrackedPath 'automation/widget/configs/missing.yml').Count | Should -Be 0
    }

    It 'returns nothing when the repository has no index yet (nothing added)' {
        [System.IO.File]::Delete($script:indexPath)
        @(Get-GitTrackedPath '.').Count | Should -Be 0
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
}

# The reader against the real thing: on this repository's own index, the in-process answer is byte-for-byte
# what `git ls-files` prints (unmerged paths, which git repeats per stage, counted once).
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
                Where-Object { $_ -like '100755 *' } | ForEach-Object { ($_ -split "`t", 2)[1] } | Select-Object -Unique)
        @(Get-GitTrackedPath '.' -ExecutableOnly) | Should -Be $git
    }
}
