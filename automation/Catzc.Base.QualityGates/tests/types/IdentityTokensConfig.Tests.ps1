<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/IdentityTokensConfig.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/types/IdentityTokensConfig.cs
---
#>

Describe 'IdentityTokensConfig' -Tag 'L0', 'logic' {
    It 'maps each rule, defaulting take to value and match to exact' {
        $config = [Catzc.Base.QualityGates.IdentityTokensConfig]::new([ordered]@{
                tokens = @(
                    @{ config = 'widget'; path = 'owner'; kind = 'widget-owner'; suggest = 'a fixture owner' }
                    @{ config = 'widget'; path = 'gadgets.*.code'; take = 'value'; kind = 'gadget-code'; suggest = 'a fixture code'; match = 'position'; skip_when = 'shared' }
                    @{ config = 'widget'; path = 'gadgets'; take = 'keys'; kind = 'gadget'; suggest = 'a fixture gadget' }
                )
            })
        $config.tokens.Count | Should -Be 3
        $config.tokens[0].take | Should -Be 'value'
        $config.tokens[0].match | Should -Be 'exact'
        $config.tokens[0].skip_when | Should -BeNullOrEmpty
        @($config.tokens[1].path) | Should -Be @('gadgets', '*', 'code')
        $config.tokens[1].match | Should -Be 'position'
        $config.tokens[1].skip_when | Should -Be 'shared'
        $config.tokens[2].take | Should -Be 'keys'
    }

    It 'throws on <case>' -ForEach @(
        @{ case = 'an unknown top-level key'; data = @{ tokens = @(@{ config = 'widget'; path = 'owner'; kind = 'k'; suggest = 's' }); extra = 1 }; expected = "*unknown top-level key 'extra'*" }
        @{ case = 'no tokens'; data = @{ tokens = @() }; expected = "*non-empty 'tokens' list*" }
        @{ case = 'a rule without its required keys'; data = @{ tokens = @(@{ path = 'owner' }) }; expected = "*tokens``[0``]: 'config' is required*" }
        @{ case = 'an unknown rule key'; data = @{ tokens = @(@{ config = 'widget'; path = 'owner'; kind = 'k'; suggest = 's'; filter = 'x' }) }; expected = "*unknown key 'filter'*" }
        @{ case = 'a take that is not value or keys'; data = @{ tokens = @(@{ config = 'widget'; path = 'owner'; kind = 'k'; suggest = 's'; take = 'all' }) }; expected = "*take 'all' is not 'value' or 'keys'*" }
        @{ case = 'a match that is not exact or position'; data = @{ tokens = @(@{ config = 'widget'; path = 'owner'; kind = 'k'; suggest = 's'; match = 'fuzzy' }) }; expected = "*match 'fuzzy' is not 'exact' or 'position'*" }
        @{ case = 'a malformed path segment'; data = @{ tokens = @(@{ config = 'widget'; path = 'gadgets..code'; kind = 'k'; suggest = 's' }) }; expected = "*has segment ''*" }
    ) {
        { [Catzc.Base.QualityGates.IdentityTokensConfig]::new($data) } | Should -Throw $expected
    }

    It 'collects every rule violation into one throw' {
        $data = @{ tokens = @(@{ path = 'owner' }, @{ config = 'widget'; path = 'owner'; kind = 'k'; suggest = 's'; match = 'fuzzy' }) }
        $failure = { [Catzc.Base.QualityGates.IdentityTokensConfig]::new($data) } | Should -Throw -PassThru
        $failure.Exception.Message | Should -BeLike "*tokens``[0``]: 'config' is required*"
        $failure.Exception.Message | Should -BeLike "*tokens``[1``]: match 'fuzzy'*"
    }
}
