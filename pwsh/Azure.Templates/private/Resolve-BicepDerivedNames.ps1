function Resolve-BicepDerivedNames {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepSlot] $Slot,

        # The slot's own parameters, which hold an each entry's items (their subscriptions); empty when the template has no each entry.
        [System.Collections.IDictionary] $SlotParameters = @{}
    )

    $derived = [ordered]@{}
    foreach ($parameter in @($TemplateDescriptor.names.Keys)) {
        $entry = $TemplateDescriptor.names[$parameter]
        if ($entry.each) {
            # Each item names another slot of this template by its subscription; a field renders from that slot (item) or this one (self).
            if (-not $SlotParameters.Contains($parameter)) {
                continue
            }
            $raw = $SlotParameters[$parameter].value
            $single = $raw -is [System.Collections.IDictionary]
            $entries = @(if ($single) {
                    , $raw
                }
                else {
                    $raw
                })
            $items = foreach ($item in $entries) {
                $itemSlot = @($TemplateDescriptor.slots | Where-Object subscription -EQ $item[$entry.each]) | Select-Object -First 1
                if (-not $itemSlot) {
                    throw "names.${parameter} of template '$($TemplateDescriptor.name)': slot '$($Slot.name)' names $($entry.each) '$($item[$entry.each])', which no slot of the template serves"
                }
                $filled = [ordered]@{ $entry.each = $item[$entry.each] }
                foreach ($field in @($entry.item_names.Keys)) {
                    if ($item.Contains($field)) {
                        throw "Slot '$($Slot.name)' of template '$($TemplateDescriptor.name)' writes $parameter.$field, a name the namer derives (options.yml names): delete it from the slot"
                    }
                    $name = $entry.item_names[$field]
                    $render = if ($name.from -eq 'self') {
                        $Slot
                    }
                    else {
                        $itemSlot
                    }
                    $itemSplat = @{ Template = $TemplateDescriptor.name; Environment = $render.environment; Type = $name.type }
                    if ($render.customer) {
                        $itemSplat['Customer'] = $render.customer
                    }
                    if ($name.role) {
                        $itemSplat['Role'] = $name.role
                    }
                    elseif ($name.role_from -eq 'customer_shortcode') {
                        $itemSplat['Role'] = (Get-AzureCustomer $itemSlot.customer).shortcode
                    }
                    $filled[$field] = Get-BicepResourceName @itemSplat
                }
                $filled
            }
            # Assigned apart, not from an if expression, which would unroll a one-item list into the item itself.
            if ($single) {
                $derived[$parameter] = $items | Select-Object -First 1
            }
            else {
                $derived[$parameter] = [object[]] @($items)
            }
            continue
        }
        $splat = @{ Type = $entry.type }
        if ($entry.role) {
            $splat['Role'] = $entry.role
        }
        if (-not $entry.template -or $entry.template -eq $TemplateDescriptor.name) {
            $splat['Template'] = $TemplateDescriptor.name
            $splat['Environment'] = $Slot.environment
            if ($Slot.slot) {
                $splat['Slot'] = $Slot.slot
            }
            if ($Slot.customer) {
                $splat['Customer'] = $Slot.customer
            }
        }
        else {
            # Another template's resource: its slot on this slot's subscription, or the hub that slot peers to.
            $owner = Get-BicepTemplate $entry.template
            $ownerSlot = @($owner.slots | Where-Object subscription -EQ $Slot.subscription) | Select-Object -First 1
            if (-not $ownerSlot) {
                throw "names.${parameter} of template '$($TemplateDescriptor.name)': template '$($entry.template)' has no slot on subscription '$($Slot.subscription)' (slot '$($Slot.name)')"
            }
            if ($entry.owner_slot -eq 'hub') {
                $ownerParameters = (Get-Content $ownerSlot.file -Raw | ConvertFrom-Yaml).ParametersFile.parameters
                if ($ownerParameters.Contains('hub')) {
                    $hubSubscription = $ownerParameters.hub.value.subscription
                    $ownerSlot = @($owner.slots | Where-Object subscription -EQ $hubSubscription) | Select-Object -First 1
                    if (-not $ownerSlot) {
                        throw "names.${parameter} of template '$($TemplateDescriptor.name)': template '$($entry.template)' has no slot on hub subscription '$hubSubscription'"
                    }
                }
            }
            $splat['Template'] = $owner.name
            $splat['Environment'] = $ownerSlot.environment
            if ($ownerSlot.customer) {
                $splat['Customer'] = $ownerSlot.customer
            }
        }
        if ($entry.roles.Count -eq 0) {
            $derived[$parameter] = Get-BicepResourceName @splat
            continue
        }
        # A roles entry is an object: one name per key, each with its key's role; nsg_subnets keys it by the slot's subnets that take an NSG.
        $keys = @(if ($entry.keys_from -eq 'nsg_subnets') {
                $network = Get-Config -Config network
                $subnets = $network.subscriptions[$Slot.subscription].subnets
                $subnets.Keys | Where-Object { $_ -notin $network.no_nsg_subnets }
            }
            else {
                $entry.roles.Keys
            })
        $object = [ordered]@{}
        foreach ($key in $keys) {
            if (-not $entry.roles.ContainsKey($key)) {
                throw "names.${parameter} of template '$($TemplateDescriptor.name)': key '$key' of slot '$($Slot.name)' has no role in roles"
            }
            $object[$key] = Get-BicepResourceName @splat -Role $entry.roles[$key]
        }
        $derived[$parameter] = $object
    }
    $derived
}
