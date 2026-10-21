<#
---
catzc:
  immutable:
    with_body_sha: ad1d49e3bdb3
  edges:
    docs: "[NoRawPipelineDetection.psm1.md](docs/references/pwsh/scriptanalyzer/NoRawPipelineDetection.psm1.md)"
    cites:
      - ADR-BCL-TYPES-CHANGEDAFTERLOAD
      - ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND
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
    # Each host-detection variable has one canonical reader; the loader carries them all.
    $detectors = @{
        'env:TF_BUILD'       = 'Test-IsRunningInPipeline'
        'env:GITHUB_ACTIONS' = 'Test-IsRunningInPipeline'
        'env:TERM_PROGRAM'   = 'Test-IsRunningInVsCode'
    }
    $reasons = @{
        'Test-IsRunningInPipeline' = 'so detection stays in one place and both Azure DevOps and GitHub Actions are covered. See ADR: pipeline-detection.'
        'Test-IsRunningInVsCode'   = 'so detection stays in one place and every VS Code terminal is read the same way (ADR-BCL-TYPES-CHANGEDAFTERLOAD).'
    }

    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    $variables = $ScriptBlockAst.FindAll($isVariable, $true)

    foreach ($var in $variables) {
        $userPath = $var.VariablePath.UserPath
        if (-not $detectors.ContainsKey($userPath)) {
            continue
        }
        $exemptFunction = $detectors[$userPath]

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
                Message  = "Do not read the host-detection variable '$envVar' directly. Call $exemptFunction $($reasons[$exemptFunction])"
                Extent   = $var.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
