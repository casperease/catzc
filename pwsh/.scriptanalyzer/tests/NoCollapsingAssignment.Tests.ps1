Describe 'Measure-NoCollapsingAssignment' -Tag 'L0', 'logic', 'ADR-PWSH-ERROR-STRICTCLEAN' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoCollapsingAssignment.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-Collapse {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoCollapsingAssignment -ScriptBlockAst $ast
        }
    }

    It 'flags a counted variable assigned a statement: <Case>' -ForEach @(
        @{ Case = 'if'; Code = '$widgets = if ($ready) { @(Get-Widget) } else { @() }; $widgets.Count' }
        @{ Case = 'try'; Code = '$widgets = try { @(Get-Widget) } catch { @() }; if ($widgets.Count -gt 0) { }' }
        @{ Case = 'switch'; Code = '$widgets = switch ($kind) { gadget { @(Get-Gadget) } }; $widgets.Count' }
    ) {
        $records = @(Test-Collapse $Code)
        $records | Should -HaveCount 1
        $records[0].RuleName | Should -Be 'Measure-NoCollapsingAssignment'
        $records[0].Message | Should -BeLike "*'`$widgets'*"
    }

    It 'accepts the forms that keep the array: <Case>' -ForEach @(
        @{ Case = 'an array-typed declaration'; Code = '[object[]] $widgets = @(); $widgets = if ($ready) { @(Get-Widget) } else { @() }; $widgets.Count' }
        @{ Case = 'a wrapped statement'; Code = '$widgets = @(if ($ready) { Get-Widget }); $widgets.Count' }
        @{ Case = 'a statement never counted'; Code = '$widget = if ($ready) { Get-Widget } else { $null }; $widget.Name' }
        @{ Case = 'a plain expression'; Code = '$widgets = @(Get-Widget); $widgets.Count' }
    ) {
        Test-Collapse $Code | Should -BeNullOrEmpty
    }
}
