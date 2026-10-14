Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: a function file reads a lazy $script: cache entry only after probing or assigning it.
.DESCRIPTION
    A module function file holds one function and no top-level statements
    ([ADR-PWSH-ONEFUNC](/docs/adr/pwsh/one-function-per-file.md)), so nothing declares
    a $script: cache entry at import: the first call reads a variable that was never set, and strict mode throws.
    The function must either assign the cache entry before reading it, or probe it with
    `$ExecutionContext.SessionState.PSVariable.GetValue('script:<entry>')`
    ([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)).

    Scope: everything except a .psm1 and a Pester file. A .psm1 module can declare its cache entries at load, and a
    Pester file shares state through $script: on purpose. Within a function, a read is accepted when the same function
    probes that cache entry with GetValue('script:<entry>') anywhere, or assigns it (a plain `$script:<entry> = …`)
    earlier in the text, or when the script declares that cache entry at top level, outside any function.
#>

function Measure-NoBareCacheEntryRead {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    # Skip a .psm1 (it can declare its cache entries at load) and a Pester file — by name, or by its Describe calls when
    # an editor buffer has no file name. Any other in-memory definition is analysed.
    $path = "$($ScriptBlockAst.Extent.File)"
    if ($path.EndsWith('.psm1', [System.StringComparison]::OrdinalIgnoreCase) -or
        (Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst)) {
        return $results.ToArray()
    }

    # Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
    # ([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
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

    # Cache entries the script itself declares at load (a top-level `$script:<entry> = …`, outside any function). This
    # covers a .psm1 the editor analyses as an in-memory buffer, where the file name — and so the skip above — is lost.
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
                    Message  = "'$($function.Name)' reads `$script:$name before assigning it — on a first call the cache entry is unset and strict mode throws. Probe it with `$ExecutionContext.SessionState.PSVariable.GetValue('script:$name') (ADR-PWSH-CACHE:4)."
                    Extent   = $variable.Extent
                    RuleName = 'Measure-NoBareCacheEntryRead'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
