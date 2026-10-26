Describe 'BicepParams.Fixture (the strict build-params stand-in)' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
        $script:read = { param([string] $Text) & $script:readBicepParams ($Text -split "`n") 'widget.bicepparam' }
    }

    It 'reads one-line literals of every kind' {
        $parameters = & $script:read "using '../main.bicep'`n`nparam widget = 'it\'s'`nparam count = 3`nparam on = true`nparam off = false`nparam none = null"
        $parameters.widget.value | Should -BeExactly "it's"
        $parameters.count.value | Should -Be 3
        $parameters.on.value | Should -BeTrue
        $parameters.off.value | Should -BeFalse
        $parameters.none.value | Should -BeNullOrEmpty
    }

    It 'reads nested arrays and objects, with a quoted key' {
        $parameters = & $script:read "param gadget = {`n  ranges: [`n    '10.0.0.0/24'`n    '10.0.1.0/24'`n  ]`n  'cost-center': 'widget'`n}"
        @($parameters.gadget.value.ranges) | Should -Be @('10.0.0.0/24', '10.0.1.0/24')
        $parameters.gadget.value['cost-center'] | Should -BeExactly 'widget'
    }

    It 'reads az.getSecret on one line and wrapped, into the ARM Key Vault reference' {
        $parameters = & $script:read ("param widgetSecret = az.getSecret('sub-1', 'widget-rg', 'widget-kv', 'widget-secret')`n" +
            "param gadgetSecret = az.getSecret(`n  'sub-1',`n  'widget-rg',`n  'widget-kv',`n  'gadget-secret',`n  'v2'`n)")
        $parameters.widgetSecret.reference.keyVault.id |
            Should -BeExactly '/subscriptions/sub-1/resourceGroups/widget-rg/providers/Microsoft.KeyVault/vaults/widget-kv'
        $parameters.widgetSecret.reference.secretName | Should -BeExactly 'widget-secret'
        $parameters.gadgetSecret.reference.secretVersion | Should -BeExactly 'v2'
        $parameters.gadgetSecret.Contains('value') | Should -BeFalse
    }

    It 'throws, naming the line, on anything else: <Case>' -ForEach @(
        @{ Case = 'an expression'; Text = "param widget = concat('a', 'b')" }
        @{ Case = 'a fraction'; Text = 'param widget = 0.5' }
        @{ Case = 'a double-quoted string'; Text = 'param widget = "gadget"' }
        @{ Case = 'a statement that is not a param'; Text = "var widget = 'gadget'" }
        @{ Case = 'a secret with three arguments'; Text = "param widget = az.getSecret('a', 'b', 'c')" }
    ) {
        { & $script:read $Text } | Should -Throw '*BicepParams.Fixture: cannot read*'
    }
}
