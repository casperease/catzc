<#
---
catzc:
  immutable:
    with_body_sha: fd02664a83df
  edges:
    docs: "[NoBareCacheEntryRead.psm1.md](../../docs/references/pwsh/scriptanalyzer/NoBareCacheEntryRead.psm1.md)"
    cites:
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

function Measure-NoBareCacheEntryRead {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    $path = "$($ScriptBlockAst.Extent.File)"
    if ($path.EndsWith('.psm1', [System.StringComparison]::OrdinalIgnoreCase) -or
        (Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst)) {
        return $results.ToArray()
    }

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

    $declared = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($assignment in $ScriptBlockAst.FindAll($isAssignment, $false)) {
        $left = $assignment.Left
        $isPlain = $assignment.Operator -eq [System.Management.Automation.Language.TokenKind]::Equals
        if ($isPlain -and $left -is [System.Management.Automation.Language.VariableExpressionAst] -and $left.VariablePath.IsScript) {
            [void]$declared.Add(($left.VariablePath.UserPath -replace '^(?i)script:', ''))
        }
    }

    foreach ($function in $ScriptBlockAst.FindAll($isFunction, $true)) {
        $body = $function.Body
        $probed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($match in [regex]::Matches($body.Extent.Text, "GetValue\(\s*'script:(\w+)'\s*\)")) {
            [void]$probed.Add($match.Groups[1].Value)
        }

        # The earliest plain assignment ($script:<entry> = …) of each cache entry in this function.
        $firstAssignment = @{}
        foreach ($assignment in $body.FindAll($isAssignment, $true)) {
            $left = $assignment.Left
            # only a plain '=' sets the cache entry: '??=', '+=' and the like read it first
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
            if ($isWrite -or $assignedBefore -or $probed.Contains($name) -or $declared.Contains($name)) {
                continue
            }
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "'$($function.Name)' reads `$script:$name before assigning it — on a first call the cache entry is unset and strict mode throws. Probe it with `$ExecutionContext.SessionState.PSVariable.GetValue('script:$name') (ADR-PWSH-CACHE-STRICTSAFEPROBE)."
                    Extent   = $variable.Extent
                    RuleName = 'Measure-NoBareCacheEntryRead'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
