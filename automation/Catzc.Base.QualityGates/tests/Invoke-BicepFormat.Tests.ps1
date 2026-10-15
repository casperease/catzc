<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
    kind: pester-test
---
#>

# The bicep engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
# the probe finds a managed Bicep CLI, and the mock writes the --outfile copy the engine compares. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Invoke-BicepFormat' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:widget = Join-Path $TestDrive 'widget.bicep'
        $script:gadget = Join-Path $TestDrive 'gadget.bicep'
        [System.IO.File]::WriteAllText($script:widget, "param widget string`n")
        [System.IO.File]::WriteAllText($script:gadget, "param  gadget   string`n")
        $script:formatExit = 0
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'bicep' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\tools\bicep.exe'; Version = '0.48.1'; Required = '0.48' }
        }
        # The fake formatter collapses runs of spaces in every file the --pattern names, in place, as `bicep format
        # --pattern` does.
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            if ($Command -match 'format --pattern "([^"]+)"') {
                foreach ($copy in [System.IO.Directory]::GetFiles([System.IO.Path]::GetDirectoryName($Matches[1]), '*.bicep')) {
                    [System.IO.File]::WriteAllText($copy, ([System.IO.File]::ReadAllText($copy) -replace ' {2,}', ' '))
                }
            }
            [pscustomobject]@{ ExitCode = $script:formatExit; Output = ''; Full = 'bicep output' }
        }
    }

    It 'formats every file in one Bicep CLI process' {
        $null = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget, $script:gadget) } {
            param($Files)
            Invoke-BicepFormat -File $Files -DryRun
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Command -like '*format --pattern *' }
    }

    It 'rewrites exactly the files whose formatted copy differs' {
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget, $script:gadget) } {
            param($Files)
            Invoke-BicepFormat -File $Files
        }
        $changed | Should -Be @($script:gadget)
        [System.IO.File]::ReadAllText($script:gadget) | Should -BeExactly "param gadget string`n"
        [System.IO.File]::ReadAllText($script:widget) | Should -BeExactly "param widget string`n"
    }

    It 'leaves every file untouched under -DryRun' {
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:gadget) } {
            param($Files)
            Invoke-BicepFormat -File $Files -DryRun
        }
        $changed | Should -Be @($script:gadget)
        [System.IO.File]::ReadAllText($script:gadget) | Should -BeExactly "param  gadget   string`n"
    }

    It 'needs no Bicep CLI when there are no Bicep files' {
        $none = InModuleScope Catzc.Base.QualityGates { @(Invoke-BicepFormat -File @() | ForEach-Object { $_ }) }
        $none | Should -HaveCount 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws with "Run Install-Bicep" when no CLI at the pin is found, and with the tool''s output on a failure' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'bicep' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.48' }
        }
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-BicepFormat -File $Files } } |
            Should -Throw "*pin '0.48' (found: none)*Run Install-Bicep*"
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'bicep' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\tools\bicep.exe'; Version = '0.48.1'; Required = '0.48' }
        }
        $script:formatExit = 1
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-BicepFormat -File $Files } } |
            Should -Throw '*bicep could not format the Bicep files (exit 1)*bicep output*'
    }
}
