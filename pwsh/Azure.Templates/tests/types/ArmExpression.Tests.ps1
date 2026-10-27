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
        $parameters = @{ regions = [ordered]@{ widgetnorth = 'WidgetNorth'; gadgetsouth = 'GadgetSouth' }; location = 'widgetnorth'; open = $false; tags = @('Widget.{region}', 'Gadget') }
        & $eval "[concat('Storage.', parameters('regions')[parameters('location')])]" $parameters | Should -BeExactly 'Storage.WidgetNorth'
        & $eval "[parameters('regions')[if(parameters('open'), 'gadgetsouth', parameters('location'))]]" $parameters | Should -BeExactly 'WidgetNorth'
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

    It 'is unresolved outside the subset, never a guess' {
        & $isUnresolved (& $eval "[guid('widget', 'gadget')]") | Should -BeTrue
        & $isUnresolved (& $eval '[resourceGroup().location]') | Should -BeTrue
        & $isUnresolved (& $eval "[reference('gadget').outputs.name.value]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('missing'), 'widget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('kind'),]") | Should -BeTrue
    }
}
