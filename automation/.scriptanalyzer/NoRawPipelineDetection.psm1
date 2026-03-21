<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw pipeline-detection env reads.
.DESCRIPTION
    Whether code is running inside a CI/CD pipeline is detected by checking the
    agent-set environment variables TF_BUILD (Azure DevOps) and GITHUB_ACTIONS
    (GitHub Actions). That detection logic must live in exactly one place —
    Test-IsRunningInPipeline — so the checked variables stay an implementation
    detail and both platforms are always covered.

    This rule flags any direct reference to $env:TF_BUILD or $env:GITHUB_ACTIONS
    that appears OUTSIDE the function Test-IsRunningInPipeline. The canonical
    detector is the one sanctioned place that reads them, so it is exempt.

    Test files (*.Tests.ps1) are exempt: they legitimately set and restore these
    variables to drive Test-IsRunningInPipeline through both contexts in isolation.

    Note: $env:BUILD_ARTIFACTSTAGINGDIRECTORY is deliberately NOT flagged — it
    answers "where does output go," not "am I in a pipeline," and its read is
    confined to Get-OutputRoot.

    See ADR: docs/adr/pipelines/pipeline-detection.md#rule-adr-pipedet1 (rule ADR-PIPEDET:1).
#>

function Measure-NoRawPipelineDetection {
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

    # Exempt test files — they set/restore the detection variables for isolation.
    $file = $ScriptBlockAst.Extent.File
    if ($file -and $file -like '*.Tests.ps1') {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawPipelineDetection'
    $exemptFunction = 'Test-IsRunningInPipeline'
    $detectionVars = @('env:TF_BUILD', 'env:GITHUB_ACTIONS')

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-PSFORMAT:6).
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    $variables = $ScriptBlockAst.FindAll($isVariable, $true)

    foreach ($var in $variables) {
        $userPath = $var.VariablePath.UserPath
        if ($detectionVars -notcontains $userPath) {
            continue
        }

        # Walk up the AST: if any ancestor is the canonical detector function, exempt it.
        $insideExempt = $false
        $parent = $var.Parent
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

        $envVar = '$' + $userPath
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Do not read the pipeline-detection variable '$envVar' directly. Call Test-IsRunningInPipeline so detection stays in one place and both Azure DevOps and GitHub Actions are covered. See ADR: pipeline-detection."
                Extent   = $var.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
