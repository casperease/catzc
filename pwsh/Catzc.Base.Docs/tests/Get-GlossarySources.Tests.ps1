<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-GlossarySources' -Tag 'L0', 'logic' {
    BeforeAll {
        $assets = "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/tests/assets/glossary"
        # One shared holder: each test sets the owners the seam lists (in this, already sorted, order).
        $script:fixture = @{
            Paths  = [ordered]@{
                'Catzc.Base.Docs'  = "$assets/gadget/glossary.yml"
                'Catzc.Base.Files' = "$assets/widget/glossary.yml"
            }
            Owners = @()
        }
        # A mock defines only the parameters its caller passed, so -All / -Module are probed, not read bare (strict mode).
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'glossary' } -MockWith {
            $entries = foreach ($owner in $script:fixture.Owners) {
                @{ Name = 'glossary'; Module = $owner; Path = Join-Path (Get-RepositoryRoot) $script:fixture.Paths[$owner] }
            }
            if ($ExecutionContext.SessionState.PSVariable.GetValue('All')) {
                $entries
            }
            else {
                $requested = $ExecutionContext.SessionState.PSVariable.GetValue('Module')
                $entries | Where-Object { $_.Module -eq $requested }
            }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { $Path }
        # The source-tree guard is its own unit; here the fixture stands in for the source tree in either run mode.
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
    }

    It 'returns nothing when no module ships a glossary' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $script:fixture.Owners = @()
        @(InModuleScope Catzc.Base.Docs { Get-GlossarySources }).Count | Should -Be 0
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Docs -Times 0 -Exactly
    }

    It 'returns one source with its owner, repo-relative path, validated config, and tracked state' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $script:fixture.Owners = @('Catzc.Base.Files')
        $sources = @(InModuleScope Catzc.Base.Docs { Get-GlossarySources })
        $sources.Count | Should -Be 1
        $sources[0].Owner | Should -Be 'Catzc.Base.Files'
        $sources[0].Path | Should -Be $script:fixture.Paths['Catzc.Base.Files']
        $sources[0].Config | Should -BeOfType ([Catzc.Base.Docs.GlossaryConfig])
        $sources[0].Config.concepts.term | Should -Be @('widget suite', 'alpha widget')
        $sources[0].Tracked | Should -BeTrue
    }

    It 'reads every source through its own owner (-Module), in the listed owner order' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $script:fixture.Owners = @('Catzc.Base.Docs', 'Catzc.Base.Files')
        $sources = @(InModuleScope Catzc.Base.Docs { Get-GlossarySources })
        $sources.Owner | Should -Be @('Catzc.Base.Docs', 'Catzc.Base.Files')
        $sources[0].Config.concepts.term | Should -Be @('gadget run')
        $sources[1].Config.concepts.term | Should -Be @('widget suite', 'alpha widget')
        $sources[1].Config.options.checks | Should -Be @('avoid')
    }

    It 'asks git about every source in one query and marks an untracked one' -Tag 'ADR-REPO-VOCAB-SOURCESINREPOSITORY' {
        $script:fixture.Owners = @('Catzc.Base.Docs', 'Catzc.Base.Files')
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { $Path | Where-Object { $_ -like '*/gadget/*' } }
        $sources = @(InModuleScope Catzc.Base.Docs { Get-GlossarySources })
        $sources.Tracked | Should -Be @($true, $false)
        $expected = @($script:fixture.Paths.Values) -join '|'
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Docs -Times 1 -Exactly -ParameterFilter { ($Path -join '|') -eq $expected }
    }

    It 'surfaces a malformed source through the type on load' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $broken = Join-Path $TestDrive 'broken.yml'
        Set-Content -Path $broken -Value 'concepts: {}'
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'glossary' } -MockWith {
            @{ Name = 'glossary'; Module = 'Catzc.Base.Docs'; Path = (Join-Path $TestDrive 'broken.yml') }
        }
        { InModuleScope Catzc.Base.Docs { Get-GlossarySources } } | Should -Throw '*glossary config validation failed*'
    }

    It 'refuses to run outside the source tree' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'Get-GlossarySources operates on the catzc source tree' }
        { InModuleScope Catzc.Base.Docs { Get-GlossarySources } } | Should -Throw '*source tree*'
    }
}
