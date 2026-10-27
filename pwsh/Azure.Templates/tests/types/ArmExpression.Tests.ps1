Describe 'ArmExpression' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:eval = { param($Value, $Parameters = @{}) [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, $Parameters) }
        $script:isUnresolved = { param($Value) [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($Value) }
    }

    It 'returns a literal, a non-string and an escaped bracket string as they are' {
        & $eval 'widget' | Should -Be 'widget'
        & $eval $true | Should -BeTrue
        & $eval '[[gadget]' | Should -Be '[gadget]'
    }

    It 'reads a parameter, and treats a missing one as unresolved' {
        & $eval "[parameters('kind')]" @{ kind = 'widget' } | Should -Be 'widget'
        & $isUnresolved (& $eval "[parameters('missing')]") | Should -BeTrue
    }

    It 'evaluates the condition forms the compiled templates use' {
        $parameters = @{ kind = 'widget'; open = $false; zones = @(); tier = 'Premium' }
        & $eval "[equals(parameters('kind'), 'Widget')]" $parameters | Should -BeTrue
        & $eval "[and(parameters('open'), equals(parameters('kind'), 'widget'))]" $parameters | Should -BeFalse
        & $eval "[not(empty(parameters('zones')))]" $parameters | Should -BeFalse
        & $eval "[contains(createArray('Premium', 'Basic'), parameters('tier'))]" $parameters | Should -BeTrue
        & $eval "[if(parameters('open'), 'Enabled', 'Disabled')]" $parameters | Should -Be 'Disabled'
    }

    It 'evaluates a variable over the same scope, on demand, and a variable that names a variable' {
        $variables = @{ isHub = "[equals(parameters('kind'), 'hub')]"; zones = "[if(variables('isHub'), createArray('widget', 'gadget'), createArray())]" }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('isHub')]", @{ kind = 'hub' }, $variables) | Should -BeTrue
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[length(variables('zones'))]", @{ kind = 'hub' }, $variables) | Should -Be 2
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[length(variables('zones'))]", @{ kind = 'spoke' }, $variables) | Should -Be 0
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('missing')]", @{}, $variables)) | Should -BeTrue
    }

    It 'filters an array by a lambda, and reads an object''s keys, as Bicep compiles `filter(objectKeys(...), x => ...)`' {
        $parameters = @{ subnets = [ordered]@{ widget = '10.0.0.0/24'; gadget = '10.0.1.0/24'; sprocket = '10.0.2.0/24' }; guarded = @{ widget = 'w'; sprocket = 's' } }
        $variables = @{ names = "[objectKeys(parameters('subnets'))]"; kept = "[filter(variables('names'), lambda('name', contains(parameters('guarded'), lambdaVariables('name'))))]" }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('kept')]", $parameters, $variables) | Should -Be @('widget', 'sprocket')
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[length(variables('kept'))]", $parameters, $variables) | Should -Be 2
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[filter(parameters('missing'), lambda('x', true()))]", @{})) | Should -BeTrue
    }

    It 'builds an object by createObject, as Bicep wraps a conditional module parameter, read through an index chosen by a parameter' {
        $parameters = @{ open = $false; owner = @{ id = 'gadget' }; widgets = @{ gadget = @{ address = '10.0.0.4' } } }
        $wrapped = & $eval "[if(parameters('open'), createObject('value', 'none'), createObject('value', parameters('widgets')[parameters('owner').id].address))]" $parameters
        $wrapped.value | Should -Be '10.0.0.4'
        & $isUnresolved (& $eval "[createObject('value')]") | Should -BeTrue
    }

    It 'reads a property or key of an object, an index of a list, and copyIndex() inside its loop' {
        $parameters = @{ names = [ordered]@{ cpu = 'widget-alert'; storage = 'gadget-alert' }; kinds = @('cpu', 'storage') }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names').cpu]", $parameters) | Should -Be 'widget-alert'
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names')['storage']]", $parameters) | Should -Be 'gadget-alert'
        $indexes = @{ '' = 1; kinds = 1 }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names')[parameters('kinds')[copyIndex()]]]", $parameters, @{}, $indexes) |
            Should -Be 'gadget-alert'
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[copyIndex('kinds', 10)]", $parameters, @{}, $indexes) | Should -Be 11
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate('[copyIndex()]', $parameters)) | Should -BeTrue
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names').memory]", $parameters)) | Should -BeTrue
    }

    It 'stops a variable that names itself instead of recursing forever' {
        $loop = @{ widget = "[variables('widget')]" }
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('widget')]", @{}, $loop)) | Should -BeTrue
    }

    It 'takes the branch an if() condition picks, whatever the other branch is' {
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[if(true(), 'widget', reference('gadget').id)]", @{}) | Should -Be 'widget'
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[if(false(), 'widget', reference('gadget').id)]", @{})) | Should -BeTrue
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[if(parameters('missing'), 'widget', 'gadget')]", @{})) | Should -BeTrue
    }

    It 'expands a for-variable from variables.copy, one input per index' {
        $variables = @{ copy = @(@{ name = 'routes'; count = "[length(parameters('hops'))]"; input = @{ hop = "[parameters('hops')[copyIndex('routes')]]" } }) }
        $routes = [Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('routes')]", @{ hops = @('widget', 'gadget') }, $variables)
        $routes.Count | Should -Be 2
        $routes[1].hop | Should -Be 'gadget'
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[variables('missing')]", @{}, $variables)) | Should -BeTrue
    }

    It 'maps an array by a lambda with its index, and computes with add and mul, as Bicep compiles `map(list, (item, index) => …)`' {
        $parameters = @{ widgets = @(@{ name = 'widget' }, @{ name = 'gadget' }) }
        $mapped = @([Catzc.Azure.Templates.ArmExpression]::Evaluate("[map(parameters('widgets'), lambda('item', 'index', createObject('name', lambdaVariables('item').name, 'priority', add(100, mul(lambdaVariables('index'), 10)))))]", $parameters))
        $mapped | ForEach-Object name | Should -Be @('widget', 'gadget')
        $mapped | ForEach-Object priority | Should -Be @(100, 110)
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[map(parameters('widgets'), lambda('item', 'sprocket'))]", $parameters) | Should -Be @('sprocket', 'sprocket')
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[map(parameters('missing'), lambda('item', 'sprocket'))]", @{})) | Should -BeTrue
    }

    It 'builds an object by toObject, a key lambda and an optional value lambda, as Bicep compiles `toObject(list, k => …, v => …)`' {
        $parameters = @{ names = @('widget', 'gadget'); widgets = @(@{ name = 'widget'; size = 1 }) }
        $built = [Catzc.Azure.Templates.ArmExpression]::Evaluate("[toObject(parameters('names'), lambda('name', lambdaVariables('name')), lambda('name', concat(lambdaVariables('name'), '-role')))]", $parameters)
        @($built.Keys) | Should -Be @('widget', 'gadget')
        $built['gadget'] | Should -Be 'gadget-role'
        ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[toObject(parameters('widgets'), lambda('item', lambdaVariables('item').name))]", $parameters))['widget'].size | Should -Be 1
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[toObject(parameters('names'), lambda('name', length(lambdaVariables('name'))))]", $parameters)) | Should -BeTrue
    }

    It 'joins arrays and strings by concat, and leaves a mix unresolved' {
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[concat(createArray('widget'), createArray('gadget', 'sprocket'))]", @{}) | Should -Be @('widget', 'gadget', 'sprocket')
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[concat('widget', '-', 'gadget')]", @{}) | Should -Be 'widget-gadget'
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[concat('widget', createArray('gadget'))]", @{})) | Should -BeTrue
        [Catzc.Azure.Templates.ArmExpression]::Evaluate('[sub(10, 3)]', @{}) | Should -Be 7
    }

    It 'indexes an object parameter by a parameter or an expression, inside a concat, a ternary and a map lambda with replace' {
        $parameters = @{ regions = [ordered]@{ 'widget-north' = 'WidgetNorth'; 'gadget-south' = 'GadgetSouth' }; location = 'widget-north'; open = $false; tags = @('Widget.{region}', 'Gadget') }
        & $eval "[concat('Storage.', parameters('regions')[parameters('location')])]" $parameters | Should -BeExactly 'Storage.WidgetNorth'
        & $eval "[parameters('regions')[if(parameters('open'), 'gadget-south', parameters('location'))]]" $parameters | Should -BeExactly 'WidgetNorth'
        & $eval "[if(parameters('open'), 'none', concat(parameters('regions')[parameters('location')], '-hub'))]" $parameters | Should -BeExactly 'WidgetNorth-hub'
        & $eval "[map(parameters('tags'), lambda('tag', replace(lambdaVariables('tag'), '{region}', parameters('regions')[parameters('location')])))]" $parameters |
            Should -BeExactly @('Widget.WidgetNorth', 'Gadget')
        & $isUnresolved (& $eval "[parameters('regions')[parameters('missing')]]" $parameters) | Should -BeTrue
        & $isUnresolved (& $eval "[concat('Storage.', parameters('regions')['nowhere'])]" $parameters) | Should -BeTrue
    }

    It 'expands a copy loop over items() of a variable, sorted by key, with tryGet and coalesce in its body, as Bicep compiles `for x in items(o)`' {
        $variables = @{ definitions = [ordered]@{ widget = [ordered]@{ id = "[parameters('widgetId')]"; mode = 'DoNotEnforce' }; gadget = [ordered]@{ id = 'gadget-id' } } }
        $parameters = @{ widgetId = 'widget-id'; mode = 'Default'; nested = @{ widget = @{ size = 1 } } }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[length(items(variables('definitions')))]", $parameters, $variables) | Should -Be 2
        $modes = foreach ($index in 0, 1) {
            $indexes = @{ '' = $index; definitions = $index }
            [Catzc.Azure.Templates.ArmExpression]::Evaluate("[items(variables('definitions'))[copyIndex()].key]", $parameters, $variables, $indexes)
            [Catzc.Azure.Templates.ArmExpression]::Evaluate("[items(variables('definitions'))[copyIndex()].value.id]", $parameters, $variables, $indexes)
            [Catzc.Azure.Templates.ArmExpression]::Evaluate("[coalesce(tryGet(items(variables('definitions'))[copyIndex()].value, 'mode'), parameters('mode'))]", $parameters, $variables, $indexes)
        }
        $modes | Should -Be @('gadget', 'gadget-id', 'Default', 'widget', 'widget-id', 'DoNotEnforce')
        & $eval "[tryGet(parameters('nested'), 'widget', 'size')]" $parameters | Should -Be 1
        & $eval "[tryGet(parameters('nested'), 'gadget', 'size')]" $parameters | Should -BeNullOrEmpty
        & $eval "[coalesce(null(), tryGet(parameters('nested'), 'gadget'), 'sprocket')]" $parameters | Should -Be 'sprocket'
        & $isUnresolved (& $eval "[coalesce(parameters('missing'), 'sprocket')]" $parameters) | Should -BeTrue
        & $isUnresolved (& $eval "[items(createArray('widget'))]") | Should -BeTrue
    }

    It 'formats plain {n} holes over strings and integers, as Bicep compiles string interpolation, and joins a string array' {
        & $eval "[format('policy-{0}-{1}', 'widget', 7)]" | Should -BeExactly 'policy-widget-7'
        & $eval "[format('{{literal}} {0}', 'gadget')]" | Should -BeExactly '{literal} gadget'
        & $eval "[format('tags {0}.', join(createArray('widget', 'gadget'), ', '))]" | Should -BeExactly 'tags widget, gadget.'
        & $isUnresolved (& $eval "[format('{0:N2}', 7)]") | Should -BeTrue
        & $isUnresolved (& $eval "[format('{1}', 'widget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[format('{0}', true())]") | Should -BeTrue
        & $isUnresolved (& $eval "[join(createArray('widget', 7), '-')]") | Should -BeTrue
    }

    It 'builds a tenant resource id, which reads no deployment scope, and leaves a type and name count mismatch unresolved' {
        & $eval "[tenantResourceId('Widget.Parts/widgets', 'gadget')]" | Should -BeExactly '/providers/Widget.Parts/widgets/gadget'
        & $eval "[tenantResourceId('Widget.Parts/widgets/gadgets', 'widget', 'sprocket')]" | Should -BeExactly '/providers/Widget.Parts/widgets/widget/gadgets/sprocket'
        & $isUnresolved (& $eval "[tenantResourceId('Widget.Parts/widgets/gadgets', 'widget')]") | Should -BeTrue
    }

    It 'reads deployment() from the deployment facts the caller passes, and leaves it unresolved without them or past what they hold' {
        $deployment = @{ location = 'widget-north' }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate('[deployment().location]', @{}, @{}, @{}, $deployment) | Should -BeExactly 'widget-north'
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[concat('Widget.', deployment().location)]", @{}, @{}, $null, $deployment) | Should -BeExactly 'Widget.widget-north'
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate('[deployment().name]', @{}, @{}, @{}, $deployment)) | Should -BeTrue
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate('[deployment().location]', @{}, @{}, @{}, @{})) | Should -BeTrue
        & $isUnresolved (& $eval '[deployment().location]') | Should -BeTrue
    }

    It 'resolves resourceId(), subscriptionResourceId(), subscription() and resourceGroup() exactly from the facts, and leaves them unresolved without' {
        # The expected ids are Bicep's own evaluator's (bicep snapshot 0.48.1 with --subscription-id and --resource-group), not this type's.
        $facts = @{ subscriptionId = '50a0ed00-de00-50b0-0000-000000000000'; resourceGroupName = 'widget-group' }
        $at = { param($Value, $Deployment = $facts) [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, @{}, @{}, @{}, $Deployment) }
        $group = '/subscriptions/50a0ed00-de00-50b0-0000-000000000000/resourceGroups'
        & $at "[resourceId('Widget.Parts/widgets', 'gadget')]" | Should -BeExactly "$group/widget-group/providers/Widget.Parts/widgets/gadget"
        & $at "[resourceId('Widget.Parts/widgets/gadgets', 'widget', 'sprocket')]" | Should -BeExactly "$group/widget-group/providers/Widget.Parts/widgets/widget/gadgets/sprocket"
        & $at "[resourceId('widget-rg', 'Widget.Parts/widgets', 'gadget')]" | Should -BeExactly "$group/widget-rg/providers/Widget.Parts/widgets/gadget"
        & $at "[resourceId('11111111-2222-3333-4444-555555555555', 'widget-rg', 'Widget.Parts/widgets', 'gadget')]" |
            Should -BeExactly '/subscriptions/11111111-2222-3333-4444-555555555555/resourceGroups/widget-rg/providers/Widget.Parts/widgets/gadget'
        & $at "[subscriptionResourceId('Widget.Parts/widgets', 'gadget')]" | Should -BeExactly '/subscriptions/50a0ed00-de00-50b0-0000-000000000000/providers/Widget.Parts/widgets/gadget'
        & $at "[subscriptionResourceId('11111111-2222-3333-4444-555555555555', 'Widget.Parts/widgets/gadgets', 'widget', 'sprocket')]" |
            Should -BeExactly '/subscriptions/11111111-2222-3333-4444-555555555555/providers/Widget.Parts/widgets/widget/gadgets/sprocket'
        & $at '[subscription().subscriptionId]' | Should -BeExactly '50a0ed00-de00-50b0-0000-000000000000'
        & $at '[subscription().id]' | Should -BeExactly '/subscriptions/50a0ed00-de00-50b0-0000-000000000000'
        & $at '[resourceGroup().name]' | Should -BeExactly 'widget-group'
        & $at '[resourceGroup().id]' | Should -BeExactly "$group/widget-group"
        & $at "[guid(resourceId('Microsoft.OperationalInsights/workspaces', 'widget-log'))]" | Should -BeExactly 'd61bf936-8844-5b06-b159-3f2725eb4720'
        & $isUnresolved (& $at "[resourceId('Widget.Parts/widgets', 'gadget')]" @{ subscriptionId = '50a0ed00-de00-50b0-0000-000000000000' }) | Should -BeTrue
        & $isUnresolved (& $at "[resourceId('Widget.Parts/widgets', 'gadget')]" @{ resourceGroupName = 'widget-group' }) | Should -BeTrue
        & $isUnresolved (& $at '[subscription().subscriptionId]' @{ resourceGroupName = 'widget-group' }) | Should -BeTrue
        & $isUnresolved (& $at '[resourceGroup().name]' @{ subscriptionId = '50a0ed00-de00-50b0-0000-000000000000' }) | Should -BeTrue
        & $isUnresolved (& $at "[resourceId('Widget.Parts/widgets/gadgets', 'widget')]") | Should -BeTrue
        & $isUnresolved (& $at "[resourceId(parameters('missing'), 'Widget.Parts/widgets', 'gadget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[resourceId('Widget.Parts/widgets', 'gadget')]") | Should -BeTrue
        & $isUnresolved (& $at '[deployment().location]') | Should -BeTrue
    }

    It 'appends extensionResourceId()''s provider path to the scope id it is given, and leaves an unresolved scope unresolved' {
        # The expected ids are Bicep's own evaluator's (bicep snapshot 0.48.1), not this type's.
        $facts = @{ subscriptionId = '00000000-0000-0000-0000-00000000000a' }
        $at = { param($Value) [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, @{}, @{}, @{}, $facts) }
        & $at "[extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, 'widget-log-rg'), 'Microsoft.OperationalInsights/workspaces', 'widget-log')]" |
            Should -BeExactly '/subscriptions/00000000-0000-0000-0000-00000000000a/resourceGroups/widget-log-rg/providers/Microsoft.OperationalInsights/workspaces/widget-log'
        & $eval "[extensionResourceId('/subscriptions/00000000-0000-0000-0000-00000000000a', 'Widget.Parts/widgets/gadgets', 'widget', 'sprocket')]" |
            Should -BeExactly '/subscriptions/00000000-0000-0000-0000-00000000000a/providers/Widget.Parts/widgets/widget/gadgets/sprocket'
        & $isUnresolved (& $eval "[extensionResourceId(format('/subscriptions/{0}', subscription().subscriptionId), 'Widget.Parts/widgets', 'gadget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[extensionResourceId('/subscriptions/00000000-0000-0000-0000-00000000000a', 'Widget.Parts/widgets/gadgets', 'widget')]") | Should -BeTrue
    }

    It 'expands a property copy entry, one input per index with copyIndex(name) bound, and a count that does not resolve to unresolved' {
        $parameters = @{ widgets = @(@{ size = 'small' }, @{ size = 'large' }) }
        $copy = @{ name = 'value'; count = "[length(parameters('widgets'))]"; input = "[parameters('widgets')[copyIndex('value')].size]" }
        [Catzc.Azure.Templates.ArmExpression]::EvaluateCopy($copy, $parameters, @{}, $null, $null) | Should -BeExactly @('small', 'large')
        $tree = @{ name = 'gadgets'; count = 2; input = @{ name = "[concat('gadget-', string(copyIndex('gadgets')))]"; at = '[deployment().location]'; index = '[copyIndex()]' } }
        $built = @([Catzc.Azure.Templates.ArmExpression]::EvaluateCopy($tree, @{}, @{}, $null, @{ location = 'widget-north' }))
        $built | ForEach-Object { $_['at'] } | Should -Be @('widget-north', 'widget-north')
        $built | ForEach-Object { $_['index'] } | Should -Be @(0, 1)
        & $isUnresolved ($built[0]['name']) | Should -BeTrue
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::EvaluateCopy(@{ name = 'value'; count = "[parameters('missing')]"; input = 'widget' }, @{}, @{}, $null, $null)) | Should -BeTrue
        [Catzc.Azure.Templates.ArmExpression]::EvaluateCopy(@{ name = 'value'; count = 0; input = 'widget' }, @{}, @{}, $null, $null) | Should -BeNullOrEmpty
    }

    It 'computes guid() as ARM does, a version 5 UUID over the arguments joined by a dash, and leaves a non-string argument unresolved' {
        # The expected values are Bicep's own evaluator's (bicep build-params 0.48.1 over `param x = guid(…)`), not this type's.
        & $eval "[guid('a')]" | Should -BeExactly '3703365d-5a9f-59b4-bca7-b9681389e4c1'
        & $eval "[guid('widget', 'gadget')]" | Should -BeExactly '861d683b-b864-5597-a1a6-790d56697302'
        & $eval "[guid('widget-gadget')]" | Should -BeExactly '861d683b-b864-5597-a1a6-790d56697302'
        & $eval "[guid('/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg', 'Reader')]" | Should -BeExactly 'c5d25c8c-603a-553a-bb0e-2f2e44314cd1'
        & $isUnresolved (& $eval "[guid('widget', 7)]") | Should -BeTrue
        & $isUnresolved (& $eval "[guid(parameters('missing'))]") | Should -BeTrue
    }

    It 'reads reference() of a nested deployment from the deployments fact, by id or symbolic name, and of anything else as unresolved' {
        $id = '/subscriptions/50a0ed00-de00-50b0-0000-000000000000/resourceGroups/widget-group/providers/Microsoft.Resources/deployments/gadget'
        $outputs = @{ id = @{ type = 'string'; value = 'widget-id' }; late = @{ type = 'string'; value = [Catzc.Azure.Templates.ArmExpression]::Unresolved } }
        $facts = @{ subscriptionId = '50a0ed00-de00-50b0-0000-000000000000'; resourceGroupName = 'widget-group'; deployments = @{ $id = $outputs; sprocket = $outputs } }
        $at = { param($Value) [Catzc.Azure.Templates.ArmExpression]::Evaluate($Value, @{ on = $true }, @{}, @{}, $facts) }
        & $at "[reference(resourceId('Microsoft.Resources/deployments', 'gadget'), '2025-04-01').outputs.id.value]" | Should -BeExactly 'widget-id'
        & $at "[REFERENCE(resourceId('Microsoft.Resources/deployments', 'GADGET'), '2025-04-01').outputs.id.value]" | Should -BeExactly 'widget-id'
        & $at "[reference(resourceId('Microsoft.Resources/deployments', 'gadget'), '2025-04-01', 'full').properties.outputs.id.value]" | Should -BeExactly 'widget-id'
        & $at "[reference('sprocket').outputs.id.value]" | Should -BeExactly 'widget-id'
        & $at "[coalesce(tryGet(if(parameters('on'), reference('sprocket'), null()), 'outputs', 'id', 'value'), '')]" | Should -BeExactly 'widget-id'
        & $isUnresolved (& $at "[reference('sprocket').outputs.late.value]") | Should -BeTrue
        & $isUnresolved (& $at "[reference('sprocket').outputs.missing.value]") | Should -BeTrue
        & $isUnresolved (& $at "[reference('sprocket').provisioningState]") | Should -BeTrue
        & $isUnresolved (& $at "[reference(resourceId('Microsoft.OperationalInsights/workspaces', 'gadget'), '2025-02-01').customerId]") | Should -BeTrue
        & $isUnresolved (& $at "[reference('sprocket', '2025-04-01', 'widget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[reference('sprocket').outputs.id.value]") | Should -BeTrue
    }

    It 'is unresolved outside the subset, never a guess' {
        & $isUnresolved (& $eval "[uniqueString('widget', 'gadget')]") | Should -BeTrue
        & $isUnresolved (& $eval '[resourceGroup().location]') | Should -BeTrue
        & $isUnresolved (& $eval "[reference('gadget').outputs.name.value]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('missing'), 'widget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('kind'),]") | Should -BeTrue
    }
}
