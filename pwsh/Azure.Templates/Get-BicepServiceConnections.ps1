function Get-BicepServiceConnections {
    [CmdletBinding()]
    [OutputType([Catzc.Azure.Templates.BicepServiceConnection[]])]
    param(
        [Parameter(Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string[]] $Subscription
    )

    $config = Get-Config -Config service-connections
    $roles = (Get-Config -Config roles).roles
    $templateNames = @(Get-BicepTemplateNames)
    foreach ($identity in $config.identities.Values) {
        Assert-True ($roles.ContainsKey($identity.azure_role)) -ErrorText "Identity '$($identity.name)' holds azure_role '$($identity.azure_role)', which roles.yml does not name."
        foreach ($template in $identity.templates) {
            Assert-True ($template -in $templateNames) -ErrorText "Identity '$($identity.name)' names template '$template', which is not a template (known: $($templateNames -join ', '))."
        }
    }

    # The subscriptions each template has a slot in: an identity is connected exactly where one of its templates deploys.
    $hosts = @{}
    # Assigned first: the list comes back comma-wrapped, so the assignment collects it and foreach then enumerates the templates.
    $templates = Get-BicepTemplates
    foreach ($template in $templates) {
        $hosts[$template.name] = @(foreach ($slot in $template.slots) {
                $slot.subscription
            })
    }

    $selected = @(if ($Subscription) {
            $Subscription
        }
        else {
            (Get-Config -Config azure).subscriptions.Keys
        })
    $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($subscriptionName in $selected) {
        foreach ($identity in $config.identities.Values) {
            $hosted = @($identity.templates | Where-Object { $hosts.ContainsKey($_) -and $subscriptionName -in $hosts[$_] })
            if ($hosted.Count -eq 0) {
                continue
            }
            $name = Get-BicepServiceConnectionName -Subscription $subscriptionName -Identity $identity.name
            Assert-True ($names.Add($name)) -ErrorText "Service connection name '$name' is derived twice; two subscriptions share the coordinates it is named from."
            [Catzc.Azure.Templates.BicepServiceConnection]::new($name, $identity.name, $identity.role, $subscriptionName, $identity.azure_role, $identity.templates, $identity.description)
        }
    }
}
