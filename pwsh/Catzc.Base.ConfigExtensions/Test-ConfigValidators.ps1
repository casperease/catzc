<#
---
catzc:
  immutable:
    with_body_sha: "0a6377b4b54e"
  edges:
    test: pwsh/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
    docs: "[Test-ConfigValidators.ps1.md](docs/references/pwsh/catzc-base-config-extensions/Test-ConfigValidators.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - DDR-RUNMODE-SAMEMODULEINBOTH
---
#>

function Test-ConfigValidators {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
