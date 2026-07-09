Describe 'Get-AdrRuleSet integrity' -Tag 'L1', 'integrity', 'ADR-CONF-LOADING#5' {
    BeforeAll {
        $script:ruleSets = Get-AdrRuleSet
        $adrRoot = Resolve-RepoPath 'docs/adr'
        # index every ADR .md by "<domainFolder>/<slug>" so a slug shared across domains (e.g.
        # test-automation in automation/ and research/) stays distinct.
        $script:byKey = @{}
        foreach ($file in [IO.Directory]::EnumerateFiles($adrRoot, '*.md', 'AllDirectories')) {
            $rel = ($file.Substring($adrRoot.Length).TrimStart('\', '/')) -replace '\\', '/'
            $domainFolder = ($rel -split '/')[0]
            $slug = [IO.Path]::GetFileNameWithoutExtension($file)
            $script:byKey["$domainFolder/$slug"] = $file
        }
    }

    It 'returns the flattened typed rule-sets' {
        $script:ruleSets.Count | Should -BeGreaterThan 100
        $script:ruleSets[0] | Should -BeOfType 'Catzc.Base.Docs.AdrRuleSet'
    }

    It 'captures a leaf code override as the effective code, not the folder domain code' {
        $override = $script:ruleSets | Where-Object Slug -EQ 'az-session-verification'
        $override.External | Should -Be 'ADR-AZ-SESSION'
        $override.Code | Should -Be 'AZ'
        $override.DomainCode | Should -Be 'AUTO'
    }

    It 'each rule-set has exactly one ADR file under its own domain folder' {
        foreach ($ruleSet in $script:ruleSets) {
            $script:byKey.ContainsKey("$($ruleSet.Domain)/$($ruleSet.Slug)") |
                Should -BeTrue -Because "docs/adr/$($ruleSet.Domain)/**/$($ruleSet.Slug).md must exist"
        }
    }

    It 'each ADR file declares its external code as its Rules heading (adrs.yml <-> file agree)' {
        foreach ($ruleSet in $script:ruleSets) {
            $file = $script:byKey["$($ruleSet.Domain)/$($ruleSet.Slug)"]
            if (-not $file) { continue }
            $content = [IO.File]::ReadAllText($file)
            $content | Should -Match "(?m)^## Rules: $([regex]::Escape($ruleSet.External))\s*$" `
                -Because "$($ruleSet.Slug).md must head with '## Rules: $($ruleSet.External)'"
        }
    }

    It 'every external citation code is unique' {
        $externals = @($script:ruleSets.External)
        @($externals | Sort-Object -Unique).Count | Should -Be $externals.Count
    }
}
