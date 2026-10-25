Describe 'Measure-NoLiteralDefault' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER', 'PDR-CONFIG-DEFAULTDECLAREDONCE' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoLiteralDefault.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-DefaultFile {
            param([string] $Code, [string] $RelativePath = 'Catzc.Widget/Get-WidgetSize.ps1')
            $path = Join-Path $TestDrive (Join-Path (Get-CatzcModulesFolder) $RelativePath)
            New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            @(Measure-NoLiteralDefault -ScriptBlockAst $ast)
        }
    }

    It 'flags <Description>' -ForEach @(
        @{ Description = 'a -Default parameter'; Text = '$Default = '; Code = "function Get-WidgetSize {`n    param([string] `$Default = 'small')`n    (Get-Config -Config widgets).size`n}" }
        @{ Description = 'a literal after ?? on a config read'; Text = "(Get-Config -Config widgets).size ?? 'small'"; Code = "function Get-WidgetSize {`n    (Get-Config -Config widgets).size ?? 'small'`n}" }
        @{ Description = 'a literal after ?? on a variable filled from config'; Text = "`$size ?? 'small'"; Code = "function Get-WidgetSize {`n    `$size = (Get-Config -Config widgets).size`n    `$size ?? 'small'`n}" }
        @{ Description = 'an emptiness fallback to a literal'; Text = "if (-not `$size) {"; Code = "function Get-WidgetSize {`n    `$size = (Get-Config -Config widgets).size`n    if (-not `$size) {`n        `$size = 'small'`n    }`n    `$size`n}" }
    ) {
        $diagnostics = @(Test-DefaultFile -Code $Code)
        $diagnostics.Count | Should -Be 1
        $diagnostics[0].RuleName | Should -Be 'Measure-NoLiteralDefault'
        $diagnostics[0].Extent.Text | Should -BeLike "*$Text*"
        $diagnostics[0].Message | Should -BeLike '*(ADR-*'
    }

    It 'leaves alone <Description>' -ForEach @(
        @{ Description = 'a placeholder for absent data that no config holds'; Code = "function Get-WidgetSize {`n    `$tools = Get-Config -Config widgets`n    `$probe = Get-Gadget`n    `$probe.Version ?? 'none'`n}" }
        @{ Description = 'a fallback in a function that reads no config'; Code = "function Get-WidgetSize {`n    param([string] `$Default = 'small')`n    `$Default ?? 'small'`n}" }
        @{ Description = 'a computed fallback'; Code = "function Get-WidgetSize {`n    (Get-Config -Config widgets).size ?? (Get-GadgetSize)`n}" }
    ) {
        Test-DefaultFile -Code $Code | Should -HaveCount 0
    }

    It 'leaves alone a file that is not a module function: <Description>' -ForEach @(
        @{ Description = 'a test file'; RelativePath = 'Catzc.Widget/tests/Get-WidgetSize.Tests.ps1' }
        @{ Description = 'dot-prefixed infrastructure'; RelativePath = '.internal/Get-WidgetSize.ps1' }
    ) {
        Test-DefaultFile -Code "function Get-WidgetSize {`n    (Get-Config -Config widgets).size ?? 'small'`n}" -RelativePath $RelativePath | Should -HaveCount 0
    }
}
