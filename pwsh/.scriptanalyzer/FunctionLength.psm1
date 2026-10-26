<#
---
catzc:
  docs: "../../docs/references/pwsh/scriptanalyzer/FunctionLength.psm1.md"
  header: "generated"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

$script:functionBodyLength = $null

function Get-FunctionBodyLength {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Runs inside the analyzer engine, whose custom rules may emit only diagnostic records; it binds the vendored YAML reader the importer already loaded and announced, and in a bare analyzer shard process there is no console session to announce to')]
    [CmdletBinding()]
    [OutputType([int])]
    param()

    if ($null -ne $script:functionBodyLength) {
        return $script:functionBodyLength
    }
    $modulesRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    if (-not (Get-Command ConvertFrom-Yaml -ErrorAction Ignore)) {
        $versions = [System.IO.Directory]::GetDirectories((Join-Path $modulesRoot '.vendor/powershell-yaml'))
        Import-Module (Join-Path ($versions | Sort-Object | Select-Object -Last 1) 'powershell-yaml.psd1')
    }
    . (Join-Path $modulesRoot '.internal/assets/bootstrap/Resolve-ModuleName.ps1')
    . (Join-Path $modulesRoot '.internal/assets/bootstrap/Get-ModuleNamespace.ps1')
    $moduleNamespace = Get-ModuleNamespace -ModulesRoot $modulesRoot
    $fileLimitsFolder = Resolve-ModuleName -FullName 'Catzc.Base.FileLimits' -Namespace $moduleNamespace
    $limits = ConvertFrom-Yaml ([System.IO.File]::ReadAllText((Join-Path $modulesRoot "$fileLimitsFolder/configs/file-limits.yml")))
    $script:functionBodyLength = if ($limits -and $limits.Contains('function_body_length')) {
        [int] $limits['function_body_length']
    }
    elseif ('Catzc.Base.FileLimits.FileLimitsConfig' -as [type]) {
        [Catzc.Base.FileLimits.FileLimitsConfig]::DefaultFunctionBodyLength
    }
    else {
        throw 'FunctionLength: file-limits.yml sets no function_body_length, and the FileLimitsConfig type that declares its default is not loaded.'
    }
    $script:functionBodyLength
}

function Measure-FunctionLength {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $maxLines = Get-FunctionBodyLength
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-FunctionLength'

    $isFunctionDefinition = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    # Every function defined at the top level of a script block (the file's or another function's body), at any depth.
    $functions = $ScriptBlockAst.FindAll($isFunctionDefinition, $true) |
        Where-Object { $_.Parent.Parent -is [System.Management.Automation.Language.ScriptBlockAst] }

    foreach ($fn in $functions) {
        $bodyLines = $fn.Body.Extent.EndLineNumber - $fn.Body.Extent.StartLineNumber + 1

        if ($bodyLines -gt $maxLines) {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function '$($fn.Name)' body is $bodyLines lines (max $maxLines). Consider breaking it up."
                    Extent   = $fn.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
