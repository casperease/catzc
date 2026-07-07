<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw time-binding detection.
.DESCRIPTION
    The current time binding (build-time | runtime | test-time) is detected in
    exactly one place per signal (ADR-TIMEBIND:4), so how a time is recognised
    stays an implementation detail and every read goes through Get-TimeBinding:

      - test-time is recognised by Pester being on the call stack — that check
        lives only in Test-IsTestTime, so the sole legitimate mention of the
        'Pester.psm1' frame marker is inside it.
      - build-time is recognised by the $env:CATZC_BUILD_TIME flag — read only
        in Test-IsBuildTime (the build entry points that SET it suppress this
        rule, exactly as they set it deliberately).

    This rule flags any reference to $env:CATZC_BUILD_TIME outside Test-IsBuildTime,
    and any string literal naming 'Pester.psm1' outside Test-IsTestTime. Test files
    (*.Tests.ps1) are exempt: they set/restore the flag and stub the call stack to
    drive the detectors through every binding in isolation.

    See ADR: docs/adr/automation/time-bindings.md#rule-adr-timebind4 (rule ADR-TIMEBIND:4).
#>

function Measure-NoRawTimeDetection {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # FindAll recurses, so only process the root ScriptBlockAst to avoid duplicate diagnostics.
    if ($ScriptBlockAst.Parent) {
        return @()
    }

    # Exempt test files — they set/restore the flag and stub the call stack for isolation.
    $file = $ScriptBlockAst.Extent.File
    if ($file -and $file -like '*.Tests.ps1') {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawTimeDetection'

    # Is $node inside a function named $name? (walks the AST parent chain)
    $insideFunction = {
        param($node, $name)
        $parent = $node.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $parent.Name -eq $name) {
                return $true
            }
            $parent = $parent.Parent
        }
        $false
    }

    # ---- build-time signal: $env:CATZC_BUILD_TIME outside Test-IsBuildTime ----
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($var in $ScriptBlockAst.FindAll($isVariable, $true)) {
        if ($var.VariablePath.UserPath -ne 'env:CATZC_BUILD_TIME') {
            continue
        }
        if (& $insideFunction $var 'Test-IsBuildTime') {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Do not read the build-time flag '`$env:CATZC_BUILD_TIME' directly. Call Get-TimeBinding / Test-IsBuildTime so time detection stays in one place (ADR-TIMEBIND:4). See ADR: time-bindings."
                Extent   = $var.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    # ---- test-time signal: a 'Pester.psm1' string literal outside Test-IsTestTime ----
    $isStringConst = {
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst]
    }
    foreach ($str in $ScriptBlockAst.FindAll($isStringConst, $true)) {
        # Catch both the plain 'Pester.psm1' and the escaped-regex 'Pester\.psm1' frame marker.
        if ($str.Value -notmatch 'Pester.{0,2}psm1') {
            continue
        }
        if (& $insideFunction $str 'Test-IsTestTime') {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Do not sniff the Pester call frame ('Pester.psm1') directly. Call Get-TimeBinding / Test-IsTestTime so test-time detection stays in one place (ADR-TIMEBIND:4). See ADR: time-bindings."
                Extent   = $str.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
