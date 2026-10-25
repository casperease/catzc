<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Select-TestShardAssignment.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Select-TestShardAssignment' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        $script:path = { param($name) Join-Path $script:root "widgets/Catzc.Widget/tests/$name.Tests.ps1" }
        $script:assign = {
            param([string[]] $Files, [int] $Workers, [hashtable] $Durations)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = $Files; Workers = $Workers; Durations = $Durations; Root = $script:root } {
                param($Files, $Workers, $Durations, $Root)
                @(Select-TestShardAssignment -File $Files -WorkerCount $Workers -DurationMs $Durations -RepositoryRoot $Root)
            }
        }
    }

    It 'deals the longest files first, each to the least-loaded shard, so the shards finish together' {
        $files = 'gadget', 'widget', 'sprocket', 'gizmo', 'cog' | ForEach-Object { & $script:path $_ }
        $durations = @{
            'widgets/Catzc.Widget/tests/gadget.Tests.ps1'   = 1000
            'widgets/Catzc.Widget/tests/widget.Tests.ps1'   = 9000
            'widgets/Catzc.Widget/tests/sprocket.Tests.ps1' = 5000
            'widgets/Catzc.Widget/tests/gizmo.Tests.ps1'    = 4000
            'widgets/Catzc.Widget/tests/cog.Tests.ps1'      = 1000
        }
        $shards = & $script:assign $files 2 $durations
        $shards | Should -HaveCount 2
        $shards[0] | Should -Be @((& $script:path 'widget'), (& $script:path 'gadget'))
        $shards[1] | Should -Be @((& $script:path 'sprocket'), (& $script:path 'gizmo'), (& $script:path 'cog'))
    }

    It 'weighs a file without history as the median of the known durations' {
        $files = 'widget', 'gadget', 'sprocket' | ForEach-Object { & $script:path $_ }
        $durations = @{
            'widgets/Catzc.Widget/tests/widget.Tests.ps1' = 9000
            'widgets/Catzc.Widget/tests/gadget.Tests.ps1' = 1000
        }
        # The median of 1 s and 9 s is 9 s (the upper middle), so sprocket ties widget and keeps its given order after it.
        $shards = & $script:assign $files 3 $durations
        $shards[0] | Should -Be @(& $script:path 'widget')
        $shards[1] | Should -Be @(& $script:path 'sprocket')
        $shards[2] | Should -Be @(& $script:path 'gadget')
    }

    It 'splits evenly in the given order when nothing is known yet' {
        $files = 'widget', 'gadget', 'sprocket', 'gizmo' | ForEach-Object { & $script:path $_ }
        $shards = & $script:assign $files 2 @{}
        $shards[0] | Should -Be @((& $script:path 'widget'), (& $script:path 'sprocket'))
        $shards[1] | Should -Be @((& $script:path 'gadget'), (& $script:path 'gizmo'))
    }

    It 'returns one array per shard, an empty one for a shard with no file, and works with a single shard' {
        $one = & $script:assign @(& $script:path 'widget') 3 @{}
        $one | Should -HaveCount 3
        $one[0] | Should -Be @(& $script:path 'widget')
        $one[1].Count | Should -Be 0
        $single = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @((& $script:path 'widget'), (& $script:path 'gadget')); Root = $script:root } {
            param($Files, $Root)
            $shards = @(Select-TestShardAssignment -File $Files -WorkerCount 1 -RepositoryRoot $Root)
            '{0}:{1}' -f $shards.Count, $shards[0].Count
        }
        $single | Should -Be '1:2'
    }
}
