<#
---
catzc:
  docs: "../../docs/references/pwsh/scriptanalyzer/ParameterDesign.psm1.md"
  header: "generated"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rules run strict inside the analyzer engine

function Test-ModuleFunctionFile {
    param([System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst)
    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return $false
    }
    $modulesFolder = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($PSScriptRoot))
    $file.Replace('\', '/') -match ('/' + [regex]::Escape($modulesFolder) + '/[^/.][^/]*/(private/)?[^/]+\.ps1$')
}

function Get-ParameterFunction {
    param([System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst)
    $isFunction = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $null -ne $node.Body.ParamBlock
    }
    $ScriptBlockAst.FindAll($isFunction, $false)
}

function Measure-ParameterFillIn {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (-not (Test-ModuleFunctionFile $ScriptBlockAst)) {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($function in Get-ParameterFunction $ScriptBlockAst) {
        foreach ($parameter in $function.Body.ParamBlock.Parameters) {
            $name = [regex]::Escape($parameter.Name.VariablePath.UserPath)
            $patterns = @(
                "(?i)if\s*\(\s*-not\s+\`$$name\s*\)\s*\{\s*\`$$name\s*="
                "(?i)\`$$name\s*=\s*\`$$name\s*\?\?"
            )
            $blocks = @($function.Body.BeginBlock, $function.Body.ProcessBlock, $function.Body.EndBlock) | Where-Object { $null -ne $_ }
            foreach ($statement in @($blocks | ForEach-Object { $_.Statements })) {
                if ($patterns | Where-Object { $statement.Extent.Text -match $_ }) {
                    $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                            Message  = "Declare -$($parameter.Name.VariablePath.UserPath)'s default in the param block instead of filling it in the body (ADR-PWSH-PARAM-RESOLUTIONORDER); suppress with the reason when a declaration cannot express it."
                            Extent   = $statement.Extent
                            RuleName = 'Measure-ParameterFillIn'
                            Severity = 'Warning'
                        })
                }
            }
        }
    }
    return $results.ToArray()
}

function Measure-PrimaryArgumentPosition {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (-not (Test-ModuleFunctionFile $ScriptBlockAst) -or $ScriptBlockAst.Extent.File.Replace('\', '/') -match '/private/') {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($function in Get-ParameterFunction $ScriptBlockAst) {
        $parameters = @($function.Body.ParamBlock.Parameters)
        $attributeText = { param($p) ($p.Attributes | ForEach-Object { $_.Extent.Text }) -join ' ' }
        $mandatory = @($parameters | Where-Object { (& $attributeText $_) -match '\bMandatory\b(?!\s*=\s*\$false)' })
        $hasPositionZero = @($parameters | Where-Object { (& $attributeText $_) -match 'Position\s*=\s*0\b' }).Count -gt 0
        if ($mandatory.Count -ne 1 -or $hasPositionZero) {
            continue
        }
        $primary = $mandatory | Select-Object -First 1
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "$($function.Name)'s one mandatory parameter -$($primary.Name.VariablePath.UserPath) is its primary argument: give it Position = 0 (ADR-PWSH-PARAM-POSITIONALPRIMARY)."
                Extent   = $primary.Extent
                RuleName = 'Measure-PrimaryArgumentPosition'
                Severity = 'Warning'
            })
    }
    return $results.ToArray()
}

function Get-ParameterTypeName {
    param([System.Management.Automation.Language.ParameterAst] $Parameter)
    $constraint = $Parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.Language.TypeConstraintAst] } |
        Select-Object -First 1
    if ($constraint) {
        $constraint.TypeName.FullName
    }
    else {
        ''
    }
}

function Measure-NoOptionalBooleanParameter {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (-not (Test-ModuleFunctionFile $ScriptBlockAst)) {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($function in Get-ParameterFunction $ScriptBlockAst) {
        foreach ($parameter in $function.Body.ParamBlock.Parameters) {
            if ((Get-ParameterTypeName $parameter) -notin 'bool', 'Boolean', 'System.Boolean') {
                continue
            }
            $attributeText = ($parameter.Attributes | ForEach-Object { $_.Extent.Text }) -join ' '
            if ($attributeText -match '\bMandatory\b(?!\s*=\s*\$false)') {
                continue
            }
            if ($parameter.DefaultValue -and $parameter.DefaultValue.Extent.Text -match '\bGet-Config(Value)?\b') {
                continue
            }
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "$($function.Name)'s optional [bool] -$($parameter.Name.VariablePath.UserPath) is opt-in behaviour: declare it a [switch] (ADR-PWSH-PARAM-SWITCHNOTBOOL)."
                    Extent   = $parameter.Extent
                    RuleName = 'Measure-NoOptionalBooleanParameter'
                    Severity = 'Warning'
                })
        }
    }
    return $results.ToArray()
}

function Measure-NoSwitchDefaultOn {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (-not (Test-ModuleFunctionFile $ScriptBlockAst)) {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($function in Get-ParameterFunction $ScriptBlockAst) {
        foreach ($parameter in $function.Body.ParamBlock.Parameters) {
            if ((Get-ParameterTypeName $parameter) -notin 'switch', 'System.Management.Automation.SwitchParameter') {
                continue
            }
            if ($null -eq $parameter.DefaultValue -or $parameter.DefaultValue.Extent.Text -notmatch '^\$true$') {
                continue
            }
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "$($function.Name)'s [switch] -$($parameter.Name.VariablePath.UserPath) defaults on: opt-in behaviour is off by default, so name the switch for the non-default behaviour (ADR-PWSH-PARAM-SWITCHNOTBOOL)."
                    Extent   = $parameter.Extent
                    RuleName = 'Measure-NoSwitchDefaultOn'
                    Severity = 'Warning'
                })
        }
    }
    return $results.ToArray()
}

function Test-CaseDependentPattern {
    param([string] $Pattern)
    if ($Pattern -cmatch '\\p\{L[ul]\}') {
        return $true
    }
    foreach ($class in [regex]::Matches($Pattern, '\[(?:\\.|[^\]\\])*\]')) {
        if (($class.Value -cmatch 'A-Z') -xor ($class.Value -cmatch 'a-z')) {
            return $true
        }
    }
    return $false
}

function Measure-CaseSensitivePattern {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (-not (Test-ModuleFunctionFile $ScriptBlockAst)) {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($function in Get-ParameterFunction $ScriptBlockAst) {
        foreach ($parameter in $function.Body.ParamBlock.Parameters) {
            foreach ($attribute in $parameter.Attributes) {
                if ($attribute -isnot [System.Management.Automation.Language.AttributeAst] -or $attribute.TypeName.Name -notin 'ValidatePattern', 'ValidatePatternAttribute') {
                    continue
                }
                $pattern = $attribute.PositionalArguments | Select-Object -First 1
                if ($pattern -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    continue
                }
                if ($pattern.Value.StartsWith('(?-i)') -or ($attribute.NamedArguments | Where-Object { $_.ArgumentName -eq 'Options' })) {
                    continue
                }
                if (-not (Test-CaseDependentPattern $pattern.Value)) {
                    continue
                }
                $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message  = "$($function.Name)'s -$($parameter.Name.VariablePath.UserPath) pattern names a case, but ValidatePattern ignores case: add Options = 'None' or open the pattern with (?-i) (ADR-PWSH-PARAM-CASESENSITIVEPATTERN)."
                        Extent   = $attribute.Extent
                        RuleName = 'Measure-CaseSensitivePattern'
                        Severity = 'Warning'
                    })
            }
        }
    }
    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
