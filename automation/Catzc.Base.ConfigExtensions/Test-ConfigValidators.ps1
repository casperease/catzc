<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
    kind: function
    module: Catzc.Base.ConfigExtensions
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-RUNMODE#2
---
#>

<#
.SYNOPSIS
    Quality gate: every Assert-<Name>Config validator maps to a configs/<name>.yml in its own module.
.DESCRIPTION
    A validator whose name maps to no shipped config is never called, so this gate lists every such orphan.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-config-validators/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Validators }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ConfigValidators
#>
function Test-ConfigValidators {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $validatorCount = 0
    $modulesRoot = Get-CatzcModulesRoot
    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($modulesRoot) | Sort-Object)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDirectory)
        if ($moduleName -match '^\.') {
            continue
        }
        $module = Get-Module $moduleName
        if (-not $module) {
            continue
        }

        # piped, not member-enumerated: .Name over an empty result throws in a strict scope
        $validators = @(& $module { Get-Item Function:\Assert-*Config -ErrorAction Ignore | Select-Object -ExpandProperty Name })
        if ($validators.Count -eq 0) {
            continue
        }
        $validatorCount += $validators.Count

        $expected = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $configsDirectory = Join-Path $moduleDirectory 'configs'
        if ([System.IO.Directory]::Exists($configsDirectory)) {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($configsDirectory, '*.yml')) {
                [void]$expected.Add((Get-ConfigValidatorName -Name ([System.IO.Path]::GetFileNameWithoutExtension($file))))
            }
        }

        foreach ($validator in ($validators | Sort-Object)) {
            if (-not $expected.Contains($validator)) {
                $issues.Add("$validator in $moduleName has no matching configs/*.yml — rename it to Assert-<TitleCase(name)>Config or add the config")
            }
        }
    }

    Write-QualityGateReport -Subject 'config-validators' -Title 'Test-ConfigValidators' -Issues $issues `
        -Facts ([ordered]@{ Validators = $validatorCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
