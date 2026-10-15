<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
    kind: test
---
#>

# Test-ManagedGuids over a mocked scan, registry, and 'repository' globset, so each test pins one rule. Neutral
# fixture names and test-shaped guids ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-ManagedGuids' -Tag 'L0', 'logic' {
    BeforeAll {
        # Built at runtime, so the real guid scan never reads these fixture values as unregistered guids.
        $prefix = 'a100a000-7e57-7e0a-0700-00000000000'
        $script:widgetGuid = $prefix + '1'
        $script:gadgetGuid = $prefix + '2'
        $script:deniedGuid = $prefix + '9'
        $script:strayGuid = $prefix + '3'
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-GuidScanFiles -ModuleName Catzc.Base.QualityGates { @('docs/widget.md', 'docs/gadget.md') }
        Mock Get-GlobSetFile -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'repository' } {
            @('docs/widget.md', 'docs/gadget.md', 'automation/Catzc.Base.QualityGates/configs/guids.yml')
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'guids' } {
            [pscustomobject]@{
                guids  = [ordered]@{
                    widget = [pscustomobject]@{ guid = $widgetGuid }
                    gadget = [pscustomobject]@{ guid = $gadgetGuid }
                }
                denied = [ordered]@{ empty = [pscustomobject]@{ guid = $deniedGuid } }
            }
        }
        Mock Get-RepositoryGuids -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ file = 'docs/widget.md'; line = 1; guid = $widgetGuid }
            [pscustomobject]@{ file = 'docs/gadget.md'; line = 4; guid = $gadgetGuid }
        }
    }

    It 'passes when every scanned guid is registered and every entry is live' {
        $result = Test-ManagedGuids -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Registered | Should -Be 2
        $result.Occurrences | Should -Be 2
    }

    It 'throws once naming an uncovered file, a denied and an unregistered guid, and a dead entry' {
        Mock Get-GuidScanFiles -ModuleName Catzc.Base.QualityGates { @('docs/widget.md', 'docs/gadget.md', 'docs/sprocket.md') }
        Mock Get-RepositoryGuids -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ file = 'docs/widget.md'; line = 1; guid = $widgetGuid }
            [pscustomobject]@{ file = 'docs/widget.md'; line = 2; guid = $deniedGuid }
            [pscustomobject]@{ file = 'docs/sprocket.md'; line = 3; guid = $strayGuid }
        }
        $thrown = { Test-ManagedGuids -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ManagedGuids failed: 4 issue(s)*'
        $message | Should -Match "docs/sprocket.md: read by the guid scan but outside the 'repository' globset"
        $message | Should -Match "docs/widget.md:2 $deniedGuid`: a denied guid"
        $message | Should -Match "docs/sprocket.md:3 $strayGuid`: not registered"
        $message | Should -Match 'guids.yml gadget: no tracked file references it'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-RepositoryGuids -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ file = 'docs/widget.md'; line = 1; guid = $widgetGuid }
        }
        $result = Test-ManagedGuids -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'managed-guids'
        $result.Issues | Should -HaveCount 1
    }
}
