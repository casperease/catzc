<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md"
  header: "generated"
---
#>

BeforeDiscovery {
    $script:templateNames = @(Get-BicepTemplateNames)
}

Describe 'Shipped template parameter model' -Tag 'L2', 'integrity', 'greedy', 'ADR-AZ-DATAMOD-PARAMETERCONTRACT', 'ADR-AUTO-TEST-TESTSUITE' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates

        # The Bicep CLI is verified once for the whole template set, since each probe is a 2 s child process.
        if (Get-Command az -ErrorAction Ignore) {
            Assert-AzCliBicep
            Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        }

        # The same compiler without az's Python start per call; absent or off-version, the real Invoke-AzCli runs.
        $bicep = Resolve-ToolExecutable bicep
        if ($bicep.Found -and $bicep.VersionOk) {
            $script:bicepPath = $bicep.Path
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter { $Arguments -like 'bicep build*' } {
                # az takes the input as --file; the bicep binary takes it positionally.
                $tokens = @([regex]::Matches($Arguments.Substring('bicep '.Length), '"([^"]*)"|(\S+)') |
                        ForEach-Object {
                            if ($_.Groups[1].Success) {
                                $_.Groups[1].Value
                            }
                            else {
                                $_.Groups[2].Value
                            }
                        } |
                        Where-Object { $_ -ne '--file' })
                $output = & $script:bicepPath @tokens 2>&1
                if ($LASTEXITCODE -ne 0) {
                    throw "bicep $Arguments failed with exit code ${LASTEXITCODE}:`n$($output -join "`n")"
                }
            }
        }
    }

    It 'every rendered parameters file of template <_> satisfies its compiled parameter model' -ForEach $script:templateNames {
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        Build-Bicep $_ | Out-Null
        $violations = @(InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $_ } {
                param($Template)
                Get-BicepParameterViolations $Template
            })
        $violations |
            Should -BeNullOrEmpty -Because "the rendered parameters files must satisfy main.json:`n$($violations -join "`n")"
    }
}
