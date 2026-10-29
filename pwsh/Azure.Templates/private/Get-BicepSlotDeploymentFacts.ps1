function Get-BicepSlotDeploymentFacts {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        # The template descriptor Get-BicepTemplate returns: its name and deployment_target.
        [Parameter(Mandatory)]
        [object] $Template,

        # One of the descriptor's slots: its environment, slot, customer and subscription.
        [Parameter(Mandatory)]
        [object] $Slot
    )

    $azure = Get-Config -Config azure
    $facts = @{ Location = ''; SubscriptionId = ''; ResourceGroupName = '' }
    if ($azure.environments.ContainsKey($Slot.environment)) {
        $facts.Location = "$($azure.environments[$Slot.environment].region)"
    }
    if ($Slot.subscription -and $azure.subscriptions.ContainsKey($Slot.subscription)) {
        $facts.SubscriptionId = "$($azure.subscriptions[$Slot.subscription].id)"
    }
    if ($Template.deployment_target -eq 'ResourceGroup') {
        $facts.ResourceGroupName = Get-BicepSlotResourceGroup -TemplateDescriptor $Template -Environment $Slot.environment -Slot $Slot.slot -Customer $Slot.customer
    }
    $facts
}
