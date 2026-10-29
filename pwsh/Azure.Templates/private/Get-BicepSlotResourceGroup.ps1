function Get-BicepSlotResourceGroup {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The template descriptor Get-BicepTemplate returns, of a ResourceGroup-target template.
        [Parameter(Mandatory)]
        [object] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [string] $Environment,

        [string] $Slot,

        [string] $Customer
    )

    $slotMatch = Resolve-BicepSlot -TemplateDescriptor $TemplateDescriptor -Environment $Environment -Slot $Slot -Customer $Customer
    if (-not $slotMatch) {
        throw "Template '$($TemplateDescriptor.name)' has no slot '$(Get-BicepConfigName $Environment $Slot)'$(if ($Customer) { " for customer '$Customer'" }), so it has no declared resource group"
    }
    $configuration = Get-BicepTemplateConfiguration $TemplateDescriptor.name $Environment -Slot $Slot -Customer $Customer
    $declaringFile = if ($configuration.Contains('BicepParamFile')) {
        [System.IO.Path]::ChangeExtension($configuration.BicepParamFile, '.yml')
    }
    else {
        $slotMatch.file
    }
    if (-not $configuration.Contains('ResourceGroup') -or [string]::IsNullOrWhiteSpace("$($configuration.ResourceGroup)")) {
        throw "Template '$($TemplateDescriptor.name)' is ResourceGroup-target but its config '$declaringFile' declares no top-level 'ResourceGroup' key — add 'ResourceGroup: <name>' (ADR-AZ-DATAMOD-DECLAREDGROUPNAME)"
    }
    $resourceGroup = "$($configuration.ResourceGroup)"
    if ($slotMatch -notin @($TemplateDescriptor.slots)) {
        $resourceGroup = (Resolve-BicepRuntimeSlotNames -TemplateDescriptor $TemplateDescriptor -Parameters ([ordered]@{}) -ResourceGroup $resourceGroup -Environment $Environment -Customer $Customer -RuntimeSlot $Slot).ResourceGroup
    }
    $resourceGroup
}
