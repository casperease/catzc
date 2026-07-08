# Integrity — it reads the real tests/assets/config fixtures to derive the fixture-identity set.
Describe 'Get-FixtureIdentityTokens' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:tokens = & (Get-Module Catzc.Base.QualityGates) { Get-FixtureIdentityTokens }
    }

    It 'derives the fixture identities from the tests/assets/config fixtures' {
        $script:tokens | Should -Contain 'acme'
        $script:tokens | Should -Contain 'globex'
        $script:tokens | Should -Contain 'alpha'
        $script:tokens | Should -Contain 'tst'
        $script:tokens | Should -Contain 'core_lower'
    }

    It 'includes the neutral in-memory fixtures (globset / tool)' {
        $script:tokens | Should -Contain 'widget'
        $script:tokens | Should -Contain 'gadget'
        $script:tokens | Should -Contain 'faketool'
    }

    It 'excludes the shared structural nsub/psub identity envs' {
        $script:tokens | Should -Not -Contain 'nsub'
        $script:tokens | Should -Not -Contain 'psub'
    }

    It 'does NOT include any live identity (the sets are disjoint)' {
        $script:tokens | Should -Not -Contain 'apex'
        $script:tokens | Should -Not -Contain 'nova'
        $script:tokens | Should -Not -Contain 'zct'
    }
}
