<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
    folder: tests/types
    name: adrs-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/types/AdrsConfig.Tests.ps1.md
    cites:
      - ADR-AUTO-TYPES#9
      - ADR-DSGN-TRACK#{14,15}
      - ADR-REPO-LANG
---
#>

Describe 'AdrsConfig' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        function New-ValidRaw {
            [ordered]@{
                domains = [ordered]@{
                    alpha = [ordered]@{
                        code = 'AL'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'thing-one' = [ordered]@{ external = 'ADR-AL-ONE' } }
                    }
                    beta  = [ordered]@{
                        code = 'BE'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('alpha')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{
                            'thing-two'   = [ordered]@{ external = 'ADR-BE-TWO'; concern = @('access', 'release') } # concern override
                            'thing-three' = [ordered]@{ external = 'ADR-AL-THREE'; code = 'AL' } # leaf override to alpha's code
                        }
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

    It 'exposes one typed edge per depends_on link, From depending on To' {
        $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
        $config.Edges | Should -HaveCount 1
        $config.Edges[0] | Should -BeOfType 'Catzc.Base.Docs.AdrDomainEdge'
        $config.Edges[0].From | Should -Be 'beta'
        $config.Edges[0].To | Should -Be 'alpha'
    }

    It 'carries each domain description, trimmed' {
        $raw = New-ValidRaw
        $raw.domains.alpha.description = "  The widget axioms.`n"
        $config = [Catzc.Base.Docs.AdrsConfig]::new($raw)
        ($config.Domains | Where-Object Name -EQ 'alpha').Description | Should -Be 'The widget axioms.'
    }

    It 'throws on a domain with no description' {
        $raw = New-ValidRaw
        $raw.domains.beta.Remove('description')
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'beta': missing 'description'*"
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

    It 'rejects an unknown top-level key' {
        $raw = New-ValidRaw
        $raw['widget'] = 1
        { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*unknown top-level key 'widget' (allowed: domains)*"
    }

    Context 'value-chain stack and concerns' -Tag 'ADR-DSGN-TRACK#14', 'ADR-DSGN-TRACK#15' {
        It 'declares the stack rows and the concerns once, in value-chain order' {
            [Catzc.Base.Docs.AdrsConfig]::Stacks | Should -Be @('PRIN', 'DSGN', 'AUTO', 'PIPE', 'CLOUD')
            [Catzc.Base.Docs.AdrsConfig]::Concerns | Should -Be @('automation', 'build', 'quality-control', 'release', 'deploy', 'access')
        }

        It 'carries each domain''s stack row and default concerns' {
            $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
            $beta = $config.Domains | Where-Object Name -EQ 'beta'
            $beta.Stack | Should -Be 'AUTO'
            $beta.Concerns | Should -Be @('automation')
        }

        It 'gives a ruleset without an override its domain''s stack row and default concerns' {
            $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
            $three = $config.RuleSets | Where-Object Slug -EQ 'thing-three'
            $three.Stack | Should -Be 'AUTO'
            $three.Concerns | Should -Be @('automation')
            $three.DomainConcerns | Should -Be @('automation')
        }

        It 'resolves a ruleset override, in value-chain order, beside the domain default' {
            $config = [Catzc.Base.Docs.AdrsConfig]::new((New-ValidRaw))
            $two = $config.RuleSets | Where-Object Slug -EQ 'thing-two'
            $two.Concerns | Should -Be @('release', 'access')
            $two.DomainConcerns | Should -Be @('automation')
        }

        It 'throws on a domain with no stack' {
            $raw = New-ValidRaw
            $raw.domains.alpha.Remove('stack')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': missing 'stack'*"
        }

        It 'throws on a stack that is not a row of the value-chain stack' {
            $raw = New-ValidRaw
            $raw.domains.alpha.stack = 'WIDGET'
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*stack 'WIDGET' is not a row of the value-chain stack*"
        }

        It 'throws on a domain with no default concern' {
            $raw = New-ValidRaw
            $raw.domains.beta.Remove('concern')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'beta': missing 'concern'*"
        }

        It 'throws on an unknown concern in a domain default' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = @('gadgetry')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': concern 'gadgetry' is not a value-chain concern*"
        }

        It 'throws on an unknown concern in a ruleset override' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two'].concern = @('build', 'gadgetry')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*ruleset 'beta/thing-two': concern 'gadgetry' is not a value-chain concern*"
        }

        It 'throws on a concern given as a scalar, not a list' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = 'build'
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': 'concern' must be a list*"
        }

        It 'throws on an empty concern override' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two'].concern = @()
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*ruleset 'beta/thing-two': 'concern' must list one or more*"
        }

        It 'throws on a concern listed twice' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = @('build', 'build')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*concern 'build' is listed twice*"
        }

        It 'throws on an unknown domain key, so a misspelled key never falls back to the default' {
            $raw = New-ValidRaw
            $raw.domains.alpha['concerns'] = @('build')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': unknown key 'concerns'*"
        }

        It 'throws on an unknown ruleset key' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two']['concerns'] = @('build')
            { [Catzc.Base.Docs.AdrsConfig]::new($raw) } | Should -Throw "*ruleset 'beta/thing-two': unknown key 'concerns'*"
        }
    }
}
