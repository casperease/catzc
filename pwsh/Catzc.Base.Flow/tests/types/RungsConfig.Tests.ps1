<#
---
catzc:
  immutable:
    with_body_sha: "39d3cec34ce2"
  edges:
    code: pwsh/Catzc.Base.Flow/types/RungsConfig.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - FDR-CD-PREPRODRUNG
      - FDR-CD-RUNGSREGISTRY
      - FDR-CD-CERTIFYINGRECORD
---
#>

Describe 'RungsConfig declared ladder' -Tag 'L1', 'integrity' {
    It 'takes the declared ladder for an omitted key, in climbing order' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.Flow.RungsConfig]::new(@{})
        $config.rungs.name | Should -Be @('main-uat', 'release-uat', 'pre-prod', 'prod')
        $config.rungs.environment | Should -Be @('dev', 'test', 'preprod', 'prod')
        $config.rungs.gate | Should -Be @('none', 'rc', 'rbc', 'prod-approval')
        $config.rungs[2].rules | Should -Be @('FDR-CD-PREPRODRUNG', 'FDR-CD-CERTIFYINGRECORD')
    }
}

Describe 'RungsConfig' -Tag 'L0', 'logic' {
    It 'reads the rule codes that define a rung, and none when it lists none' -Tag 'FDR-CD-RUNGSREGISTRY' {
        $config = [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{
                    'widget-uat' = @{ environment = 'widget'; gate = 'none'; rules = @('ADR-WIDGET-GADGET-SPIN') }
                    'gadget-uat' = @{ environment = 'gadget'; gate = 'rc' }
                }
            })
        $config.rungs[0].rules | Should -Be @('ADR-WIDGET-GADGET-SPIN')
        $config.rungs[1].rules | Should -HaveCount 0
    }

    It 'rejects rules that are not a list of ADR rule codes' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = @{ environment = 'widget'; gate = 'none'; rules = 'ADR-WIDGET' } } }) } |
            Should -Throw '*rules must be a list of ADR rule codes*'
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = @{ environment = 'widget'; gate = 'none'; rules = @('gizmo') } } }) } |
            Should -Throw '*''gizmo'' is not an ADR rule code*'
    }

    It 'takes the ladder from a comment-only file as well' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.Flow.RungsConfig]::new($null)).rungs | Should -HaveCount 4
    }

    It 'maps a ladder it is given, keeping its order' -Tag 'FDR-CD-RUNGSREGISTRY' {
        $config = [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{
                    'widget-uat' = @{ environment = 'widget'; gate = 'none' }
                    'gadget-uat' = @{ environment = 'gadget'; gate = 'rc' }
                }
            })
        $config.rungs.name | Should -Be @('widget-uat', 'gadget-uat')
        $config.rungs[1].environment | Should -Be 'gadget'
    }

    It 'selects the rungs behind given gates, in climbing order' -Tag 'FDR-CD-RUNGSREGISTRY' {
        ([Catzc.Base.Flow.RungsConfig]::new(@{})).GatedBy('rc', 'rbc').name | Should -Be @('release-uat', 'pre-prod')
    }

    It 'rejects an unknown top-level key, naming the allowed set' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key ''gadget''*rungs*'
    }

    It 'rejects an empty ladder or one that is not a map' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{} }) } | Should -Throw '*non-empty map*'
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @('widget') }) } | Should -Throw '*non-empty map*'
    }

    It 'rejects a rung that is not kebab-case, is not a map, or has an unknown key' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ Widget_Uat = @{ environment = 'widget'; gate = 'none' } } }) } | Should -Throw '*not kebab-case*'
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = 'widget' } }) } | Should -Throw '*must be a map*'
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = @{ environment = 'widget'; gate = 'none'; gizmo = 1 } } }) } | Should -Throw '*unknown key ''gizmo''*'
    }

    It 'rejects a rung without an environment, or two rungs on one environment' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = @{ gate = 'none' } } }) } | Should -Throw '*names no environment*'
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{
                        'widget-uat' = @{ environment = 'widget'; gate = 'none' }
                        'gadget-uat' = @{ environment = 'widget'; gate = 'rc' }
                    }
                }) } | Should -Throw '*''widget'', which another rung maps to*'
    }

    It 'rejects a gate outside the closed set, naming the gates' {
        { [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = @{ 'widget-uat' = @{ environment = 'widget'; gate = 'gizmo' } } }) } |
            Should -Throw '*gate ''gizmo'' is not one of: none, rc, rbc, prod-approval*'
    }
}

Describe 'RungsConfig (shipped rungs.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped rungs.yml as a RungsConfig' -Tag 'FDR-CD-RUNGSREGISTRY' {
        (Get-Config -Config rungs) | Should -BeOfType ([Catzc.Base.Flow.RungsConfig])
    }
}
