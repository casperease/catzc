Describe 'AdrsConfig' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    # Neutral fixtures (ADR-REPO-LANG): invented domains/codes, never real ADR vocabulary.
    function New-ValidRaw {
        [ordered]@{
            domains = [ordered]@{
                alpha = [ordered]@{
                    code = 'AL'; role = 'axioms'; depends_on = @()
                    rulesets = [ordered]@{ 'thing-one' = [ordered]@{ external = 'ADR-AL-ONE' } }
                }
                beta = [ordered]@{
                    code = 'BE'; role = 'implementation'; depends_on = @('alpha')
                    rulesets = [ordered]@{
                        'thing-two' = [ordered]@{ external = 'ADR-BE-TWO' }
                        'thing-three' = [ordered]@{ external = 'ADR-AL-THREE'; code = 'AL' } # leaf override to alpha's code
                    }
                }
            }
        }
    }

    It 'maps a valid registry to typed domains and flattened rule-sets' {
        $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
        $config.Domains.Count | Should -Be 2
        $config.RuleSets.Count | Should -Be 3
    }

    It 'captures the effective code of a leaf override (not the folder domain code)' {
        $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
        $override = $config.RuleSets | Where-Object Slug -EQ 'thing-three'
        $override.Code | Should -Be 'AL'
        $override.DomainCode | Should -Be 'BE'
        $override.External | Should -Be 'ADR-AL-THREE'
    }

    It 'throws on a domain code that is not 2-4 uppercase letters' {
        $raw = New-ValidRaw
        $raw.domains.alpha.code = 'al'
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw '*2-4 uppercase*'
    }

    It 'throws when the effective code does not match the external domain segment' {
        $raw = New-ValidRaw
        $raw.domains.alpha.rulesets['thing-one'].external = 'ADR-XX-ONE' # domain alpha is AL, not XX
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw '*domain segment*'
    }

    It 'throws on a duplicate external code' {
        $raw = New-ValidRaw
        $raw.domains.beta.rulesets['thing-two'].external = 'ADR-AL-ONE'
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw '*duplicates*'
    }

    It 'throws on an unresolved depends_on target' {
        $raw = New-ValidRaw
        $raw.domains.beta.depends_on = @('nowhere')
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw '*not a declared domain*'
    }

    It 'throws on a domain dependency cycle' {
        $raw = New-ValidRaw
        $raw.domains.alpha.depends_on = @('beta') # beta already depends on alpha
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw '*cycle*'
    }
}
