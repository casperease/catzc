Describe 'BicepParamWriter' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:write = { param($Parameters) [Catzc.Azure.Templates.BicepParamWriter]::Write('../main.bicep',
                $Parameters) }
        $script:vault = '/subscriptions/a2000000-7e57-50b0-0000-000000000000/resourceGroups/widget-rg/providers/Microsoft.KeyVault/vaults/widget-kv'
    }

    It 'writes the using line alone for no parameters' {
        & $script:write ([ordered]@{}) | Should -BeExactly "using '../main.bicep'`n"
    }

    It 'writes every literal kind in its parameter order' {
        $text = & $script:write ([ordered]@{
                widgetName  = @{ value = 'widget' }
                gadgetCount = @{ value = 3 }
                enabled     = @{ value = $false }
                ratio       = @{ value = '0.5' }
                nothing     = @{ value = $null }
            })
        $text | Should -BeExactly ("using '../main.bicep'`n`n" +
            "param widgetName = 'widget'`nparam gadgetCount = 3`nparam enabled = false`nparam ratio = '0.5'`nparam nothing = null`n")
    }

    It 'writes nested objects and arrays two spaces per level, quoting a key that is not an identifier' {
        $text = & $script:write ([ordered]@{
                tags = @{ value = [ordered]@{ owner = 'widget'; 'cost-center' = 'gadget'; zones = @('1',
                            '2'); empty = @()
                    }
                }
            })
        $text |
            Should -BeExactly ("using '../main.bicep'`n`nparam tags = {`n  owner: 'widget'`n  'cost-center': 'gadget'`n  zones: [`n    '1'`n" +
                "    '2'`n  ]`n  empty: []`n}`n")
    }

    It 'escapes a backslash, a quote, an interpolation and a newline in a string' {
        $text = & $script:write ([ordered]@{ gadget = @{ value = "it's `${widget}\x`ny" } })
        $text | Should -Match ([regex]::Escape("param gadget = 'it\'s \`${widget}\\x\ny'"))
    }

    It 'writes a Key Vault reference as az.getSecret, with the secret version when one is given' {
        $text = & $script:write ([ordered]@{
                widgetPassword = @{ reference = @{ keyVault = @{ id = $script:vault }; secretName = 'widget-secret' } }
                gadgetPassword = @{ reference = @{ keyVault = @{ id = $script:vault }; secretName = 'gadget-secret'; secretVersion = 'v2' } }
            })
        $text |
            Should -Match ([regex]::Escape("param widgetPassword = az.getSecret('a2000000-7e57-50b0-0000-000000000000', 'widget-rg', 'widget-kv', 'widget-secret')"))
        # Wider than the formatter's 120 columns on one line, so one argument per line, as bicep format writes it.
        $text |
            Should -Match ([regex]::Escape("param gadgetPassword = az.getSecret(`n  'a2000000-7e57-50b0-0000-000000000000',`n  'widget-rg',`n  'widget-kv',`n  'gadget-secret',`n  'v2'`n)`n"))
    }

    It 'throws naming the parameter on a malformed vault id, a fraction, and an entry with neither or both forms' {
        { & $script:write ([ordered]@{ widgetPassword = @{ reference = @{ keyVault = @{ id = '/vaults/widget-kv' }; secretName = 's' } } }) } |
            Should -Throw "*parameter 'widgetPassword': a Key Vault reference needs keyVault.id*"
        { & $script:write ([ordered]@{ ratio = @{ value = [double]0.5 } }) } |
            Should -Throw "*parameter 'ratio':*no Bicep literal*"
        { & $script:write ([ordered]@{ gadget = @{ address = 'global.widget.id' } }) } |
            Should -Throw "*parameter 'gadget': an entry holds exactly one of value or reference*"
        { & $script:write ([ordered]@{ gadget = @{ value = 1; reference = @{} } }) } |
            Should -Throw "*parameter 'gadget': an entry holds exactly one*"
    }
}

Describe 'BicepParamWriter — bicep format leaves the render unchanged' -Tag 'L2', 'integrity' {
    It 'renders a shipped literal-and-secret slot in the layout bicep format keeps' {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $templates = Get-BicepTemplates
        $template = $templates | ForEach-Object { $_ } | Where-Object name -eq 'expedition' | Select-Object -First 1
        $slot = $template.slots | Where-Object name -eq 'dev' | Select-Object -First 1
        $descriptor = InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot -PrepareHook (Get-BicepPrepareHook -TemplateDescriptor $Template)
        }
        # The same plain-data round trip ConvertTo-BicepParam makes before the writer sees the parameters.
        $parameters = $descriptor.ParametersFile.parameters | ConvertTo-Json -Depth 20 | ConvertFrom-Json -AsHashtable -DateKind String
        foreach ($entry in $parameters.Values) {
            if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('naming_exception')) {
                $entry.Remove('naming_exception')
            }
        }
        $text = [Catzc.Azure.Templates.BicepParamWriter]::Write('../main.bicep', $parameters)
        $file = Join-Path $TestDrive 'dev.bicepparam'
        [System.IO.File]::WriteAllText($file, $text)
        Invoke-Executable "`"$($bicep.Path)`" format `"$file`"" -Silent
        [System.IO.File]::ReadAllText($file) | Should -BeExactly $text
    }
}
