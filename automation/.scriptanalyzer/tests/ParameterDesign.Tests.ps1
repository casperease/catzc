# The per-case assertions run the rule functions directly on a parsed AST (L0). Their scope is decided by the file path,
# so each case writes a fixture file into $TestDrive under a fake automation/ layout. The engine-wiring proof lives once,
# for all custom rules, in CustomRuleWiring.Tests.ps1.
BeforeAll {
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/ParameterDesign.psm1') -Force
    if (-not (Get-Module PSScriptAnalyzer)) {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
    }

    function Get-RuleRecord {
        param([string] $Rule, [string] $Code, [string] $RelativePath)
        $path = Join-Path $TestDrive $RelativePath
        New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
        Set-Content -Path $path -Value $Code
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
        & $Rule -ScriptBlockAst $ast
    }
}

Describe 'Measure-ParameterFillIn' -Tag 'L0', 'logic', 'ADR-AUTO-PSPARAM#4' {
    It 'flags a body that fills an empty parameter in: <Description>' -ForEach @(
        @{ Description = 'if (-not $P) { $P = … }'; Body = "if (-not `$Label) {`n        `$Label = 'widget'`n    }" }
        @{ Description = '$P = $P ?? …'; Body = "`$Label = `$Label ?? 'widget'" }
    ) {
        $code = "function Get-Widget {`n    param([string] `$Label)`n    $Body`n    `$Label`n}"
        $records = @(Get-RuleRecord 'Measure-ParameterFillIn' $code 'automation/Catzc.Widget/Get-Widget.ps1')
        $records.Count | Should -Be 1
        $records | ForEach-Object { $_.RuleName } | Should -Be 'Measure-ParameterFillIn'
    }

    It 'accepts a declared default' {
        $code = "function Get-Widget {`n    param([string] `$Label = 'widget')`n    `$Label`n}"
        @(Get-RuleRecord 'Measure-ParameterFillIn' $code 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }

    It 'leaves a test file alone' {
        $code = "function Get-Widget {`n    param([string] `$Label)`n    if (-not `$Label) { `$Label = 'widget' }`n}"
        @(Get-RuleRecord 'Measure-ParameterFillIn' $code 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 0
    }
}

Describe 'Measure-PrimaryArgumentPosition' -Tag 'L0', 'logic', 'ADR-AUTO-PSPARAM#2' {
    It 'flags a public function whose one mandatory parameter is named-only' {
        $code = "function Get-Widget {`n    param([Parameter(Mandatory)] [string] `$Name, [int] `$Count = 1)`n}"
        $records = @(Get-RuleRecord 'Measure-PrimaryArgumentPosition' $code 'automation/Catzc.Widget/Get-Widget.ps1')
        $records.Count | Should -Be 1
        $records | ForEach-Object { $_.Message } | Should -BeLike '*-Name*Position = 0*'
    }

    It 'accepts: <Description>' -ForEach @(
        @{ Description = 'the primary argument at Position 0'; Param = '[Parameter(Mandatory, Position = 0)] [string] $Name' }
        @{ Description = 'two mandatory parameters'; Param = '[Parameter(Mandatory)] [string] $Name, [Parameter(Mandatory)] [string] $Kind' }
        @{ Description = 'another parameter already at Position 0'; Param = '[Parameter(Position = 0)] [string] $Gadget, [Parameter(Mandatory)] [string] $Name' }
        @{ Description = 'no mandatory parameter'; Param = '[string] $Name' }
    ) {
        $code = "function Get-Widget {`n    param($Param)`n}"
        @(Get-RuleRecord 'Measure-PrimaryArgumentPosition' $code 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }

    It 'leaves a private helper alone' {
        $code = "function Get-Widget {`n    param([Parameter(Mandatory)] [string] `$Name)`n}"
        @(Get-RuleRecord 'Measure-PrimaryArgumentPosition' $code 'automation/Catzc.Widget/private/Get-Widget.ps1').Count | Should -Be 0
    }
}
