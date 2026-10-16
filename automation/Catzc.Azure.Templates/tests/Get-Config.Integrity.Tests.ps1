<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1
    folder: tests
    name: get-config-integrity-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Get-Config.Integrity.Tests.ps1.md
---
#>

Describe 'Shipped asset integrity' -Tag 'L0', 'integrity' {

    It 'the shipped azure.yml loads and passes its AzureConfig type' {
        # Get-Config constructs the type on load, so a bad file throws here.
        { Get-Config -Config azure } | Should -Not -Throw
    }

    It 'the shipped network.yml loads and passes its NetworkConfig type' {
        { Get-Config -Config network } | Should -Not -Throw
    }

    It 'every shipped template references only defined environments and customers' {
        $azure = Get-Config -Config azure
        $envs = @($azure.environments.Keys)

        $violations = foreach ($t in (Get-BicepTemplates)) {
            foreach ($slot in $t.slots) {
                if ($slot.environment -notin $envs) {
                    "template '$($t.name)' config '$($slot.name)': environment '$($slot.environment)' is not defined in azure.yml"
                }
                if (-not [string]::IsNullOrEmpty($slot.customer)) {
                    try {
                        $null = Get-AzureCustomer $slot.customer
                    }
                    catch {
                        "template '$($t.name)' config '$($slot.name)': customer '$($slot.customer)' is not defined in customer.yml ($_)"
                    }
                }
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}
