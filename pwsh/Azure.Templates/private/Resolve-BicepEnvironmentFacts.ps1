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
        $facts[$parameter] = if ($field -cin 'policy_enforcement', 'subscription_production') {
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
                $azure.policy_enforcement[$class]
            }
        }
        else {
            $environment.$field
        }
    }
    $facts
}
