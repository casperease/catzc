Describe 'AdrCodeForm' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-NATIVETYPEDMODEL' {
    BeforeAll {
        $script:form = [Catzc.Base.Docs.AdrCodeForm]
        $entry = { param($rules) @{ path = 'docs/adr/widget/x.md'; rules = $rules } }
        $script:registry = [Catzc.Base.Docs.AdrCitationMap]::new([ordered]@{
                'ADR-WIDGET-GADGET'   = (& $entry @(1, 2, 3, 4, 5))
                'ADR-WIDGET-SPROCKET' = (& $entry @(1, 2))
                'ADR-WIDGET-LONE'     = (& $entry @(7))
            }, @())
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

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'an empty group'; Token = 'ADR-WIDGET-GADGET#{}' }
            @{ Name = 'an empty item'; Token = 'ADR-WIDGET-GADGET#{1,,2}' }
            @{ Name = 'a trailing comma'; Token = 'ADR-WIDGET-GADGET#{1,}' }
            @{ Name = 'a reversed range'; Token = 'ADR-WIDGET-GADGET#{5-3}' }
            @{ Name = 'an open range'; Token = 'ADR-WIDGET-GADGET#{3-}' }
            @{ Name = 'a range with no start'; Token = 'ADR-WIDGET-GADGET#{-3}' }
            @{ Name = 'a chained range'; Token = 'ADR-WIDGET-GADGET#{1-3-5}' }
            @{ Name = 'rule zero'; Token = 'ADR-WIDGET-GADGET#0' }
            @{ Name = 'a leading zero'; Token = 'ADR-WIDGET-GADGET#1' }
            @{ Name = 'a leading zero in a group'; Token = 'ADR-WIDGET-GADGET#{1,02}' }
            @{ Name = 'a number past int range'; Token = 'ADR-WIDGET-GADGET#-1' }
            @{ Name = 'a range wider than the cap'; Token = 'ADR-WIDGET-GADGET#{1-20000}' }
            @{ Name = 'a nested group'; Token = 'ADR-WIDGET-GADGET#{1,{2}}' }
            @{ Name = 'a space in a group'; Token = 'ADR-WIDGET-GADGET#{1, 2}' }
            @{ Name = 'a letter in a group'; Token = 'ADR-WIDGET-GADGET#{1,x}' }
            @{ Name = 'a missing close'; Token = 'ADR-WIDGET-GADGET#{1,2' }
            @{ Name = 'a lower-case code'; Token = 'adr-widget-gadget#1' }
            @{ Name = 'a rule with no code'; Token = '#1' }
            @{ Name = 'a bare #'; Token = 'ADR-WIDGET-GADGET#' }
            @{ Name = 'the colon spelling'; Token = ('ADR-WIDGET-GADGET' + ':1') }
            @{ Name = 'a star rule'; Token = 'ADR-WIDGET-GADGET#*' }
            @{ Name = 'a prefix glob'; Token = 'ADR-WIDGET-*' }
            @{ Name = 'a trailing newline'; Token = "ADR-WIDGET-GADGET#1`n" }
            @{ Name = 'an empty string'; Token = '' }
        ) {
            { $script:form::Expand($Token) } | Should -Throw
        }

        It 'throws on a null token' {
            { $script:form::Expand($null) } | Should -Throw
        }
    }

    Context 'ExpandAll' {
        It 'unions several tokens, a bare code first among its own rules' {
            $script:form::ExpandAll([string[]] @('ADR-WIDGET-GADGET#{2-3}', 'ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET', 'ADR-COG-BOLT#1')) |
                Should -Be @('ADR-COG-BOLT#1', 'ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3')
        }

        It 'returns nothing for no tokens' {
            @($script:form::ExpandAll([string[]] @())).Count | Should -Be 0
        }
    }

    Context 'Minimize' {
        It 'writes one rule plain' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET#5')) | Should -Be @('ADR-WIDGET-GADGET#5')
        }

        It 'groups the rules of one code and keeps a pair as two numbers' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET#4')) | Should -Be @('ADR-WIDGET-GADGET#{3,4}')
        }

        It 'turns a run of three or more into a range, in braces even when it is the only part' {
            $script:form::Minimize([string[]] @(3, 4, 5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })) | Should -Be @('ADR-WIDGET-GADGET#{3-5}')
        }

        It 'minimizes a real defines list to one entry' {
            $rules = 1, 3, 4, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17 + (19..28) + (30..44)
            $got = $script:form::Minimize([string[]] @($rules | ForEach-Object { "ADR-WIDGET-GADGET#$_" }))
            $got | Should -Be @('ADR-WIDGET-GADGET#{1,3,4,6-10,13-17,19-28,30-44}')
        }

        It 'sorts numerically so #10 follows #9' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET#10', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#9')) | Should -Be @('ADR-WIDGET-GADGET#{2,9,10}')
        }

        It 'collapses duplicates' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET#1', 'ADR-WIDGET-GADGET#1')) | Should -Be @('ADR-WIDGET-GADGET#1')
        }

        It 'lets a bare code, which names the whole ADR, absorb the code''s rules, and keeps a domain code' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-GADGET#4', 'ADR-WIDGET')) |
                Should -Be @('ADR-WIDGET', 'ADR-WIDGET-GADGET')
        }

        It 'orders the entries by code' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-GADGET#1', 'ADR-COG-BOLT#2', 'ADR-WIDGET-LONE#7')) |
                Should -Be @('ADR-COG-BOLT#2', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-LONE#7')
        }

        It 'returns nothing for no citations' {
            @($script:form::Minimize([string[]] @())).Count | Should -Be 0
        }

        It 'writes the bare code when every rule the registry declares is present' {
            $script:form::Minimize([string[]] @(1..5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" }), $script:registry) | Should -Be @('ADR-WIDGET-GADGET')
            $script:form::Minimize([string[]] @('ADR-WIDGET-SPROCKET#2', 'ADR-WIDGET-SPROCKET#1'), $script:registry) | Should -Be @('ADR-WIDGET-SPROCKET')
        }

        It 'writes the bare code for an ADR with a single rule when that rule is cited' {
            $script:form::Minimize([string[]] @('ADR-WIDGET-LONE#7'), $script:registry) | Should -Be @('ADR-WIDGET-LONE')
        }

        It 'keeps the numbers when a rule is missing, or when one is not in the registry' {
            $script:form::Minimize([string[]] @(1..4 | ForEach-Object { "ADR-WIDGET-GADGET#$_" }), $script:registry) | Should -Be @('ADR-WIDGET-GADGET#{1-4}')
            $script:form::Minimize([string[]] @(1..5 + 9 | ForEach-Object { "ADR-WIDGET-GADGET#$_" }), $script:registry) | Should -Be @('ADR-WIDGET-GADGET#{1-5,9}')
        }

        It 'never collapses a code the registry does not hold, nor without a registry' {
            $script:form::Minimize([string[]] @('ADR-NOPE-ONE#1'), $script:registry) | Should -Be @('ADR-NOPE-ONE#1')
            $script:form::Minimize([string[]] @(1..5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })) | Should -Be @('ADR-WIDGET-GADGET#{1-5}')
        }

        It 'rejects an input that is a group, a star, a glob, or no citation' -ForEach @(
            @{ Item = 'ADR-WIDGET-GADGET#{1,2}' }
            @{ Item = 'ADR-WIDGET-GADGET#*' }
            @{ Item = 'ADR-WIDGET-*' }
            @{ Item = 'ADR-WIDGET-GADGET#x' }
        ) {
            { $script:form::Minimize([string[]] @($Item)) } | Should -Throw
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
            $cited = [string[]] @($Rules | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
            $min = $script:form::Minimize($cited)
            $script:form::ExpandAll([string[]] @($min)) | Should -Be ($script:form::ExpandAll($cited))
        }

        It 'is idempotent: minimizing what Expand returned gives the same tokens' {
            $first = $script:form::Minimize([string[]] @('ADR-COG-BOLT#1', 'ADR-COG-BOLT#2', 'ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET#4'))
            $second = $script:form::Minimize([string[]] @($script:form::ExpandAll([string[]] @($first))))
            $second | Should -Be $first
        }

        It 'is never longer than the plain list' {
            $cited = [string[]] @(1..5 | ForEach-Object { "ADR-WIDGET-GADGET#$_" })
            $plain = ($cited -join ',').Length
            (($script:form::Minimize($cited)) -join ',').Length | Should -BeLessThan $plain
        }
    }
}
