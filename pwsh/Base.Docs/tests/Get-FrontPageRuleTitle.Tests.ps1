Describe 'Get-FrontPageRuleTitle' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:record = Join-Path $TestDrive 'gadget.md'
        Set-Content -Path $script:record -Value @(
            '# WDR: Gadget record'
            ''
            '### Rule WDR-GADGET-SPIN'
            ''
            'A gadget spins.'
            ''
            '- [Spinning gadgets](#spinning-gadgets)'
            '- [Other](#other)'
            ''
            '### Rule WDR-GADGET-BARE'
            ''
            'A gadget rests.'
        )
    }

    It 'names the rule by the text of its first decision link' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Record = $script:record } {
            Get-FrontPageRuleTitle -RecordPath $Record -Anchor 'rule-wdr-gadget-spin' | Should -Be 'Spinning gadgets'
        }
    }

    It 'falls back to the record title when the rule has no decision link' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Record = $script:record } {
            Get-FrontPageRuleTitle -RecordPath $Record -Anchor 'rule-wdr-gadget-bare' | Should -Be 'Gadget record'
        }
    }

    It 'leaves the record unlocked after the fallback reads its title' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Record = $script:record } {
            Get-FrontPageRuleTitle -RecordPath $Record -Anchor 'rule-wdr-gadget-bare' | Out-Null
            { [System.IO.File]::Open($Record, 'Open', 'ReadWrite', 'None').Dispose() } | Should -Not -Throw
        }
    }

    It 'throws for an anchor the record has no rule for' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Record = $script:record } {
            { Get-FrontPageRuleTitle -RecordPath $Record -Anchor 'rule-wdr-gadget-none' } | Should -Throw '*no rule heading*'
        }
    }
}
