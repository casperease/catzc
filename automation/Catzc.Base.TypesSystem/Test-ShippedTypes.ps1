<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
    kind: function
    module: Catzc.Base.TypesSystem
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
---
#>

<#
.SYNOPSIS
    Quality gate: every shipped C# type resolves in the session as <module>.<basename>.
.DESCRIPTION
    A concrete class that still renders as its full name in pwsh is an issue too, not only a missing type.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Test-ShippedTypes.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-shipped-types/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Types }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ShippedTypes
#>
function Test-ShippedTypes {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $typeCount = 0
    $modulesRoot = Get-CatzcModulesRoot
    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($modulesRoot) | Sort-Object)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDirectory)
        $typesDirectory = Join-Path $moduleDirectory 'types'
        if ($moduleName -match '^\.' -or -not [System.IO.Directory]::Exists($typesDirectory)) {
            continue
        }
        foreach ($file in ([System.IO.Directory]::EnumerateFiles($typesDirectory, '*.cs') | Sort-Object)) {
            $typeCount++
            $fullName = "$moduleName.$([System.IO.Path]::GetFileNameWithoutExtension($file))"
            $relative = "$moduleName/types/$([System.IO.Path]::GetFileName($file))"
            $type = ([System.Management.Automation.PSTypeName] $fullName).Type
            if (-not $type) {
                $issues.Add("${relative}: type '$fullName' does not resolve after import")
                continue
            }
            if (-not (Test-ConsoleReadyType -Type $type)) {
                $issues.Add("${relative}: '$fullName' renders as its full name in pwsh — add ``public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);``")
            }
        }
    }

    Write-QualityGateReport -Subject 'shipped-types' -Title 'Test-ShippedTypes' -Issues $issues `
        -Facts ([ordered]@{ Types = $typeCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
