<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/.scriptanalyzer/NoRawPipelineDetection.psm1
    folder: pwsh/.scriptanalyzer
    name: no-raw-pipeline-detection
    filetype: psm1
    role: analyzer-rule
    language: powershell
    track: pwsh
    tracktype: modules
  edges:
    docs: "[NoRawPipelineDetection.psm1.md](docs/references/pwsh/scriptanalyzer/NoRawPipelineDetection.psm1.md)"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

function Measure-NoRawPipelineDetection {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Exempt test files — they set/restore the detection variables for isolation.
    if (Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawPipelineDetection'
    $exemptFunction = 'Test-IsRunningInPipeline'
    $detectionVars = @('env:TF_BUILD', 'env:GITHUB_ACTIONS')

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
