<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
    kind: test
---
#>

Describe 'Resolve-BicepParameterAddresses' -Tag 'L0', 'logic' {
    BeforeAll {
        # Invoke the private function in the module's scope; the config reader is mocked at its boundary with neutral
        # widget/gadget addresses ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
        $script:resolve = {
            param([System.Collections.IDictionary] $parameters)
            & (Get-Module Catzc.Azure.Templates) {
                param($p)
                Resolve-BicepParameterAddresses -Parameters $p -ConfigFile 'configuration/alpha.yml'
            } $parameters
        }
        Mock Get-ConfigValue -ModuleName Catzc.Azure.Templates -MockWith {
            switch ($Address) {
                'global.widget.gadget.mode' {
                    'Spin'
                }
                'global.widget.gadget' {
                    [ordered]@{ mode = 'Spin'; size = 3 }
                }
                default {
                    throw "Config address '$Address': key 'missing' does not exist in the config node."
                }
            }
        }
    }

    It 'resolves an address into a value entry' -Tag 'ADR-AZ-DATAMOD#10' {
        $resolved = & $script:resolve ([ordered]@{ gadgetMode = [ordered]@{ address = 'global.widget.gadget.mode' } })
        $resolved.gadgetMode.value | Should -Be 'Spin'
        $resolved.gadgetMode.Contains('address') | Should -BeFalse
    }

    It 'resolves an address to a subtree into an object value' -Tag 'ADR-AZ-DATAMOD#10' {
        $resolved = & $script:resolve ([ordered]@{ gadget = [ordered]@{ address = 'global.widget.gadget' } })
        $resolved.gadget.value.size | Should -Be 3
    }

    It 'passes value and reference entries through unchanged, in order' {
        $reference = [ordered]@{ keyVault = [ordered]@{ id = '/subscriptions/x/providers/Microsoft.KeyVault/vaults/widget' }; secretName = 'gadget' }
        $resolved = & $script:resolve ([ordered]@{
                widgetName = [ordered]@{ value = 'widget' }
                gadgetMode = [ordered]@{ address = 'global.widget.gadget.mode' }
                widgetKey  = [ordered]@{ reference = $reference }
            })
        @($resolved.Keys) | Should -Be @('widgetName', 'gadgetMode', 'widgetKey')
        $resolved.widgetName.value | Should -Be 'widget'
        $resolved.widgetKey.reference.secretName | Should -Be 'gadget'
    }

    It 'throws on an unknown address, naming the config file and the parameter' -Tag 'ADR-AZ-DATAMOD#10' {
        $err = { & $script:resolve ([ordered]@{ gadgetMode = [ordered]@{ address = 'global.widget.missing' } }) } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*Template config 'configuration/alpha.yml'*"
        $err.Exception.Message | Should -BeLike "*parameter 'gadgetMode' has address 'global.widget.missing', which does not resolve*"
    }

    It 'throws on an address mixed with a value' -Tag 'ADR-AZ-DATAMOD#10' {
        $err = { & $script:resolve ([ordered]@{ gadgetMode = [ordered]@{ address = 'global.widget.gadget.mode'; value = 'Spin' } }) } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*configuration/alpha.yml*parameter 'gadgetMode' sets 'address' together with 'value'*"
    }

    It 'throws on an address mixed with a Key Vault reference' -Tag 'ADR-AZ-DATAMOD#10' {
        $reference = [ordered]@{ keyVault = [ordered]@{ id = '/subscriptions/x/providers/Microsoft.KeyVault/vaults/widget' }; secretName = 'gadget' }
        $err = { & $script:resolve ([ordered]@{ widgetKey = [ordered]@{ address = 'global.widget.gadget.mode'; reference = $reference } }) } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*configuration/alpha.yml*parameter 'widgetKey' sets 'address' together with 'reference'*"
    }

    It 'throws on an address that is not a string' -Tag 'ADR-AZ-DATAMOD#10' {
        { & $script:resolve ([ordered]@{ gadgetMode = [ordered]@{ address = 3 } }) } | Should -Throw "*parameter 'gadgetMode' has an 'address' that is not a global config address string*"
    }

    It 'reports every violation in one throw' {
        $err = { & $script:resolve ([ordered]@{
                    gadgetMode = [ordered]@{ address = 'global.widget.missing' }
                    widgetName = [ordered]@{ address = 'global.widget.gadget.mode'; value = 'widget' }
                }) } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*parameter 'gadgetMode'*"
        $err.Exception.Message | Should -BeLike "*parameter 'widgetName'*"
    }
}

Describe 'Resolve-BicepParameterAddresses (through the config reader)' -Tag 'L0', 'logic' {
    BeforeAll {
        # The real Get-ConfigValue over the module's test identity fixture (tests/assets/config/azure.yml, org 'tst').
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Get-Config -Config azure | Out-Null
        $script:resolve = {
            param([System.Collections.IDictionary] $parameters)
            & (Get-Module Catzc.Azure.Templates) {
                param($p)
                Resolve-BicepParameterAddresses -Parameters $p -ConfigFile 'configuration/alpha.yml'
            } $parameters
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves a leaf of a typed config' -Tag 'ADR-AZ-DATAMOD#10' {
        (& $script:resolve ([ordered]@{ org = [ordered]@{ address = 'global.azure.org' } })).org.value | Should -Be 'tst'
    }

    It 'resolves the defaulted policy enforcement mode the config file omits' -Tag 'ADR-AZ-DATAMOD#10', 'ADR-AZ-DATAMOD#11' {
        $resolved = & $script:resolve ([ordered]@{ enforcementMode = [ordered]@{ address = 'global.azure.policy_enforcement.nonproduction' } })
        $resolved.enforcementMode.value | Should -Be 'DoNotEnforce'
    }

    It 'throws on a key the config does not have' -Tag 'ADR-AZ-DATAMOD#10' {
        { & $script:resolve ([ordered]@{ org = [ordered]@{ address = 'global.azure.missing' } }) } | Should -Throw "*parameter 'org' has address 'global.azure.missing', which does not resolve*"
    }

    It 'throws on a malformed address' -Tag 'ADR-AZ-DATAMOD#10' {
        { & $script:resolve ([ordered]@{ org = [ordered]@{ address = 'azure.org' } }) } | Should -Throw "*parameter 'org' has address 'azure.org', which does not resolve*"
    }
}
