<#
---
catzc:
  immutable:
    with_body_sha: "9d2c5d1cc495"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoLiteralDefault {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return @()
    }
    $normalizedPath = $file.Replace('\', '/')
    $modulesFolder = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($PSScriptRoot))
    $functionFilePattern = '/' + [regex]::Escape($modulesFolder) + '/[^/.][^/]*/(private/)?[^/]+\.ps1$'
    if ($normalizedPath -notmatch $functionFilePattern) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoLiteralDefault'
    $why = 'a configured setting takes its default from its config type, shown in the shipped config file (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, PDR-CONFIG-DEFAULTDECLAREDONCE)'
    $add = {
        param($Extent, [string] $What)
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "$What in a function that reads a registered config: $why."
                Extent   = $Extent
                RuleName = $ruleName
                Severity = 'Warning'
            })
    }
    $isConstant = {
        param($node)
        $node -is [System.Management.Automation.Language.ConstantExpressionAst] -or
        ($node -is [System.Management.Automation.Language.StringConstantExpressionAst])
    }

    $isFunction = { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }
    foreach ($function in $ScriptBlockAst.FindAll($isFunction, $true)) {
        $readsConfig = $function.Body.Find({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Get-Config'
            }, $true)
        if (-not $readsConfig) {
            continue
        }
        # The variables the function fills from a config read, directly or through a member of one: $settings = Get-Config ...
        $isConfigRead = {
            param($node)
            [bool] $node.Find({
                    param($inner)
                    $inner -is [System.Management.Automation.Language.CommandAst] -and $inner.GetCommandName() -eq 'Get-Config'
                }, $true)
        }
        $configVariables = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $assignments = $function.Body.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true)
        foreach ($assignment in $assignments) {
            if ($assignment.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and (& $isConfigRead $assignment.Right)) {
                [void] $configVariables.Add($assignment.Left.VariablePath.UserPath)
            }
        }
        # A value comes from config when it holds a Get-Config call or a variable filled from one.
        $fromConfig = {
            param($node)
            if (& $isConfigRead $node) {
                return $true
            }
            [bool] $node.Find({
                    param($inner)
                    $inner -is [System.Management.Automation.Language.VariableExpressionAst] -and $configVariables.Contains($inner.VariablePath.UserPath)
                }, $true)
        }
        if ($function.Body.ParamBlock) {
            foreach ($parameter in $function.Body.ParamBlock.Parameters) {
                if ($parameter.Name.VariablePath.UserPath -eq 'Default') {
                    & $add $parameter.Extent 'A -Default parameter'
                }
            }
        }
        # A null-coalescing fallback to a literal: $value ?? 'widget'.
        $coalesce = $function.Body.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and
                $node.Operator -eq [System.Management.Automation.Language.TokenKind]::QuestionQuestion
            }, $true)
        foreach ($binary in $coalesce) {
            if ((& $isConstant $binary.Right) -and (& $fromConfig $binary.Left)) {
                & $add $binary.Extent 'A literal fallback after ??'
            }
        }
        # An emptiness fallback to a literal: if (-not $value) { $value = 'widget' }.
        $fallbacks = $function.Body.FindAll({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] }, $true)
        foreach ($if in $fallbacks) {
            if ($if.Clauses.Count -ne 1 -or $if.ElseClause) {
                continue
            }
            $condition = $if.Clauses[0].Item1
            $test = if ($condition -is [System.Management.Automation.Language.PipelineAst] -and $condition.PipelineElements.Count -eq 1 -and
                $condition.PipelineElements[0] -is [System.Management.Automation.Language.CommandExpressionAst]) {
                $condition.PipelineElements[0].Expression
            }
            if (-not ($test -is [System.Management.Automation.Language.UnaryExpressionAst] -and
                    $test.TokenKind -in [System.Management.Automation.Language.TokenKind]::Not, [System.Management.Automation.Language.TokenKind]::Exclaim -and
                    $test.Child -is [System.Management.Automation.Language.VariableExpressionAst] -and
                    $configVariables.Contains($test.Child.VariablePath.UserPath))) {
                continue
            }
            $statements = $if.Clauses[0].Item2.Statements
            if ($statements.Count -ne 1 -or $statements[0] -isnot [System.Management.Automation.Language.AssignmentStatementAst]) {
                continue
            }
            $assignment = $statements[0]
            $target = $assignment.Left
            $value = $assignment.Right
            $valueExpression = if ($value -is [System.Management.Automation.Language.CommandExpressionAst]) {
                $value.Expression
            }
            if ($target -is [System.Management.Automation.Language.VariableExpressionAst] -and
                $target.VariablePath.UserPath -eq $test.Child.VariablePath.UserPath -and $valueExpression -and (& $isConstant $valueExpression)) {
                & $add $if.Extent 'A literal fallback for an empty value'
            }
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
