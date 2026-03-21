<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw ##vso[task.…] logging commands.
.DESCRIPTION
    Azure DevOps pipeline variables and logging are driven by ##vso[task.…]
    logging commands written to stdout. These strings are awkward and error-prone
    (silent name rewrites, forgotten flags, no validation), so they must never be
    written directly. Use the canonical setter Set-AdoPipelineVariable, which
    validates names, handles output/secret flags, logs, and no-ops outside a
    pipeline.

    This rule flags any string literal containing '##vso[task.' that appears
    OUTSIDE the function Set-AdoPipelineVariable. The canonical setter is the one
    sanctioned place that emits the raw command, so it is exempt.

    See ADR: docs/adr/pipelines/pipeline-variables.md#rule-adr-pipevar1 (rule ADR-PIPEVAR:1).
#>

function Measure-NoRawVsoCommand {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # PSScriptAnalyzer invokes custom rules for every ScriptBlockAst in the parse
    # tree. FindAll recurses, so only process the root to avoid duplicate diagnostics.
    if ($ScriptBlockAst.Parent) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawVsoCommand'
    $exemptFunction = 'Set-AdoPipelineVariable'

    # Pattern for the raw logging command. Matches '##vso[task.' with optional
    # whitespace, e.g. ##vso[task.setvariable …] or ##vso[task.logissue …].
    $vsoPattern = '##vso\s*\[\s*task\.'

    # Find all string literals: bare strings ('…'/"…") and expandable strings ("$x…").
    $stringNodes = $ScriptBlockAst.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
            $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
        }, $true)

    foreach ($str in $stringNodes) {
        if ($str.Value -notmatch $vsoPattern) {
            continue
        }

        # Walk up the AST: if any ancestor is the canonical setter function, exempt it.
        $insideExempt = $false
        $parent = $str.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                $parent.Name -eq $exemptFunction) {
                $insideExempt = $true
                break
            }
            $parent = $parent.Parent
        }

        if ($insideExempt) {
            continue
        }

        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = 'Do not write raw Azure DevOps logging commands (##vso task.* strings). Use Set-AdoPipelineVariable, which validates names, handles output/secret flags, logs, and no-ops outside a pipeline. See ADR: pipeline-variables.'
                Extent   = $str.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
