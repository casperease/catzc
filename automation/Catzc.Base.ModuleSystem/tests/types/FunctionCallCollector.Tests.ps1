<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/tests/types/FunctionCallCollector.Tests.ps1
    folder: tests/types
    name: function-call-collector-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/tests/types/FunctionCallCollector.Tests.ps1.md
---
#>

Describe 'FunctionCallCollector' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:collect = {
            param([string] $Source)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Source, [ref]$null, [ref]$null)
            [Catzc.Base.ModuleSystem.FunctionCallCollector]::Collect($ast)
        }
    }

    It 'returns one entry per top-level function, in document order' {
        $source = @(
            'function Get-Widget { Get-Gadget }'
            'function Set-Widget { Set-Gadget }'
        ) -join "`n"
        $found = @(& $collect $source)
        $found.Count | Should -Be 2
        $found[0].Function.Name | Should -BeExactly 'Get-Widget'
        $found[1].Function.Name | Should -BeExactly 'Set-Widget'
    }

    It 'treats a function in a begin or process block as top-level, but not one inside a statement' {
        $source = @(
            'begin { function Get-Widget { } }'
            'process { function Get-Gadget { } }'
            'end { if ($true) { function Get-Hidden { } } }'
        ) -join "`n"
        @(& $collect $source).Function.Name | Should -Be @('Get-Widget', 'Get-Gadget')
    }

    It 'attributes calls in nested functions and script blocks to the outer function, with their lines' {
        $source = @(
            'function Get-Widget {'
            '    function Get-InnerWidget { Get-Gadget }'
            '    Get-ChildItem | ForEach-Object { Set-Gadget }'
            '}'
        ) -join "`n"
        $found = @(& $collect $source)
        $found.Count | Should -Be 1
        $found[0].NestedFunctionNames | Should -Be @('Get-InnerWidget')
        @($found[0].Calls | ForEach-Object { "$_" }) | Should -Be @('Get-Gadget:2', 'Get-ChildItem:3', 'ForEach-Object:3', 'Set-Gadget:3')
    }

    It 'skips a command with no static name' {
        $found = @(& $collect 'function Get-Widget { & $gadget; . $widget; Get-Gadget }')
        @($found[0].Calls.Name) | Should -Be @('Get-Gadget')
    }

    It 'returns nothing for a file without functions' {
        @(& $collect 'Get-Gadget').Count | Should -Be 0
    }
}
