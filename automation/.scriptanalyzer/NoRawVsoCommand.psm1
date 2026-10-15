Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw ##vso[task.…] logging commands.
.DESCRIPTION
    A raw logging command is error-prone (silent name rewrites, forgotten flags), so one validating setter emits it.
    [ADR-PIPE-VAR#1](/docs/adr/pipelines/pipeline-variables.md#rule-adr-pipe-var1)
    [comment:1](/docs/references/automation/scriptanalyzer/NoRawVsoCommand.psm1.md#comment1)
#>

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

    # Allows whitespace inside the marker, so a spaced spelling of the command is caught too.
    # [comment:2](/docs/references/automation/scriptanalyzer/NoRawVsoCommand.psm1.md#comment2)
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
