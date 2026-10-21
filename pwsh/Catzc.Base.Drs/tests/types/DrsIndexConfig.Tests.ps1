<#
---
catzc:
  immutable:
    with_body_sha: f89ed2373a03
  edges:
    code: pwsh/Catzc.Base.Drs/types/DrsIndexConfig.cs
    cites:
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'DrsIndexConfig' -Tag 'L0', 'logic', 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
    It 'holds the preamble and the conventions as written' {
        $config = [Catzc.Base.Drs.DrsIndexConfig]::new([ordered]@{ preamble = "# Widget index`n"; conventions = "## Gadget rules`n" })
        $config.preamble | Should -BeExactly "# Widget index`n"
        $config.conventions | Should -BeExactly "## Gadget rules`n"
    }

    It 'rejects <Name>' -ForEach @(
        @{ Name = 'no configuration'; Raw = $null; Message = '*must be a mapping*' }
        @{ Name = 'a missing preamble'; Raw = @{ conventions = 'x' }; Message = '*preamble is required*' }
        @{ Name = 'a blank conventions text'; Raw = @{ preamble = 'x'; conventions = ' ' }; Message = '*conventions is required*' }
        @{ Name = 'an unknown key'; Raw = @{ preamble = 'x'; conventions = 'y'; widget = 1 }; Message = '*unknown key ''widget''*' }
    ) {
        { [Catzc.Base.Drs.DrsIndexConfig]::new($Raw) } | Should -Throw $Message
    }

    It 'loads the shipped drs-index.yml' -Tag 'L1' {
        $config = Get-Config -Config drs-index
        $config.preamble | Should -BeLike '# ADR index and rule-citation registry*'
        $config.conventions | Should -BeLike '## Authoring conventions*'
    }
}
