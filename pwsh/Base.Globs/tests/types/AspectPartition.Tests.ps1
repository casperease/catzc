Describe 'Catzc.Base.Globs.AspectPartition' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:set = {
            param([string] $Name, [string[]] $Include, [string[]] $Exclude = @())
            [Catzc.Base.Globs.GlobSet]::new($Name, 'd', 'module', $Include, $Exclude, @(), @(), -1, $null)
        }
    }

    It 'names the first aspect, in the map''s order, one of whose sets claims the file' {
        $sets = [ordered]@{
            live  = @((& $script:set 'widget-live' @('widget/*.ps1')))
            tests = @((& $script:set 'widget-tests' @('widget/tests/**')),
                (& $script:set 'gadget-tests' @('gadget/tests/**', 'widget/**')))
        }
        [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, 'widget/Get-Widget.ps1') | Should -Be 'live'
        [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, 'gadget/tests/a.Tests.ps1') | Should -Be 'tests'
        [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, 'widget/tests/a.Tests.ps1') | Should -Be 'tests'
    }

    It 'returns null for a file no aspect claims, and an exclude keeps a file out of its set' {
        $sets = [ordered]@{ live = @((& $script:set 'widget-live' @('widget/**') @('widget/out/**'))) }
        [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, 'gadget/a.ps1') | Should -BeNullOrEmpty
        [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, 'widget/out/a.ps1') | Should -BeNullOrEmpty
    }
}
