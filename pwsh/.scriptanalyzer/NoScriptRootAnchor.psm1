<#
---
catzc:
  immutable:
    with_body_sha: b4f779512bea
  edges:
    docs: "[NoScriptRootAnchor.psm1.md](docs/references/pwsh/scriptanalyzer/NoScriptRootAnchor.psm1.md)"
    cites:
      - ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY
      - ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoScriptRootAnchor {
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
    $ruleName = 'Measure-NoScriptRootAnchor'

    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    $variables = $ScriptBlockAst.FindAll($isVariable, $true)

    foreach ($variable in $variables) {
        if ($variable.VariablePath.UserPath -ne 'PSScriptRoot') {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Locate module-internal content with Get-CatzcModuleRoot -ChildPath '<literal>' (ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY); `$PSScriptRoot does not point at the module folder in build mode."
                Extent   = $variable.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
