<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.ConfigExtensions
    visibility: public
    relatives:
      test: automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-RUNMODE#2
  config:
    synopsis: 'Quality gate: every Assert-<Name>Config validator maps to a configs/<name>.yml in its own module.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      PowerShell validator convention of Invoke-ConfigValidator: a validator is found by name — the
      Assert-<TitleCase(name)>Config of the module that ships configs/<name>.yml — so a validator whose name maps to
      no shipped config is never called. It lists every such orphan.

      It walks the module folders of the loaded code root (Get-CatzcModulesRoot), so it checks the shipped configs of
      whichever tree the modules were loaded from — the source tree or a built package
      ([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)) — and reads each loaded module's own
      validators from its scope (private functions are scope-isolated, so a module lists only its own).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-config-validators/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Validators }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ConfigValidators
---
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
