<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
    folder: tests
    name: get-adr-domain-edges-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-AdrDomainEdges' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' } }
                    }
                    gizmo  = [ordered]@{
                        code = 'GI'; role = 'reference'; description = 'The gizmo reference.'; depends_on = @('widget', 'gadget')
                        stack = 'CLOUD'; concern = @('deploy')
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
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                }
            })
        @(Get-AdrDomainEdges) | Should -HaveCount 0
    }
}
