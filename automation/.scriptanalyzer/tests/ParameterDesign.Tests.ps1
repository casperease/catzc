BeforeAll {
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/ParameterDesign.psm1') -Force
    if (-not (Get-Module PSScriptAnalyzer)) {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
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

Describe 'Measure-ParameterFillIn' -Tag 'L0', 'logic', 'ADR-PWSH-PARAM#4' {
    It 'flags a body that fills an empty parameter in: <Description>' -ForEach @(
        @{ Description = 'if (-not $P) { $P = … }'; Body = "if (-not `$Label) {`n        `$Label = 'widget'`n    }" }
        @{ Description = '$P = $P ?? …'; Body = "`$Label = `$Label ?? 'widget'" }
    ) {
        $code = "function Get-Widget {`n    param([string] `$Label)`n    $Body`n    `$Label`n}"
        $records = @(Get-RuleRecord -Rule 'Measure-ParameterFillIn' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1')
        $records.Count | Should -Be 1
        $records | ForEach-Object { $_.RuleName } | Should -Be 'Measure-ParameterFillIn'
    }

    It 'accepts a declared default' {
        $code = "function Get-Widget {`n    param([string] `$Label = 'widget')`n    `$Label`n}"
        @(Get-RuleRecord -Rule 'Measure-ParameterFillIn' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }

    It 'leaves a test file alone' {
        $code = "function Get-Widget {`n    param([string] `$Label)`n    if (-not `$Label) { `$Label = 'widget' }`n}"
        @(Get-RuleRecord -Rule 'Measure-ParameterFillIn' -Code $code -RelativePath 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 0
    }
}

Describe 'Measure-PrimaryArgumentPosition' -Tag 'L0', 'logic', 'ADR-PWSH-PARAM#2' {
    It 'flags a public function whose one mandatory parameter is named-only' {
        $code = "function Get-Widget {`n    param([Parameter(Mandatory)] [string] `$Name, [int] `$Count = 1)`n}"
        $records = @(Get-RuleRecord -Rule 'Measure-PrimaryArgumentPosition' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1')
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
        @(Get-RuleRecord -Rule 'Measure-PrimaryArgumentPosition' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }

    It 'leaves a private helper alone' {
        $code = "function Get-Widget {`n    param([Parameter(Mandatory)] [string] `$Name)`n}"
        @(Get-RuleRecord -Rule 'Measure-PrimaryArgumentPosition' -Code $code -RelativePath 'automation/Catzc.Widget/private/Get-Widget.ps1').Count | Should -Be 0
    }
}

Describe 'Measure-NoOptionalBooleanParameter' -Tag 'L0', 'logic', 'ADR-PWSH-PARAM#3' {
    It 'flags an optional [bool] parameter: <Description>' -ForEach @(
        @{ Description = 'bare'; Param = '[bool] $Loud' }
        @{ Description = 'with a default'; Param = '[bool] $Loud = $false' }
        @{ Description = 'full type name, Mandatory = $false'; Param = '[Parameter(Mandatory = $false)] [System.Boolean] $Loud' }
    ) {
        $code = "function Get-Widget {`n    param($Param)`n}"
        $records = @(Get-RuleRecord -Rule 'Measure-NoOptionalBooleanParameter' -Code $code -RelativePath 'automation/Catzc.Widget/private/Get-Widget.ps1')
        $records.Count | Should -Be 1
        $records | ForEach-Object { $_.Message } | Should -BeLike '*-Loud*[switch]*'
    }

    It 'accepts: <Description>' -ForEach @(
        @{ Description = 'a [switch]'; Param = '[switch] $Loud' }
        @{ Description = 'a mandatory [bool], a value both ways'; Param = '[Parameter(Mandatory)] [bool] $CustomerDeployment' }
        @{ Description = 'a [bool] whose default is a configured value'; Param = '[bool] $Loud = (Get-Config -Config widget).loud' }
        @{ Description = 'a [bool] whose default is a configured value read by address'; Param = '[bool] $Loud = (Get-ConfigValue -Address ''global.widget.loud'')' }
    ) {
        $code = "function Get-Widget {`n    param($Param)`n}"
        @(Get-RuleRecord -Rule 'Measure-NoOptionalBooleanParameter' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }

    It 'still flags a [bool] whose default only mentions a config elsewhere' {
        $code = "function Get-Widget {`n    param([bool] `$Loud = `$loudDefault)`n}"
        @(Get-RuleRecord -Rule 'Measure-NoOptionalBooleanParameter' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 1
    }

    It 'leaves a test file alone' {
        $code = "function Get-Widget {`n    param([bool] `$Loud)`n}"
        @(Get-RuleRecord -Rule 'Measure-NoOptionalBooleanParameter' -Code $code -RelativePath 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 0
    }
}

Describe 'Measure-NoSwitchDefaultOn' -Tag 'L0', 'logic', 'ADR-PWSH-PARAM#3' {
    It 'flags a [switch] declared $true' {
        $code = "function Get-Widget {`n    param([switch] `$Spin = `$true)`n}"
        $records = @(Get-RuleRecord -Rule 'Measure-NoSwitchDefaultOn' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1')
        $records.Count | Should -Be 1
        $records | ForEach-Object { $_.Message } | Should -BeLike '*-Spin defaults on*'
    }

    It 'accepts: <Description>' -ForEach @(
        @{ Description = 'a switch with no default'; Param = '[switch] $Spin' }
        @{ Description = 'a switch declared $false'; Param = '[switch] $Spin = $false' }
        @{ Description = 'a [bool] declared $true (not a switch)'; Param = '[Parameter(Mandatory)] [bool] $Spin' }
    ) {
        $code = "function Get-Widget {`n    param($Param)`n}"
        @(Get-RuleRecord -Rule 'Measure-NoSwitchDefaultOn' -Code $code -RelativePath 'automation/Catzc.Widget/Get-Widget.ps1').Count | Should -Be 0
    }
}
