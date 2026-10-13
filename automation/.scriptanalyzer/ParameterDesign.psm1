Set-StrictMode -Version Latest   # this module's scope: the rules run strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rules for a function's parameter surface
    ([ADR-AUTO-PSPARAM](/docs/adr/automation/powershell/parameter-design.md)).
.DESCRIPTION
    Two checks over the functions in a module function file — a .ps1 directly under automation/<Module>/ (public) or
    automation/<Module>/private/ (private); tests, assets, dot-prefixed infrastructure, and files outside automation/
    are exempt by path, as for Measure-NoScriptRootAnchor:

    Measure-ParameterFillIn
    ([ADR-AUTO-PSPARAM#4](/docs/adr/automation/powershell/parameter-design.md#rule-adr-auto-psparam4)):
    the body fills an empty parameter in — `if (-not $P) { $P = … }` or `$P = $P ?? …` — instead of declaring the default.
    The cases a declaration cannot express carry a SuppressMessageAttribute naming the reason.

    Measure-PrimaryArgumentPosition
    ([ADR-AUTO-PSPARAM#2](/docs/adr/automation/powershell/parameter-design.md#rule-adr-auto-psparam2)):
    a public function with exactly one mandatory parameter, and no parameter at Position 0, leaves its primary argument
    named-only. Private helpers are exempt: they are called by name from inside their module.
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
    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
    # ([ADR-AUTO-PSFORMAT#6](/docs/adr/automation/powershell/powershell-formatting.md#rule-adr-auto-psformat6)).
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
                            Message  = "Declare -$($parameter.Name.VariablePath.UserPath)'s default in the param block instead of filling it in the body (ADR-AUTO-PSPARAM#4); suppress with the reason when a declaration cannot express it."
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

    # Public functions only: a positional primary argument serves the module's callers; a private helper is called by
    # name from inside its module.
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
                Message  = "$($function.Name)'s one mandatory parameter -$($primary.Name.VariablePath.UserPath) is its primary argument: give it Position = 0 (ADR-AUTO-PSPARAM#2)."
                Extent   = $primary.Extent
                RuleName = 'Measure-PrimaryArgumentPosition'
                Severity = 'Warning'
            })
    }
    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
