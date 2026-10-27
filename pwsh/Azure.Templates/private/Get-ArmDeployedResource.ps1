function Get-ArmDeployedResource {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Template,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Values,

        [string] $Path = 'main',

        # Set inside a nested deployment whose own condition does not resolve, so whether anything in it deploys is unknown.
        [switch] $Conditional,

        # The copy indexes in force where this template is read; a top-level template has none.
        [System.Collections.IDictionary] $Indexes = @{},

        # The location the deployment is sent to: Deploy-Bicep's --location, the slot's environment region. deployment().location reads
        # it in a template above resource-group scope; a resource-group deployment has none, as in ARM.
        [string] $Location
    )

    # The template's variables, evaluated on demand over the same scope when an expression names one.
    $variables = if ($Template.Contains('variables') -and $Template.variables -is [System.Collections.IDictionary]) { $Template.variables } else { @{} }
    # The copy index of the instance being read, by loop name and '' for the innermost loop; empty outside a copy.
    $current = $Indexes
    $deployment = @{}
    if ($Location -and "$($Template['$schema'])" -notmatch '/deploymentTemplate\.json') {
        $deployment.location = $Location
    }
    $evaluate = { param($Value) [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, $scope, $variables, $current, $deployment) }
    $unresolved = { param($Value) [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($Value) }

    # A parameter the caller passes keeps its value; one it omits takes its default, evaluated over the passed ones.
    $scope = @{}
    foreach ($name in @($Values.Keys)) {
        $scope[$name] = $Values[$name]
    }
    if ($Template.Contains('parameters')) {
        foreach ($name in @($Template.parameters.Keys)) {
            if (-not $scope.ContainsKey($name)) {
                $definition = $Template.parameters[$name]
                $scope[$name] = if ($definition.Contains('defaultValue')) {
                    & $evaluate $definition.defaultValue
                }
                else {
                    [Catzc.Azure.Templates.ArmExpression]::Unresolved
                }
            }
        }
    }

    # languageVersion 2.0 writes resources as a symbolic-name map, the classic form as an array.
    $resources = if ($Template.resources -is [System.Collections.IDictionary]) { @($Template.resources.Values) } else { @($Template.resources) }
    $outer = $Indexes
    foreach ($resource in $resources) {
        if ($resource.Contains('existing') -and $resource.existing -eq $true) {
            continue
        }
        # A copy loop deploys one instance per index, each read with copyIndex() bound to it: none when the count resolves to 0, one
        # uncertain item when the count does not resolve.
        $instances = @($null)
        $countUnknown = $false
        if ($resource.Contains('copy') -and $resource.copy -is [System.Collections.IDictionary] -and $resource.copy.Contains('count')) {
            $current = $outer
            $count = & $evaluate $resource.copy.count
            if (& $unresolved $count) {
                $countUnknown = $true
            }
            elseif ($count -is [long] -or $count -is [int]) {
                $loop = if ($resource.copy.Contains('name')) { "$($resource.copy.name)" } else { '' }
                $instances = @(for ($index = 0; $index -lt $count; $index++) {
                        $bound = @{}
                        foreach ($key in @($outer.Keys)) {
                            $bound[$key] = $outer[$key]
                        }
                        $bound[$loop] = $index
                        $bound[''] = $index
                        , $bound
                    })
            }
        }
        foreach ($instance in $instances) {
            $current = if ($null -eq $instance) { $outer } else { $instance }
            $condition = if ($resource.Contains('condition')) { & $evaluate $resource.condition } else { $true }
            if ($condition -eq $false) {
                continue
            }
            $uncertain = $Conditional -or $countUnknown -or (& $unresolved $condition)
            # The resolved name labels the finding; an expression name keeps its type's last segment instead.
            $resolvedName = if ($resource.Contains('name')) { & $evaluate $resource.name } else { $null }
            $label = if ($resolvedName -is [string]) { $resolvedName } else { ($resource.type -split '/')[-1] }
            if ($resource.type -eq 'Microsoft.Resources/deployments' -and $resource.properties.Contains('template')) {
                $passed = @{}
                if ($resource.properties.Contains('parameters')) {
                    foreach ($parameter in @($resource.properties.parameters.Keys)) {
                        $entry = $resource.properties.parameters[$parameter]
                        # Bicep writes a conditional parameter as one expression yielding { value }: if(c, createObject('value', a), …).
                        if ($entry -is [string]) {
                            $entry = & $evaluate $entry
                        }
                        # A for-expression parameter compiles to { copy: [{ name: 'value', count, input }] }, its value the copy's array.
                        $copies = @()
                        if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('copy')) {
                            $copies = @($entry.copy)
                        }
                        $passed[$parameter] = if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('value')) {
                            & $evaluate $entry.value
                        }
                        elseif ($copies.Count -eq 1 -and $copies[0] -is [System.Collections.IDictionary] -and $copies[0]['name'] -eq 'value') {
                            $copied = [Catzc.Azure.Templates.ArmExpression]::EvaluateCopy($copies[0], $scope, $variables, $current, $deployment)
                            if ($copied -is [array]) {
                                , $copied
                            }
                            else {
                                $copied
                            }
                        }
                        else {
                            [Catzc.Azure.Templates.ArmExpression]::Unresolved
                        }
                    }
                }
                # A nested deployment above resource-group scope is sent to its resource's location, which its deployment() reads.
                $nestedLocation = if ($resource.Contains('location')) { & $evaluate $resource.location } else { $null }
                $nestedLocation = if ($nestedLocation -is [string]) { $nestedLocation } else { '' }
                # A nested template numbers its own copy loops: its copyIndex() names its own loops.
                Get-ArmDeployedResource -Template $resource.properties.template -Values $passed -Path "$Path/$label" -Conditional:$uncertain -Location $nestedLocation
                continue
            }
            [pscustomobject]@{
                Type        = $resource.type
                Path        = "$Path/$label"
                Resource    = $resource
                Name        = $resolvedName
                Scope       = $scope
                Variables   = $variables
                Indexes     = $current
                Deployment  = $deployment
                Conditional = $uncertain
            }
        }
    }
}
