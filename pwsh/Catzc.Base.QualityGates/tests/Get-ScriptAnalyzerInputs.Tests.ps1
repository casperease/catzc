Describe 'Get-ScriptAnalyzerInputs' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:inputsOf = {
            param([string] $Pass)
            @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Pass = $Pass } {
                    param($Pass)
                    $root = Get-RepositoryRoot
                    $settings = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
                    # The function returns its paths as one array: foreach walks the paths, not the array.
                    foreach ($path in (Get-ScriptAnalyzerInputs -RepositoryRoot $root -SettingsPath $settings -Pass $Pass)) {
                        [System.IO.Path]::GetFileName($path)
                    }
                })
        }
        $script:rules = & $script:inputsOf 'rules'
        $script:spelling = & $script:inputsOf 'spelling'
    }

    It 'gives both passes the settings and the vendored analyzer manifest' {
        foreach ($inputs in $script:rules, $script:spelling) {
            $inputs | Should -Contain 'PSScriptAnalyzerSettings.psd1'
            $inputs | Should -Contain 'PSScriptAnalyzer.psd1'
        }
    }

    It 'keeps the dictionaries and the spelling rule files out of the rules pass' {
        $script:rules | Should -Contain 'CatzcRules.psm1'
        foreach ($name in 'CatzcSpelling.psm1', 'SpellOutIdentifiers.psm1', 'english.txt.gz', 'SpellingOracle.cs') {
            $script:rules | Should -Not -Contain $name
        }
        @($script:rules | Where-Object { $_ -like '*.txt' }) | Should -HaveCount 0
    }

    It 'gives the spelling pass its rule files and the dictionaries, and no other rule file' {
        foreach ($name in 'CatzcSpelling.psm1', 'SpellOutIdentifiers.psm1', 'english.txt.gz', 'SpellingOracle.cs') {
            $script:spelling | Should -Contain $name
        }
        $script:spelling | Should -Not -Contain 'CatzcRules.psm1'
    }
}
