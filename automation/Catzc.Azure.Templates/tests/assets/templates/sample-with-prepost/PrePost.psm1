<#
.SYNOPSIS
    Per-template PrePost override for the 'sample-with-prepost' fixture.
.DESCRIPTION
    Overrides only Invoke-BicepPrepareParameterSet — the build-time merge seam. It exercises BOTH merge
    shapes a real PrePost hook performs, so the fixture covers them without binding any test to a
    production template:

      1. Value merge — main.bicep needs the vnet's address ranges, a cross-cutting fact owned globally in
         assets/network.yml (the IP plan), not a per-template value. configuration/<slot>.yml omits them;
         this hook resolves them for the deploy environment and writes them in as plain `{ value }`.

      2. Key Vault reference injection — `sharedReference`'s value must not live in the repo, so the hook
         injects an ARM Key Vault *reference* (not a value) the way the real templates' hooks wire passwords
         to their foundation Key Vault. The secret name is derived from the template's own short_name
         (mirroring production's `<short>-…` secrets), and the vault id is built from the resolved
         subscription — both FIXTURE-derived, so a test asserts them against the fixture, never a hardcoded
         production literal.

    The two deploy hooks are not exported, so they fall through to no-ops.

    See docs/adr/automation/prepost-extension-modules.md.
#>
function Invoke-BicepPrepareParameterSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $BuildInvocation,
        [Parameter(Mandatory)] $TemplateDescriptor,
        [Parameter(Mandatory)] $ConfigurationDescriptor
    )

    $network = (Get-Config -Config network).environments[$BuildInvocation.Environment]
    $parameters = $ConfigurationDescriptor.ParametersFile.parameters

    if (-not $parameters.Contains('addressPrefix')) {
        $parameters['addressPrefix'] = @{ value = $network.vnet_address_space }
    }
    if (-not $parameters.Contains('subnetPrefix')) {
        $parameters['subnetPrefix'] = @{ value = $network.default_subnet }
    }

    # Inject an ARM Key Vault reference for the KV-backed parameter. Derive the secret name from the
    # template's short_name and the vault id from the resolved subscription — fixture identities only.
    if (-not $parameters.Contains('sharedReference')) {
        $sub = Get-AzureSubscription -Subscription $BuildInvocation.Subscription
        $short = $TemplateDescriptor.short_name
        $vaultName = "$short-kv"
        $vaultId = "/subscriptions/$($sub.id)/resourceGroups/$short-rg/providers/Microsoft.KeyVault/vaults/$vaultName"
        $parameters['sharedReference'] = [ordered]@{
            reference = [ordered]@{
                keyVault   = [ordered]@{ id = $vaultId }
                secretName = "$short-shared-secret"
            }
        }
    }

    $ConfigurationDescriptor
}
