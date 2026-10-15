<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/AdrCodeForm.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.Docs/types/AdrCodeForm.cs
---
#>

Describe 'AdrCodeForm' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        function New-Registry {
            $entry = { param($rules) @{ path = 'docs/adr/widget/x.md'; rules = $rules } }
            [Catzc.Base.Docs.AdrCitationMap]::new([ordered]@{
                    'ADR-WIDGET-GADGET'   = (& $entry @(1, 2, 3, 4, 5))
                    'ADR-WIDGET-SPROCKET' = (& $entry @(1, 2))
                    'ADR-WIDGET-LONE'     = (& $entry @(7))
                    'ADR-COG-BOLT'        = (& $entry @(1, 2))
                    'ADR-COG-NUT-WASHER'  = (& $entry @(1, 2, 3))
                    'ADR-COG-NUT-SHIM'    = (& $entry @(4))
                }, @())
        }
        $script:registry = New-Registry
        $script:form = [Catzc.Base.Docs.AdrCodeForm]
    }

    Context 'Expand' {
        It 'reads a bare code as itself' {
            $script:form::Expand('ADR-WIDGET-GADGET') | Should -Be @('ADR-WIDGET-GADGET')
        }

        It 'reads one rule' {
            $script:form::Expand('ADR-WIDGET-GADGET#5') | Should -Be @('ADR-WIDGET-GADGET#5')
        }

        It 'reads a group of numbers and ranges, ascending and without duplicates' {
            $script:form::Expand('ADR-WIDGET-GADGET#{9,1,3-5,4,2-3}') |
                Should -Be @(1, 2, 3, 4, 5, 9 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
        }

        It 'orders rules numerically, never as text' {
            $script:form::Expand('ADR-WIDGET-GADGET#{10,9,100,2}') |
                Should -Be @(2, 9, 10, 100 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
        }

        It 'reads a one-number range and a one-number group' {
            $script:form::Expand('ADR-WIDGET-GADGET#{4-4}') | Should -Be @('ADR-WIDGET-GADGET#4')
            $script:form::Expand('ADR-WIDGET-GADGET#{4}') | Should -Be @('ADR-WIDGET-GADGET#4')
        }

        It 'reads #* as every rule the registry declares' {
            $script:form::Expand('ADR-WIDGET-SPROCKET#*', $script:registry) | Should -Be @('ADR-WIDGET-SPROCKET#1', 'ADR-WIDGET-SPROCKET#2')
        }

        It 'reads a prefix glob as every rule of every code under it' {
            $script:form::Expand('ADR-COG-NUT-*', $script:registry) |
                Should -Be @('ADR-COG-NUT-SHIM#4', 'ADR-COG-NUT-WASHER#1', 'ADR-COG-NUT-WASHER#2', 'ADR-COG-NUT-WASHER#3')
            @($script:form::Expand('ADR-COG-*', $script:registry)).Count | Should -Be 6
        }

        It 'does not let a prefix glob match a sibling that only shares letters' {
            $script:form::Expand('ADR-COG-NUT-*', $script:registry) | Should -Not -Contain 'ADR-COG-BOLT#1'
        }

        It 'needs a registry for a glob' {
            { $script:form::Expand('ADR-COG-*') } | Should -Throw '*needs the ADR registry*'
            { $script:form::Expand('ADR-COG-BOLT#*') } | Should -Throw '*needs the ADR registry*'
        }

        It 'rejects a glob that matches nothing' {
            { $script:form::Expand('ADR-NOPE-*', $script:registry) } | Should -Throw '*matches no registered rule*'
            { $script:form::Expand('ADR-NOPE-ONE#*', $script:registry) } | Should -Throw '*matches no registered rule*'
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'an empty group'; Token = 'ADR-WIDGET-GADGET#{}' }
            @{ Name = 'an empty item'; Token = 'ADR-WIDGET-GADGET#{1,,2}' }
            @{ Name = 'a trailing comma'; Token = 'ADR-WIDGET-GADGET#{1,}' }
            @{ Name = 'a reversed range'; Token = 'ADR-WIDGET-GADGET#{5-3}' }
            @{ Name = 'an open range'; Token = 'ADR-WIDGET-GADGET#{3-}' }
            @{ Name = 'a range with no start'; Token = 'ADR-WIDGET-GADGET#{-3}' }
            @{ Name = 'a chained range'; Token = 'ADR-WIDGET-GADGET#{1-3-5}' }
            @{ Name = 'rule zero'; Token = 'ADR-WIDGET-GADGET#0' }
            @{ Name = 'a leading zero'; Token = 'ADR-WIDGET-GADGET#01' }
            @{ Name = 'a leading zero in a group'; Token = 'ADR-WIDGET-GADGET#{1,02}' }
            @{ Name = 'a number past int range'; Token = 'ADR-WIDGET-GADGET#99999999999' }
            @{ Name = 'a range wider than the cap'; Token = 'ADR-WIDGET-GADGET#{1-20000}' }
            @{ Name = 'a nested group'; Token = 'ADR-WIDGET-GADGET#{1,{2}}' }
            @{ Name = 'a space in a group'; Token = 'ADR-WIDGET-GADGET#{1, 2}' }
            @{ Name = 'a letter in a group'; Token = 'ADR-WIDGET-GADGET#{1,x}' }
            @{ Name = 'a missing close'; Token = 'ADR-WIDGET-GADGET#{1,2' }
            @{ Name = 'a lower-case code'; Token = 'adr-widget-gadget#1' }
            @{ Name = 'a rule with no code'; Token = '#1' }
            @{ Name = 'a bare #'; Token = 'ADR-WIDGET-GADGET#' }
            @{ Name = 'the colon spelling'; Token = 'ADR-WIDGET-GADGET:1' }
            @{ Name = 'a glob in the middle'; Token = 'ADR-*-GADGET#1' }
            @{ Name = 'a trailing newline'; Token = "ADR-WIDGET-GADGET#1`n" }
            @{ Name = 'an empty string'; Token = '' }
        ) {
            { $script:form::Expand($Token, $script:registry) } | Should -Throw
        }

        It 'throws on a null token' {
            { $script:form::Expand($null) } | Should -Throw
        }
    }

    Context 'ExpandAll' {
        It 'unions several tokens, a bare code first among its own rules' {
            $script:form::ExpandAll(@('ADR-WIDGET-GADGET#{2-3}', 'ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET', 'ADR-COG-BOLT#1')) |
                Should -Be @('ADR-COG-BOLT#1', 'ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3')
        }

        It 'returns nothing for no tokens' {
            @($script:form::ExpandAll(@())).Count | Should -Be 0
        }
    }

    Context 'Minimize' {
        It 'writes one rule plain' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#5')) | Should -Be @('ADR-WIDGET-GADGET#5')
        }

        It 'groups the rules of one code and keeps a pair as two numbers' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET#4')) | Should -Be @('ADR-WIDGET-GADGET#{3,4}')
        }

        It 'turns a run of three or more into a range' {
            $script:form::Minimize(@(3, 4, 5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })) | Should -Be @('ADR-WIDGET-GADGET#{3-5}')
        }

        It 'minimizes a real defines list to one entry' {
            $rules = 1, 3, 4, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17 + (19..28) + (30..44)
            $got = $script:form::Minimize(@($rules | ForEach-Object { "ADR-WIDGET-GADGET#$_" }))
            $got | Should -Be @('ADR-WIDGET-GADGET#{1,3,4,6-10,13-17,19-28,30-44}')
        }

        It 'sorts numerically so #10 follows #9' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#10', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#9')) | Should -Be @('ADR-WIDGET-GADGET#{2,9,10}')
        }

        It 'collapses duplicates' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#1', 'ADR-WIDGET-GADGET#1')) | Should -Be @('ADR-WIDGET-GADGET#1')
        }

        It 'keeps a bare code beside the code''s rules and never groups it' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET')) |
                Should -Be @('ADR-WIDGET', 'ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#1')
        }

        It 'orders the entries by code' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#1', 'ADR-COG-BOLT#2', 'ADR-WIDGET-LONE#7')) |
                Should -Be @('ADR-COG-BOLT#2', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-LONE#7')
        }

        It 'returns nothing for no citations' {
            @($script:form::Minimize(@())).Count | Should -Be 0
        }

        It 'writes #* when the set is every rule of a code with two or more rules' {
            $script:form::Minimize(@('ADR-WIDGET-SPROCKET#1', 'ADR-WIDGET-SPROCKET#2'), $script:registry) | Should -Be @('ADR-WIDGET-SPROCKET#*')
        }

        It 'does not glob without a registry' {
            $script:form::Minimize(@('ADR-WIDGET-SPROCKET#1', 'ADR-WIDGET-SPROCKET#2')) | Should -Be @('ADR-WIDGET-SPROCKET#{1,2}')
        }

        It 'keeps a code with one rule as that rule, even when it is the whole ADR' {
            $script:form::Minimize(@('ADR-WIDGET-LONE#7'), $script:registry) | Should -Be @('ADR-WIDGET-LONE#7')
        }

        It 'does not glob a partial code' {
            $script:form::Minimize(@('ADR-WIDGET-GADGET#1', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3'), $script:registry) | Should -Be @('ADR-WIDGET-GADGET#{1-3}')
        }

        It 'keeps a rule the registry does not declare, and so never globs past it' {
            $got = $script:form::Minimize(@('ADR-WIDGET-SPROCKET#1', 'ADR-WIDGET-SPROCKET#2', 'ADR-WIDGET-SPROCKET#9'), $script:registry)
            $got | Should -Be @('ADR-WIDGET-SPROCKET#{1,2,9}')
        }

        It 'writes a prefix glob when every rule of two or more codes under it is present' {
            $cited = @('ADR-COG-NUT-SHIM#4', 'ADR-COG-NUT-WASHER#1', 'ADR-COG-NUT-WASHER#2', 'ADR-COG-NUT-WASHER#3')
            $script:form::Minimize($cited, $script:registry) | Should -Be @('ADR-COG-NUT-*')
        }

        It 'takes the shortest prefix that is fully covered' {
            $all = @($script:form::Expand('ADR-COG-*', $script:registry))
            $script:form::Minimize($all, $script:registry) | Should -Be @('ADR-COG-*')
        }

        It 'falls back to the deeper prefix when the wider one is not fully covered' {
            $cited = @('ADR-COG-NUT-SHIM#4', 'ADR-COG-NUT-WASHER#1', 'ADR-COG-NUT-WASHER#2', 'ADR-COG-NUT-WASHER#3', 'ADR-COG-BOLT#1')
            $script:form::Minimize($cited, $script:registry) | Should -Be @('ADR-COG-BOLT#1', 'ADR-COG-NUT-*')
        }

        It 'never globs a prefix that covers a single code' {
            $script:form::Minimize(@('ADR-WIDGET-LONE#7'), $script:registry) | Should -Not -Match '\*'
        }

        It 'keeps a bare code out of a glob' {
            $all = @($script:form::Expand('ADR-COG-*', $script:registry)) + 'ADR-COG'
            $script:form::Minimize($all, $script:registry) | Should -Be @('ADR-COG', 'ADR-COG-*')
        }

        It 'rejects an input that is a group or a glob, not one citation' -ForEach @(
            @{ Item = 'ADR-WIDGET-GADGET#{1,2}' }
            @{ Item = 'ADR-WIDGET-GADGET#*' }
            @{ Item = 'ADR-WIDGET-*' }
            @{ Item = 'ADR-WIDGET-GADGET#x' }
        ) {
            { $script:form::Minimize(@($Item), $script:registry) } | Should -Throw
        }
    }

    Context 'round trip' {
        It 'reads back exactly what it wrote, over every shape of set' -ForEach @(
            @{ Rules = @(1) }
            @{ Rules = @(1, 2) }
            @{ Rules = @(1, 2, 3) }
            @{ Rules = @(1, 3) }
            @{ Rules = @(1, 3, 4, 6, 7, 8, 12) }
            @{ Rules = @(2, 4, 6, 8, 10) }
            @{ Rules = @(1..5) }
            @{ Rules = @(98, 99, 100, 101) }
        ) {
            $cited = @($Rules | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
            $min = $script:form::Minimize($cited, $script:registry)
            $script:form::ExpandAll($min, $script:registry) | Should -Be ($script:form::ExpandAll($cited))
        }

        It 'is idempotent: minimizing what Expand returned gives the same tokens' {
            $first = $script:form::Minimize(@('ADR-COG-BOLT#1', 'ADR-COG-BOLT#2', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET#4'), $script:registry)
            $second = $script:form::Minimize($script:form::ExpandAll($first, $script:registry), $script:registry)
            $second | Should -Be $first
        }

        It 'is never longer than the plain list' {
            $cited = @(1..5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
            $plain = ($cited -join ',').Length
            (($script:form::Minimize($cited, $script:registry)) -join ',').Length | Should -BeLessThan $plain
        }
    }
}
