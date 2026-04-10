# L2: drives the real PSScriptAnalyzer across background-job shards (the whole point of the helper), over
# throwaway fixtures. Logic, not integrity — it asserts the helper's behaviour, not a repo-wide fact.
# Get-ScriptAnalyzerDiagnostics is a private (non-exported) function, so it is invoked via InModuleScope.
Describe 'Get-ScriptAnalyzerDiagnostics' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:settings = Join-Path $env:RepositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'

        # @(...) re-arrayifies: InModuleScope (a pipeline boundary) unrolls a single-element array to a scalar.
        $script:run = {
            param($Paths, $Settings)
            @(InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $Paths; S = $Settings } {
                    param($P, $S)
                    @(Get-ScriptAnalyzerDiagnostics -Path $P -SettingsPath $S)
                })
        }
    }

    It 'returns no diagnostics for a clean file' {
        $file = Join-Path $TestDrive 'Get-Clean.ps1'
        Set-Content -Path $file -Value "function Get-Clean {`n    `$value = 1`n    `$value`n}" -Encoding utf8
        @(& $script:run @($file) $script:settings).Count | Should -Be 0
    }

    It 'returns diagnostics (rule + path) for a file with a violation' {
        $file = Join-Path $TestDrive 'Get-Bad.ps1'
        # gci is the Get-ChildItem alias — PSAvoidUsingCmdletAliases (enabled in the repo psd1) flags it.
        Set-Content -Path $file -Value "function Get-Bad {`n    gci`n}" -Encoding utf8
        $diagnostics = @(& $script:run @($file) $script:settings)
        $diagnostics.Count | Should -BeGreaterThan 0
        $diagnostics.RuleName | Should -Contain 'PSAvoidUsingCmdletAliases'
        $diagnostics[0].ScriptPath | Should -Be $file
    }

    It 'aggregates diagnostics across multiple files' {
        $clean = Join-Path $TestDrive 'Get-Ok.ps1'
        Set-Content -Path $clean -Value "function Get-Ok {`n    `$value = 1`n    `$value`n}" -Encoding utf8
        $bad = Join-Path $TestDrive 'Get-Bad2.ps1'
        Set-Content -Path $bad -Value "function Get-Bad2 {`n    gci`n}" -Encoding utf8
        $diagnostics = @(& $script:run @($clean, $bad) $script:settings)
        @($diagnostics | ForEach-Object { $_.ScriptPath } | Select-Object -Unique) | Should -Contain $bad
    }

    It 'returns empty for an empty file list (no shards spawned)' {
        $result = InModuleScope Catzc.Base.QualityGates {
            @(Get-ScriptAnalyzerDiagnostics -Path @() -SettingsPath 'unused')
        }
        @($result).Count | Should -Be 0
    }
}
