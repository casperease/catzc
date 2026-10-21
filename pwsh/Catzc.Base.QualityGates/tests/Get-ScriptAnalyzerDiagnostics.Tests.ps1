<#
---
catzc:
  immutable:
    with_body_sha: dcac80c2add1
  edges:
    docs: "[Get-ScriptAnalyzerDiagnostics.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
---
#>

# Get-ScriptAnalyzerDiagnostics is a private (non-exported) function, so it is invoked via InModuleScope.
Describe 'Get-ScriptAnalyzerDiagnostics' -Tag 'L0', 'logic' {
    It 'returns empty for an empty file list (no shards spawned)' {
        $result = InModuleScope Catzc.Base.QualityGates {
            @(Get-ScriptAnalyzerDiagnostics -Path @() -SettingsPath 'unused')
        }
        @($result).Count | Should -Be 0
    }

    Context 'two cached passes' {
        BeforeEach {
            $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'out'))
            $script:widget = Join-Path $script:root 'Get-Widget.ps1'
            $script:ruleInput = Join-Path $script:root 'widget-rules.psd1'
            $script:dictionary = Join-Path $script:root 'gadget.txt'
            [System.IO.File]::WriteAllText($script:widget, "function Get-Widget { 1 }`n")
            [System.IO.File]::WriteAllText($script:ruleInput, "@{ }`n")
            [System.IO.File]::WriteAllText($script:dictionary, "widget`n")
            $script:passesRun = [System.Collections.Generic.List[string]]::new()
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }
            Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { Join-Path $script:root 'out' }
            Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
            Mock Get-ScriptAnalyzerInputs -ModuleName Catzc.Base.QualityGates {
                if ($Pass -eq 'spelling') {
                    @($script:ruleInput, $script:dictionary)
                }
                else {
                    @($script:ruleInput)
                }
            }
            Mock Invoke-ScriptAnalyzerShards -ModuleName Catzc.Base.QualityGates {
                $ret = @{}
                foreach ($entry in $Batch) {
                    $script:passesRun.Add($entry.Label)
                    $ret[$entry.Label] = @()
                }
                $ret
            }
            $script:analyze = {
                InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $script:widget } {
                    param($P)
                    @(Get-ScriptAnalyzerDiagnostics -Path @($P) -SettingsPath 'unused')
                }
            }
        }

        It 'runs both passes cold, and neither once both found the file clean' {
            $null = & $script:analyze
            @($script:passesRun) | Should -Be @('rules', 'spelling')
            $script:passesRun.Clear()
            $null = & $script:analyze
            $script:passesRun | Should -HaveCount 0
        }

        It 're-runs only the spelling pass when only a dictionary changes' {
            $null = & $script:analyze
            $script:passesRun.Clear()
            [System.IO.File]::WriteAllText($script:dictionary, "widget`ngadget`n")
            $null = & $script:analyze
            @($script:passesRun) | Should -Be @('spelling')
        }

        It 're-runs both passes when an input they share changes' {
            $null = & $script:analyze
            $script:passesRun.Clear()
            [System.IO.File]::WriteAllText($script:ruleInput, "@{ Severity = @('Error') }`n")
            $null = & $script:analyze
            @($script:passesRun) | Should -Be @('rules', 'spelling')
        }
    }
}

Describe 'Get-ScriptAnalyzerDiagnostics (real vendored analyzer)' -Tag 'L2', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    BeforeAll {
        $script:settings = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'

        # @(...) re-arrayifies: InModuleScope (a pipeline boundary) unrolls a single-element array to a scalar.
        $script:run = {
            param($Paths, $Settings)
            @(InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $Paths; S = $Settings } {
                    param($P, $S)
                    @(Get-ScriptAnalyzerDiagnostics -Path $P -SettingsPath $S)
                })
        }
    }

    It 'shards the real analyzer across a batch: clean file yields none, violation file yields its rule + path' {
        $clean = Join-Path $TestDrive 'Get-Clean.ps1'
        Set-Content -Path $clean -Value "function Get-Clean {`n    `$value = 1`n    `$value`n}" -Encoding utf8
        $bad = Join-Path $TestDrive 'Get-Bad.ps1'
        # gci is the Get-ChildItem alias — PSAvoidUsingCmdletAliases (enabled in the repo psd1) flags it.
        Set-Content -Path $bad -Value "function Get-Bad {`n    gci`n}" -Encoding utf8

        $diagnostics = @(& $script:run @($clean, $bad) $script:settings)

        @($diagnostics | Where-Object ScriptPath -EQ $clean).Count | Should -Be 0
        $forBad = @($diagnostics | Where-Object ScriptPath -EQ $bad)
        $forBad.Count | Should -BeGreaterThan 0
        $forBad.RuleName | Should -Contain 'PSAvoidUsingCmdletAliases'
    }
}
