# Reads the repository's own test files — the same answer in both run modes, so the build suite skips it.
Describe 'Get-CatsRuleEnforcers integrity' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:enforcers = InModuleScope Catzc.Base.Docs { Get-CatsRuleEnforcers }
    }

    It 'credits an analyzer rule from the shipped analyzer-adr-map' {
        $script:enforcers['ADR-AUTO-NOPWD#1'].Analyzers | Should -Contain 'Measure-NeverDependOnPwd'
    }

    It 'credits a tagged test, read from the tree by its -Tag citation' {
        # ADR-AUTO-TEST#27 is cited as a -Tag by the provenance tests, so those files enforce it.
        $script:enforcers.ContainsKey('ADR-AUTO-TEST#27') | Should -BeTrue
        ($script:enforcers['ADR-AUTO-TEST#27'].Tests -join ';') | Should -Match 'Get-TestRuleTags\.Tests\.ps1'
    }

    It 'ignores a citation-shaped string that is not a -Tag (AST, not text scan)' {
        # 'ADR-AUTO-ERROR#999' appears only as fixture DATA inside a test body (never as a -Tag), and is not a real
        # rule — so a precise AST reader must not surface it as an enforced citation.
        $script:enforcers.ContainsKey('ADR-AUTO-ERROR#999') | Should -BeFalse
    }
}

Describe 'Get-CatsRuleEnforcers source-tree guard' -Tag 'L0', 'logic' {
    It 'refuses before reading anything when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'widget operates on the catzc source tree' }
        Mock Get-Config -ModuleName Catzc.Base.Docs { }
        { InModuleScope Catzc.Base.Docs { Get-CatsRuleEnforcers } } | Should -Throw '*source tree*'
        Should -Invoke Get-Config -ModuleName Catzc.Base.Docs -Times 0
    }
}
