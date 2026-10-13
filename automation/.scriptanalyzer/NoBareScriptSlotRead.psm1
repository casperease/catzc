Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: a function file reads a lazy $script: slot only after probing or assigning it.
.DESCRIPTION
    A module function file holds one function and no top-level statements (ADR-AUTO-ONEFUNC), so nothing declares
    a $script: slot at import: the first call reads a variable that was never set, and strict mode throws.
    The function must either assign the slot before reading it, or probe it with
    `$ExecutionContext.SessionState.PSVariable.GetValue('script:<slot>')` (ADR-AUTO-PSCACHE:4).

    Scope: everything except a .psm1 and a Pester file. A .psm1 module can declare its slots at load, and a Pester
    file shares state through $script: on purpose. Within a function, a read is accepted when the same function probes
    that slot with GetValue('script:<slot>') anywhere, or assigns it (a plain `$script:<slot> = …`) earlier in the text.
#>

function Measure-NoBareScriptSlotRead {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    # Skip a .psm1 (it can declare its slots at load) and a Pester file. An in-memory definition has no file and is
    # analysed.
    $path = "$($ScriptBlockAst.Extent.File)"
    if ($path.EndsWith('.psm1', [System.StringComparison]::OrdinalIgnoreCase) -or
        $path.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $results.ToArray()
    }

    # Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-AUTO-PSFORMAT:6).
    $isFunction = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    $isAssignment = {
        param($node)
        $node -is [System.Management.Automation.Language.AssignmentStatementAst]
    }
    $isScriptVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst] -and $node.VariablePath.IsScript
    }

    foreach ($function in $ScriptBlockAst.FindAll($isFunction, $true)) {
        $body = $function.Body
        $probed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($match in [regex]::Matches($body.Extent.Text, "GetValue\(\s*'script:(\w+)'\s*\)")) {
            [void]$probed.Add($match.Groups[1].Value)
        }

        # The earliest plain assignment ($script:<slot> = …) of each slot in this function.
        $firstAssignment = @{}
        foreach ($assignment in $body.FindAll($isAssignment, $true)) {
            $left = $assignment.Left
            # only a plain '=' sets the slot: '??=', '+=' and the like read it first
            $isPlain = $assignment.Operator -eq [System.Management.Automation.Language.TokenKind]::Equals
            if ($isPlain -and $left -is [System.Management.Automation.Language.VariableExpressionAst] -and $left.VariablePath.IsScript) {
                $name = $left.VariablePath.UserPath -replace '^(?i)script:', ''
                if (-not $firstAssignment.ContainsKey($name) -or $assignment.Extent.StartOffset -lt $firstAssignment[$name]) {
                    $firstAssignment[$name] = $assignment.Extent.StartOffset
                }
            }
        }

        foreach ($variable in $body.FindAll($isScriptVariable, $true)) {
            $name = $variable.VariablePath.UserPath -replace '^(?i)script:', ''
            $isWrite = $variable.Parent -is [System.Management.Automation.Language.AssignmentStatementAst] -and
            $variable.Parent.Left -eq $variable -and
            $variable.Parent.Operator -eq [System.Management.Automation.Language.TokenKind]::Equals
            $assignedBefore = $firstAssignment.ContainsKey($name) -and $firstAssignment[$name] -lt $variable.Extent.StartOffset
            if ($isWrite -or $assignedBefore -or $probed.Contains($name)) {
                continue
            }
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "'$($function.Name)' reads `$script:$name before assigning it — on a first call the slot is unset and strict mode throws. Probe it with `$ExecutionContext.SessionState.PSVariable.GetValue('script:$name') (ADR-AUTO-PSCACHE:4)."
                    Extent   = $variable.Extent
                    RuleName = 'Measure-NoBareScriptSlotRead'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
