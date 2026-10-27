Set-StrictMode -Version Latest

<#
.SYNOPSIS
    foundation's PrePost hook: chooses the subnet the Key Vault's private endpoint takes its address from; options.yml names derives every name.
.DESCRIPTION
    Overrides only Invoke-BicepPrepareParameterSet. The endpoint's names (its own, the network's resource group and virtual network, the
    hub's DNS zone resource group) come from options.yml names, and the hub's subscription id from the slot's config address; the one choice
    left here is the subnet, which depends on the kind of the slot's network: a spoke's private-endpoints subnet, a hub's shared-services
    subnet. A value the slot's yml sets wins. The bootstrap pass, deployed before discovery has built the network, sets
    deployKeyVaultPrivateEndpoint to false in the slot's yml, and the template then deploys no endpoint.

    See docs/drs/automation/pwsh/prepost-extension-modules.md.
#>
function Invoke-BicepPrepareParameterSet {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'TemplateDescriptor',
        Justification = 'Build-Bicep calls every hook with the fixed PrePost signature; this hook chooses the subnet from the invocation alone.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $BuildInvocation,
        [Parameter(Mandatory)] $TemplateDescriptor,
        [Parameter(Mandatory)] $ConfigurationDescriptor
    )

    $parameters = $ConfigurationDescriptor.ParametersFile.parameters
    if (-not $parameters.Contains('privateEndpointSubnetName')) {
        $kind = (Get-Config -Config network).subscriptions[$BuildInvocation.Subscription].kind
        $subnet = if ($kind -eq 'hub') {
            'shared-services'
        }
        else {
            'private-endpoints'
        }
        $parameters['privateEndpointSubnetName'] = [ordered]@{ value = $subnet }
    }
    $ConfigurationDescriptor
}

Export-ModuleMember -Function Invoke-BicepPrepareParameterSet
