function Resolve-BicepEnvironmentFacts {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepSlot] $Slot
    )

    $facts = [ordered]@{}
    if ($TemplateDescriptor.facts.Count -eq 0) {
        return $facts
    }
    $azure = Get-Config -Config azure
    $environments = $azure.environments
    if (-not $environments.ContainsKey($Slot.environment)) {
        throw "facts of template '$($TemplateDescriptor.name)': slot '$($Slot.name)' targets environment '$($Slot.environment)', which azure.yml does not declare"
    }
    $environment = $environments[$Slot.environment]
    foreach ($parameter in @($TemplateDescriptor.facts.Keys)) {
        $field = $TemplateDescriptor.facts[$parameter]
        if ($field -ceq 'module_resource_types') {
            # The types the shared modules declare, read at build time, so a new module's type needs no list edit.
            $facts[$parameter] = [string[]] @(Get-BicepModuleResourceTypes)
            continue
        }
        $facts[$parameter] = if ($field -cin 'policy_enforcement', 'subscription_production', 'groups') {
            # The subscription's class, not the slot environment's: a subscription that holds a production environment is production.
            if (-not $azure.subscriptions.ContainsKey($Slot.subscription)) {
                throw "facts of template '$($TemplateDescriptor.name)': slot '$($Slot.name)' targets subscription '$($Slot.subscription)', which azure.yml does not declare"
            }
            $production = @($azure.subscriptions[$Slot.subscription].environments | Where-Object {
                    $environments.ContainsKey($_) -and $environments[$_].production
                }).Count -gt 0
            if ($field -ceq 'subscription_production') {
                $production
            }
            else {
                $class = if ($production) {
                    'production'
                }
                else {
                    'nonproduction'
                }
                if ($field -ceq 'groups') {
                    # The slot's owner's groups in the subscription's class; a role with no group is empty, and the template assigns nothing to it.
                    $owner = if ($Slot.customer) {
                        $Slot.customer
                    }
                    else {
                        [Catzc.Azure.AzureConfig]::SharedGroupOwner
                    }
                    $set = if ($azure.groups.ContainsKey($owner) -and $azure.groups[$owner].ContainsKey($class)) {
                        $azure.groups[$owner][$class]
                    }
                    $groups = [ordered]@{}
                    foreach ($role in [Catzc.Azure.AzureGroupSet]::GroupRoles) {
                        $groups[$role] = if ($set) {
                            "$($set.$role)"
                        }
                        else {
                            ''
                        }
                    }
                    $groups
                }
                else {
                    $azure.policy_enforcement[$class]
                }
            }
        }
        else {
            $environment.$field
        }
    }
    $facts
}
