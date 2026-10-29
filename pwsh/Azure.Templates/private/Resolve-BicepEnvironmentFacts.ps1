function Resolve-BicepEnvironmentFacts {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Parameters,

        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepSlot] $Slot,

        [Parameter(Mandatory)]
        [string] $ConfigFile
    )

    $resolved = [ordered]@{}
    $facts = [ordered]@{}
    $violations = [System.Collections.Generic.List[string]]::new()
    $fields = @([Catzc.Azure.AzureEnvironmentRecord].GetProperties() | Where-Object PropertyType -EQ ([bool]) | ForEach-Object Name) + 'policy_enforcement', 'subscription_production', 'groups', 'module_resource_types'

    foreach ($name in @($Parameters.Keys)) {
        $entry = $Parameters[$name]
        $resolved[$name] = $entry
        if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('fact')) {
            continue
        }

        $otherKeys = @(foreach ($key in $entry.Keys) {
                if ($key -ne 'fact') {
                    $key
                }
            })
        if ($otherKeys.Count -gt 0) {
            $violations.Add("parameter '$name' sets 'fact' together with '$($otherKeys -join "', '")' — a fact parameter sets 'fact' alone")
            continue
        }

        $field = $entry['fact']
        if ($field -isnot [string] -or $field -cnotin $fields) {
            $violations.Add("parameter '$name' names fact '$field', which is not a known field (valid: $($fields -join ', '))")
            continue
        }
        $facts[$name] = $field
    }

    if ($violations.Count -gt 0) {
        throw "Template config '$ConfigFile' has invalid fact parameters:`n  - $($violations -join "`n  - ")"
    }
    if ($facts.Count -eq 0) {
        return $resolved
    }

    $azure = Get-Config -Config azure
    $environments = $azure.environments
    if (-not $environments.ContainsKey($Slot.environment)) {
        throw "Template config '$ConfigFile': slot '$($Slot.name)' targets environment '$($Slot.environment)', which azure.yml does not declare"
    }
    $environment = $environments[$Slot.environment]
    foreach ($parameter in @($facts.Keys)) {
        $field = $facts[$parameter]
        if ($field -ceq 'module_resource_types') {
            # The types the shared modules declare, read at build time, so a new module's type needs no list edit.
            $resolved[$parameter] = [ordered]@{ value = [string[]] @(Get-BicepModuleResourceTypes) }
            continue
        }
        $value = if ($field -cin 'policy_enforcement', 'subscription_production', 'groups') {
            # The subscription's class, not the slot environment's: a subscription that holds a production environment is production.
            if (-not $azure.subscriptions.ContainsKey($Slot.subscription)) {
                throw "Template config '$ConfigFile': slot '$($Slot.name)' targets subscription '$($Slot.subscription)', which azure.yml does not declare"
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
        $resolved[$parameter] = [ordered]@{ value = $value }
    }
    $resolved
}
