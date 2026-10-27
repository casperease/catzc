function Get-BicepRoleAssignmentPlan {
    [CmdletBinding()]
    [OutputType([Catzc.Azure.Templates.BicepRoleAssignment[]])]
    param(
        [Parameter(Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string[]] $Template,

        [string] $OutputRoot = (Get-BicepTemplatesOutputRoot)
    )

    $templates = @(if ($Template) {
            $Template
        }
        else {
            Get-BicepTemplateNames
        })
    # A role is shown by its roles.yml name, the name a template addresses it by.
    $roleNames = @{}
    $roles = (Get-Config -Config roles).roles
    foreach ($name in @($roles.Keys)) {
        $roleNames["$($roles[$name].id)"] = $name
    }

    foreach ($name in $templates) {
        $folder = Join-Path $OutputRoot $name
        $mainJson = Join-Path $folder 'main.json'
        Assert-PathExist $mainJson -PathType Leaf -ErrorText "Get-BicepRoleAssignmentPlan: '$name' has no compiled main.json at '$mainJson'; run Build-Bicep $name first."
        $main = [System.IO.File]::ReadAllText($mainJson) | ConvertFrom-Json -AsHashtable

        # An assignment with no scope of its own lands where its template deploys: the subscription or the resource group.
        $atSubscription = [System.Collections.Generic.HashSet[object]]::new(
            [System.Collections.Generic.IEqualityComparer[object]] [System.Collections.Generic.ReferenceEqualityComparer]::Instance)
        $index = {
            param($Body)
            $subscriptionTemplate = "$($Body['$schema'])" -match '/subscriptionDeploymentTemplate\.json'
            $list = @(if ($Body['resources'] -is [System.Collections.IDictionary]) {
                    $Body['resources'].Values
                }
                else {
                    $Body['resources']
                })
            foreach ($resource in $list) {
                if ($resource -isnot [System.Collections.IDictionary]) {
                    continue
                }
                if ($subscriptionTemplate) {
                    [void]$atSubscription.Add($resource)
                }
                $inner = $resource['properties']
                if ($inner -is [System.Collections.IDictionary] -and $inner['template'] -is [System.Collections.IDictionary]) {
                    & $index $inner['template']
                }
            }
        }
        & $index $main

        $descriptor = Get-BicepTemplate $name
        foreach ($slot in @($descriptor.slots)) {
            $file = Join-Path $folder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
            $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
            # A Key Vault reference carries no value, so it is passed as unresolved, as the compliance check does.
            $values = @{}
            foreach ($parameter in @($parameters.Keys)) {
                $values[$parameter] = if ($parameters[$parameter].Contains('value')) {
                    $parameters[$parameter].value
                }
                else {
                    [Catzc.Azure.Templates.ArmExpression]::Unresolved
                }
            }
            $coordinate = (@($slot.customer, $slot.environment, $slot.slot) | Where-Object { $_ }) -join '.'

            # Read where Deploy-Bicep sends the slot, so a resource id resolves exactly or stays unresolved.
            $facts = Get-BicepSlotDeploymentFacts -Template $descriptor -Slot $slot
            foreach ($item in @(Get-ArmDeployedResource -Template $main -Values $values @facts | Where-Object Type -EQ 'Microsoft.Authorization/roleAssignments')) {
                if ($item.Conditional) {
                    Write-Message "Get-BicepRoleAssignmentPlan: whether '$($item.Path)' of '$name' deploys in slot $coordinate does not resolve offline, so it is not listed."
                    continue
                }
                $evaluate = {
                    param($Value)
                    $result = [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, $item.Scope, $item.Variables, $item.Indexes, $item.Deployment)
                    if ($result -is [string]) {
                        $result
                    }
                    else {
                        ''
                    }
                }
                $properties = [Catzc.Azure.Templates.ArmExpression]::Evaluate($item.Resource['properties'], $item.Scope, $item.Variables, $item.Indexes, $item.Deployment)
                if ($properties -isnot [System.Collections.IDictionary]) {
                    $properties = @{}
                }
                $definition = (& $evaluate $properties['roleDefinitionId']) -replace '^.*/', ''
                $role = if ($roleNames.ContainsKey($definition)) {
                    $roleNames[$definition]
                }
                else {
                    $definition
                }
                $scope = if ($item.Resource.Contains('scope')) {
                    # The resource the assignment is on, by its provider path: the resource id less its subscription and group.
                    (& $evaluate $item.Resource['scope']) -replace '^(/subscriptions/[^/]+(/resourceGroups/[^/]+)?)?/providers/', ''
                }
                elseif ($atSubscription.Contains($item.Resource)) {
                    'subscription'
                }
                else {
                    'resourceGroup'
                }
                [Catzc.Azure.Templates.BicepRoleAssignment]::new($name, $coordinate, (& $evaluate $properties['principalId']), $role, $scope,
                    (& $evaluate $properties['condition']))
            }
        }
    }
}
