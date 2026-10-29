Describe 'ConvertTo-BicepParam' -Tag 'L0', 'logic' {
    It 'renders the descriptor''s parameters against the using path' {
        $descriptor = [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = @{ value = 'widget' }; gadgetCount = @{ value = 2 } } } }
        ConvertTo-BicepParam -Descriptor $descriptor -Using '../widget/main.bicep' |
            Should -BeExactly "using '../widget/main.bicep'`n`nparam widgetName = 'widget'`nparam gadgetCount = 2`n"
    }

    It 'unwraps the values a pwsh hook hands back before they reach the writer' {
        $zones = @('1', '2' | ForEach-Object { $_ })
        $descriptor = [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ zones = @{ value = $zones } } } }
        ConvertTo-BicepParam -Descriptor $descriptor -Using '../main.bicep' |
            Should -Match "param zones = \[`n  '1'`n  '2'`n\]"
    }

    It 'renders a parameter with a naming_exception exactly as one without' {
        $plain = [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = @{ value = 'widget' } } } }
        $excepted = [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = [ordered]@{ value = 'widget'; naming_exception = 'kept for the gadget' } } } }
        $text = ConvertTo-BicepParam -Descriptor $excepted -Using '../main.bicep'
        $text | Should -BeExactly (ConvertTo-BicepParam -Descriptor $plain -Using '../main.bicep')
        $text | Should -Not -Match 'naming_exception'
    }

    It 'throws when the descriptor holds no ParametersFile.parameters' {
        { ConvertTo-BicepParam -Descriptor ([ordered]@{ widget = 1 }) -Using '../main.bicep' } |
            Should -Throw '*holds no ParametersFile.parameters*'
    }
}

Describe 'ConvertTo-BicepParam — every shipped yml slot renders as bicep format leaves it' -Tag 'L2', 'integrity' {
    It 'renders each shipped slot, addresses resolved, in the layout bicep format keeps' {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $folder = Join-Path $TestDrive 'render'
        $null = New-Item -ItemType Directory -Path $folder -Force
        $rendered = [ordered]@{}
        $templates = Get-BicepTemplates
        foreach ($template in $templates) {
            # A bicepparam slot is read by the Bicep compiler, never rendered here.
            foreach ($slot in @($template.slots | Where-Object format -eq ([Catzc.Azure.Templates.BicepSlot]::YmlFormat))) {
                $descriptor = InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
                    param($Template, $Slot)
                    Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot -PrepareHook (Get-BicepPrepareHook -TemplateDescriptor $Template)
                }
                $file = Join-Path $folder "$($rendered.Count).bicepparam"
                $rendered[$file] = ConvertTo-BicepParam -Descriptor $descriptor -Using '../main.bicep'
                [System.IO.File]::WriteAllText($file, $rendered[$file])
            }
        }
        $rendered.Count | Should -BeGreaterThan 0
        Invoke-Executable "`"$($bicep.Path)`" format --pattern `"$(($folder -replace '\\', '/'))/*.bicepparam`"" -Silent
        $changed = @($rendered.Keys | Where-Object { [System.IO.File]::ReadAllText($_) -cne $rendered[$_] })
        $changed | Should -BeNullOrEmpty -Because 'bicep format must leave the rendering of every slot unchanged'
    }
}
