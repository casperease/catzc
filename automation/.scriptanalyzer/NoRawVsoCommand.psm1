<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoRawVsoCommand.psm1
    kind: analyzer-rule
    language: powershell
    filekind: psm1
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/NoRawVsoCommand.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoRawVsoCommand {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawVsoCommand'
    $exemptFunction = 'Set-AdoPipelineVariable'

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
