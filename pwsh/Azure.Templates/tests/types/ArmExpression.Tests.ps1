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
        $parameters = @{ names = [ordered]@{ cpu = 'widget-alrt'; storage = 'gadget-alrt' }; kinds = @('cpu', 'storage') }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names').cpu]", $parameters) | Should -Be 'widget-alrt'
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names')['storage']]", $parameters) | Should -Be 'gadget-alrt'
        $indexes = @{ '' = 1; kinds = 1 }
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[parameters('names')[parameters('kinds')[copyIndex()]]]", $parameters, @{}, $indexes) |
            Should -Be 'gadget-alrt'
        [Catzc.Azure.Templates.ArmExpression]::Evaluate("[copyIndex('kinds', 10)]", $parameters, @{}, $indexes) | Should -Be 11
        & $isUnresolved ([Catzc.Azure.Templates.ArmExpression]::Evaluate("[copyIndex()]", $parameters)) | Should -BeTrue
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

    It 'is unresolved outside the subset, never a guess' {
        & $isUnresolved (& $eval "[resourceGroup().location]") | Should -BeTrue
        & $isUnresolved (& $eval "[reference('gadget').outputs.name.value]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('missing'), 'widget')]") | Should -BeTrue
        & $isUnresolved (& $eval "[equals(parameters('kind'),]") | Should -BeTrue
    }
}
