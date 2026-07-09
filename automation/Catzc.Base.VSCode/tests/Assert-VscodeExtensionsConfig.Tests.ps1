# Assert-VscodeExtensionsConfig is private, so it is exercised through the module (ADR-AUTO-PESTER:4).
Describe 'Assert-VscodeExtensionsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.VSCode -Parameters @{ C = $Config } { param($C) Assert-VscodeExtensionsConfig -Config $C }
        }
    }

    It 'accepts a well-formed registry' {
        { & $script:assert ([ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') }) } | Should -Not -Throw
    }

    It 'throws when recommendations is missing or empty' {
        { & $script:assert ([ordered]@{}) } | Should -Throw '*non-empty list*'
        { & $script:assert ([ordered]@{ recommendations = @() }) } | Should -Throw '*non-empty list*'
    }

    It 'throws on an id that is not publisher.name' {
        { & $script:assert ([ordered]@{ recommendations = @('no-dot-here') }) } | Should -Throw '*not a publisher.name*'
    }

    It 'throws on a duplicate id, collecting every violation' {
        { & $script:assert ([ordered]@{ recommendations = @('acme.tool', 'acme.tool', 'bad id') }) } |
            Should -Throw '*duplicate recommendation*'
    }
}
