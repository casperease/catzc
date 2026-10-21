<#
---
catzc:
  immutable:
    with_body_sha: "0b82da3ebf03"
  edges:
    docs: "[Aspect.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/types/Aspect.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Globs/types/Aspect.cs
    cites:
      - ADR-DSGN-ASPECT
---
#>

Describe 'Aspect / AspectPartition' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:convention = {
            $a = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
            $a.Add([Catzc.Base.Globs.Aspect]::new('live', @('*.ps1', 'private/**', 'types/**', 'configs/**')))
            $a.Add([Catzc.Base.Globs.Aspect]::new('tests', @('**')))
            , $a   # unary comma: return the List intact, don't let PowerShell unroll it to object[]
        }
        $script:sets = {
            param($compiled)
            $list = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
            foreach ($c in $compiled) {
                $list.Add([Catzc.Base.Globs.GlobSet]::new("m-$($c.Name)", 'd', 'module', $c.Include, $c.Exclude, @(), @(), -1, $null))
            }
            , $list
        }
    }

    Context 'Compile (ordered first-match onto a unit root)' {
        It 'prefixes own patterns as include and every earlier aspect as exclude' {
            $compiled = [Catzc.Base.Globs.AspectPartition]::Compile((& $script:convention), 'widgets/M')
            $compiled[0].Name | Should -Be 'live'
            $compiled[0].Include | Should -Be @('widgets/M/*.ps1', 'widgets/M/private/**', 'widgets/M/types/**', 'widgets/M/configs/**')
            $compiled[0].Exclude | Should -Be @()
            $compiled[1].Name | Should -Be 'tests'
            $compiled[1].Include | Should -Be @('widgets/M/**')
            $compiled[1].Exclude | Should -Be @('widgets/M/*.ps1', 'widgets/M/private/**', 'widgets/M/types/**', 'widgets/M/configs/**')
        }
    }

    Context 'the partition (disjoint + exhaustive, fail-safe)' {
        It 'routes live files to live, tests and unclassified strays to the non-live catch-all' {
            $sets = & $script:sets ([Catzc.Base.Globs.AspectPartition]::Compile((& $script:convention), 'widgets/M'))
            ($sets | Where-Object { $_.Matches('widgets/M/Get-Foo.ps1') }).Name | Should -Be 'm-live'
            ($sets | Where-Object { $_.Matches('widgets/M/types/T.cs') }).Name | Should -Be 'm-live'
            ($sets | Where-Object { $_.Matches('widgets/M/tests/Get-Foo.Tests.ps1') }).Name | Should -Be 'm-tests'
            # a stray root file 'live' does not claim falls to the non-live side — never ships
            ($sets | Where-Object { $_.Matches('widgets/M/notes.txt') }).Name | Should -Be 'm-tests'
        }

        It 'validates clean (no file in two aspects, none in zero)' {
            $sets = & $script:sets ([Catzc.Base.Globs.AspectPartition]::Compile((& $script:convention), 'widgets/M'))
            $universe = [string[]]@('widgets/M/Get-Foo.ps1', 'widgets/M/private/H.ps1', 'widgets/M/tests/A.Tests.ps1', 'widgets/M/x.txt')
            [Catzc.Base.Globs.AspectPartition]::Validate($sets, $universe).Count | Should -Be 0
        }
    }

    Context 'Validate detects a broken partition' {
        It 'flags a file claimed by two aspects (disjoint) and a file claimed by none (exhaustive)' {
            $overlap = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
            $overlap.Add([Catzc.Base.Globs.GlobSet]::new('a', 'd', 'module', @('src/**'), @(), @(), @(), -1, $null))
            $overlap.Add([Catzc.Base.Globs.GlobSet]::new('b', 'd', 'module', @('src/**'), @(), @(), @(), -1, $null))
            $v = [Catzc.Base.Globs.AspectPartition]::Validate($overlap, [string[]]@('src/x', 'other/y'))
            ($v -join "`n") | Should -Match 'disjoint violated'
            ($v -join "`n") | Should -Match 'exhaustive violated'
        }
    }

    Context 'the Aspect constructor gate' {
        It 'rejects a non-kebab name' {
            { [Catzc.Base.Globs.Aspect]::new('Live', @('**')) } | Should -Throw '*kebab*'
        }
        It 'rejects an empty pattern list' {
            { [Catzc.Base.Globs.Aspect]::new('live', @()) } | Should -Throw '*at least one pattern*'
        }
    }
}
