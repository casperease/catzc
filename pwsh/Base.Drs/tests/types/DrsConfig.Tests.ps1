<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-drs/tests/types/DrsConfig.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'DrsConfig.IndexPath' -Tag 'L0', 'logic' {
    It 'names index.md in the records folder under the repository root, and refuses an empty root' {
        $config = Get-Config -Config drs
        $root = Join-Path $TestDrive 'widget-repository'
        $config.IndexPath($root) |
            Should -Be ([System.IO.Path]::GetFullPath((Join-Path $root "$($config.Root)/index.md")))
        { $config.IndexPath('') } | Should -Throw '*repositoryRoot*'
    }
}

Describe 'DrsConfig' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    BeforeAll {
        # Invented domains and codes, never real record vocabulary, defined here so the run phase sees the helper.
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
                            'thing-two'   = [ordered]@{ external = 'ADR-BE-TWO'; concern = @('access',
                                    'release')
                            } # concern override
                            'thing-three' = [ordered]@{ external = 'ADR-AL-THREE'; code = 'AL' } # leaf override to alpha's code
                        }
                    }
                }
            }
        }
    }

    Context 'record kinds' -Tag 'ADR-REPO-DRSCODE-DOMAINSEGMENT' {
        It 'registers the one shared kind ADR when the registry declares none' {
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            $config.Kinds | Should -Be @('ADR')
            $config.SharedKinds | Should -Be @('ADR')
            $config.Domains[0].Kind | Should -Be 'ADR'
            $config.Domains[0].Prefix | Should -Be 'ADR-AL'
            ($config.RuleSets | Where-Object Slug -EQ 'thing-one').Prefix | Should -Be 'ADR-AL'
        }

        It 'takes a rule as one segment more than the shortest ADR code of its kind, so a group segment is an ADR''s' {
            $raw = New-ValidRaw
            $raw['kinds'] = [ordered]@{ ADR = [ordered]@{ name = 'Architecture Decision Record'; shared = $true }; GDR = [ordered]@{ name = 'Gadget Decision Record' } }
            $raw.domains.alpha.Remove('code')
            $raw.domains.alpha['kind'] = 'GDR'
            $raw.domains.alpha.rulesets['thing-one'].external = 'GDR-WIDGET-ONE' # WIDGET is a group segment
            $raw.domains.beta.rulesets.Remove('thing-three')
            $form = [Catzc.Base.Drs.DrsConfig]::new($raw).CodeForm
            $form.IsRule('GDR-WIDGET-ONE') | Should -BeFalse
            $form.IsRule('GDR-WIDGET-ONE-TURN') | Should -BeTrue
            $form.IsRule('ADR-BE-TWO') | Should -BeFalse
            $form.IsRule('ADR-BE-TWO-TURN') | Should -BeTrue
        }

        It 'gives a domain that owns its kind no code, so its prefix is the kind' {
            $raw = New-ValidRaw
            $raw['kinds'] = [ordered]@{ ADR = [ordered]@{ name = 'Architecture Decision Record'; shared = $true }; GDR = [ordered]@{ name = 'Gadget Decision Record' } }
            $raw.domains.alpha.Remove('code')
            $raw.domains.alpha['kind'] = 'GDR'
            $raw.domains.alpha.rulesets['thing-one'].external = 'GDR-ONE'
            $raw.domains.beta.rulesets.Remove('thing-three')
            $config = [Catzc.Base.Drs.DrsConfig]::new($raw)
            $config.Kinds | Should -Be @('ADR', 'GDR')
            $config.KindName('GDR') | Should -Be 'Gadget Decision Record'
            $alpha = $config.Domains | Where-Object Name -EQ 'alpha'
            $alpha.Code | Should -BeNullOrEmpty
            $alpha.Prefix | Should -Be 'GDR'
            ($config.RuleSets | Where-Object Slug -EQ 'thing-one').Prefix | Should -Be 'GDR'
        }

        It 'throws on a code under an owned kind, a missing code under a shared one, and an unregistered kind' {
            $raw = New-ValidRaw
            $raw['kinds'] = [ordered]@{ ADR = [ordered]@{ name = 'Architecture Decision Record'; shared = $true }; GDR = [ordered]@{ name = 'Gadget Decision Record' } }
            $raw.domains.alpha['kind'] = 'GDR'
            $raw.domains.beta.Remove('code')
            $raw.domains.beta['kind'] = 'XDR'
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*domain 'alpha': has code 'AL', but its kind GDR is its own*"
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*domain 'beta': kind 'XDR' is not a registered kind*"
        }

        It 'throws when two domains claim a kind that is not shared' {
            $raw = New-ValidRaw
            $raw['kinds'] = [ordered]@{ GDR = [ordered]@{ name = 'Gadget Decision Record' } }
            foreach ($name in 'alpha', 'beta') {
                $raw.domains[$name].Remove('code')
                $raw.domains[$name]['kind'] = 'GDR'
            }
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*domain 'beta': kind 'GDR' is owned by domain 'alpha' and is not shared*"
        }
    }

    It 'maps a valid registry to typed domains and flattened rule-sets' {
        $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
        $config.Domains.Count | Should -Be 2
        $config.RuleSets.Count | Should -Be 3
    }

    It 'captures the effective code of a leaf override (not the folder domain code)' {
        $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
        $override = $config.RuleSets | Where-Object Slug -EQ 'thing-three'
        $override.Code | Should -Be 'AL'
        $override.DomainCode | Should -Be 'BE'
        $override.External | Should -Be 'ADR-AL-THREE'
    }

    It 'exposes one typed edge per depends_on link, From depending on To' {
        $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
        $config.Edges | Should -HaveCount 1
        $config.Edges[0] | Should -BeOfType 'Catzc.Base.Drs.DrsDomainEdge'
        $config.Edges[0].From | Should -Be 'beta'
        $config.Edges[0].To | Should -Be 'alpha'
    }

    It 'carries each domain description, trimmed' {
        $raw = New-ValidRaw
        $raw.domains.alpha.description = "  The widget axioms.`n"
        $config = [Catzc.Base.Drs.DrsConfig]::new($raw)
        ($config.Domains | Where-Object Name -EQ 'alpha').Description | Should -Be 'The widget axioms.'
    }

    It 'throws on a domain with no description' {
        $raw = New-ValidRaw
        $raw.domains.beta.Remove('description')
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'beta': missing 'description'*"
    }

    It 'throws on a domain code that is not 2-4 uppercase letters' {
        $raw = New-ValidRaw
        $raw.domains.alpha.code = 'al'
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw '*2-4 uppercase*'
    }

    It 'throws when the external code does not start with its domain prefix' {
        $raw = New-ValidRaw
        $raw.domains.alpha.rulesets['thing-one'].external = 'ADR-XX-ONE' # domain alpha is AL, not XX
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*does not start with its domain's prefix 'ADR-AL'*"
    }

    It 'accepts a one-segment external code, which has no domain segment to match' {
        $raw = New-ValidRaw
        $raw.domains.alpha.rulesets['thing-one'].external = 'ADR-ONE'
        $config = [Catzc.Base.Drs.DrsConfig]::new($raw)
        ($config.RuleSets | Where-Object Slug -EQ 'thing-one').External | Should -Be 'ADR-ONE'
    }

    It 'throws on an external code whose segments are not uppercase letters' {
        $raw = New-ValidRaw
        $raw.domains.alpha.rulesets['thing-one'].external = 'ADR-al-one'
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw '*uppercase segments*'
    }

    It 'throws on a duplicate external code' {
        $raw = New-ValidRaw
        $raw.domains.beta.rulesets['thing-two'].external = 'ADR-AL-ONE'
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw '*duplicates*'
    }

    It 'throws on an unresolved depends_on target' {
        $raw = New-ValidRaw
        $raw.domains.beta.depends_on = @('nowhere')
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw '*not a declared domain*'
    }

    It 'throws on a domain dependency cycle' {
        $raw = New-ValidRaw
        $raw.domains.alpha.depends_on = @('beta') # beta already depends on alpha
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw '*cycle*'
    }

    It 'rejects an unknown top-level key' {
        $raw = New-ValidRaw
        $raw['widget'] = 1
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
            Should -Throw "*unknown top-level key 'widget' (allowed: root, kinds, domains, domain_classes)*"
    }

    It 'keeps every decision record under docs/drs when the registry names no root' {
        [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw)).Root | Should -Be 'docs/drs'
    }

    It 'reads the root the registry names' {
        $raw = New-ValidRaw
        $raw['root'] = 'docs/widgets'
        [Catzc.Base.Drs.DrsConfig]::new($raw).Root | Should -Be 'docs/widgets'
    }

    It 'rejects a root of <Name>' -ForEach @(
        @{ Name = 'a parent segment'; Root = 'docs/../widgets' }
        @{ Name = 'a trailing slash'; Root = 'docs/widgets/' }
        @{ Name = 'a rooted path'; Root = '/docs/widgets' }
    ) {
        $raw = New-ValidRaw
        $raw['root'] = $Root
        { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*root '$Root' must be*"
    }

    Context 'value-chain stack and concerns' -Tag 'DDR-TRACK-VALUECHAINSTACK', 'DDR-TRACK-VALUECHAINCONCERN' {
        It 'declares the stack rows and the concerns once, in value-chain order' {
            [Catzc.Base.Drs.DrsConfig]::Stacks | Should -Be @('PRIN', 'DSGN', 'AUTO', 'PIPE', 'CLOUD')
            [Catzc.Base.Drs.DrsConfig]::Concerns | Should -Be @('automation', 'build', 'quality-control', 'release',
                'deploy', 'access')
        }

        It 'carries each domain''s stack row and default concerns' {
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            $beta = $config.Domains | Where-Object Name -EQ 'beta'
            $beta.Stack | Should -Be 'AUTO'
            $beta.Concerns | Should -Be @('automation')
        }

        It 'gives a ruleset without an override its domain''s stack row and default concerns' {
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            $three = $config.RuleSets | Where-Object Slug -EQ 'thing-three'
            $three.Stack | Should -Be 'AUTO'
            $three.Concerns | Should -Be @('automation')
            $three.DomainConcerns | Should -Be @('automation')
        }

        It 'resolves a ruleset override, in value-chain order, beside the domain default' {
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            $two = $config.RuleSets | Where-Object Slug -EQ 'thing-two'
            $two.Concerns | Should -Be @('release', 'access')
            $two.DomainConcerns | Should -Be @('automation')
        }

        It 'throws on a domain with no stack' {
            $raw = New-ValidRaw
            $raw.domains.alpha.Remove('stack')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': missing 'stack'*"
        }

        It 'throws on a stack that is not a row of the value-chain stack' {
            $raw = New-ValidRaw
            $raw.domains.alpha.stack = 'WIDGET'
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*stack 'WIDGET' is not a row of the value-chain stack*"
        }

        It 'throws on a domain with no default concern' {
            $raw = New-ValidRaw
            $raw.domains.beta.Remove('concern')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'beta': missing 'concern'*"
        }

        It 'throws on an unknown concern in a domain default' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = @('gadgetry')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*domain 'alpha': concern 'gadgetry' is not a value-chain concern*"
        }

        It 'throws on an unknown concern in a ruleset override' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two'].concern = @('build', 'gadgetry')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*ruleset 'beta/thing-two': concern 'gadgetry' is not a value-chain concern*"
        }

        It 'throws on a concern given as a scalar, not a list' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = 'build'
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': 'concern' must be a list*"
        }

        It 'throws on an empty concern override' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two'].concern = @()
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*ruleset 'beta/thing-two': 'concern' must list one or more*"
        }

        It 'throws on a concern listed twice' {
            $raw = New-ValidRaw
            $raw.domains.alpha.concern = @('build', 'build')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*concern 'build' is listed twice*"
        }

        It 'throws on an unknown domain key, so a misspelled key never falls back to the default' {
            $raw = New-ValidRaw
            $raw.domains.alpha['concerns'] = @('build')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'alpha': unknown key 'concerns'*"
        }

        It 'throws on an unknown ruleset key' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two']['concerns'] = @('build')
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*ruleset 'beta/thing-two': unknown key 'concerns'*"
        }
    }

    Context 'the layer of the automation' -Tag 'ADR-AUTO-LAYERS-REALISENEVERREDEFINE' {
        It 'declares the five layers and the default once, and gives a ruleset that names none the default' {
            [Catzc.Base.Drs.DrsConfig]::Layers | Should -Be @('automation', 'contract', 'language', 'engine',
                'importer')
            [Catzc.Base.Drs.DrsConfig]::DefaultLayer | Should -Be 'automation'
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            ($config.RuleSets | Where-Object Slug -EQ 'thing-one').Layer | Should -Be 'automation'
        }

        It 'honours a named layer and throws on one outside the five' {
            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two']['layer'] = 'engine'
            $config = [Catzc.Base.Drs.DrsConfig]::new($raw)
            ($config.RuleSets | Where-Object Slug -EQ 'thing-two').Layer | Should -Be 'engine'

            $raw = New-ValidRaw
            $raw.domains.beta.rulesets['thing-two']['layer'] = 'folder'
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*ruleset 'beta/thing-two': layer 'folder' is not one of: automation, contract, language, engine, importer*"
        }
    }

    Context 'the folder of a domain' {
        It 'gives a domain that names no folder its own name, declared once on the type, and carries it to every ruleset' {
            [Catzc.Base.Drs.DrsConfig]::DefaultFolder('alpha') | Should -Be 'alpha'
            $config = [Catzc.Base.Drs.DrsConfig]::new((New-ValidRaw))
            ($config.Domains | Where-Object Name -EQ 'alpha').Folder | Should -Be 'alpha'
            ($config.RuleSets | Where-Object Slug -EQ 'thing-two').Folder | Should -Be 'beta'
        }

        It 'honours a folder nested in another domain''s folder' {
            $raw = New-ValidRaw
            $raw.domains.beta['folder'] = 'alpha/beta'
            $config = [Catzc.Base.Drs.DrsConfig]::new($raw)
            ($config.Domains | Where-Object Name -EQ 'beta').Folder | Should -Be 'alpha/beta'
            @($config.RuleSets | Where-Object Domain -EQ 'beta').Folder | Should -Be @('alpha/beta', 'alpha/beta')
        }

        It 'throws on a folder that leaves docs/drs or is not a relative path' {
            foreach ($folder in '../alpha', 'alpha/../beta', '/alpha', 'alpha/', 'alphaeta') {
                $raw = New-ValidRaw
                $raw.domains.beta['folder'] = $folder
                { [Catzc.Base.Drs.DrsConfig]::new($raw) } | Should -Throw "*domain 'beta': folder '$folder' must be*"
            }
        }

        It 'throws on two domains with one folder' {
            $raw = New-ValidRaw
            $raw.domains.beta['folder'] = 'alpha'
            { [Catzc.Base.Drs.DrsConfig]::new($raw) } |
                Should -Throw "*domain 'beta': folder 'alpha' is also the folder of domain 'alpha'*"
        }
    }
}
