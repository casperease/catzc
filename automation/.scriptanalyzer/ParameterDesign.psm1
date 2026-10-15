<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/ParameterDesign.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rules run strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rules for a function's parameter surface
    ([ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md)).
.DESCRIPTION
    Two checks over the functions in a module function file — a.ps1 directly under automation/<Module>/ (public) or...
    [comment:1](/docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md#comment1)
#>

function Test-ModuleFunctionFile {
    param([System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst)
    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return $false
    }
    $file.Replace('\', '/') -match '/automation/[^/.][^/]*/(private/)?[^/]+\.ps1$'
}

function Get-ParameterFunction {
    param([System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst)
    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md#comment2)
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
                            Message  = "Declare -$($parameter.Name.VariablePath.UserPath)'s default in the param block instead of filling it in the body (ADR-PWSH-PARAM#4); suppress with the reason when a declaration cannot express it."
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

    # Private helpers are called by name inside their module, so only public ones need a positional primary argument.
    # [comment:3](/docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md#comment3)
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
                Message  = "$($function.Name)'s one mandatory parameter -$($primary.Name.VariablePath.UserPath) is its primary argument: give it Position = 0 (ADR-PWSH-PARAM#2)."
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
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "$($function.Name)'s optional [bool] -$($parameter.Name.VariablePath.UserPath) is opt-in behaviour: declare it a [switch] (ADR-PWSH-PARAM#3)."
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
                    Message  = "$($function.Name)'s [switch] -$($parameter.Name.VariablePath.UserPath) defaults on: opt-in behaviour is off by default, so name the switch for the non-default behaviour (ADR-PWSH-PARAM#3)."
                    Extent   = $parameter.Extent
                    RuleName = 'Measure-NoSwitchDefaultOn'
                    Severity = 'Warning'
                })
        }
    }
    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
