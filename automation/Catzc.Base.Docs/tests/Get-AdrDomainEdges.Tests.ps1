# Get-AdrDomainEdges over a fixture AdrsConfig (Get-Config mocked): the registry's own construction holds the
# edge invariants (declared ends, no self-edge, acyclic), so this pins only the projection. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-AdrDomainEdges' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        rulesets = [ordered]@{ 'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' } }
                    }
                    gizmo  = [ordered]@{
                        code = 'GI'; role = 'reference'; description = 'The gizmo reference.'; depends_on = @('widget', 'gadget')
                        rulesets = [ordered]@{ 'gizmo-one' = [ordered]@{ external = 'ADR-GI-ONE' } }
                    }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
    }

    It 'returns one typed edge per depends_on link, in declaration order' {
        $edges = Get-AdrDomainEdges
        $edges | Should -HaveCount 3
        $edges[0] | Should -BeOfType 'Catzc.Base.Docs.AdrDomainEdge'
        @($edges | ForEach-Object { "$($_.From)->$($_.To)" }) | Should -Be @('gadget->widget', 'gizmo->widget', 'gizmo->gadget')
    }

    It 'returns no edges for a registry with no dependency links' {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                }
            })
        @(Get-AdrDomainEdges) | Should -HaveCount 0
    }
}
