# Get-ScriptAnalyzerDiagnostics is a private (non-exported) function, so it is invoked via InModuleScope.
Describe 'Get-ScriptAnalyzerDiagnostics' -Tag 'L0', 'logic' {
    It 'returns empty for an empty file list (no shards spawned)' {
        $result = InModuleScope Catzc.Base.QualityGates {
            @(Get-ScriptAnalyzerDiagnostics -Path @() -SettingsPath 'unused')
        }
        @($result).Count | Should -Be 0
    }
}

# L2: drives the real PSScriptAnalyzer across background-job shards (the whole point of the helper), over
# throwaway fixtures. Integrity, because it reads two shipped assets with nothing mocked: the vendored
# analyzer (<code root>/.vendor/PSScriptAnalyzer) and the one settings file (<code root>/.internal/assets) — the
# real-asset test of ADR-AUTO-ASSETDEP:3, so it runs in both the source and the build suite.
Describe 'Get-ScriptAnalyzerDiagnostics (real vendored analyzer)' -Tag 'L2', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
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

    # One sharded run over a clean + a violating file proves everything the helper must do: the clean file
    # yields nothing, the violating file yields its rule and path, and diagnostics are aggregated per file
    # across the batch. Spawning the shards is the L2 cost, so pay it once rather than once per assertion.
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
