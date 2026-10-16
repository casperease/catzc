<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
      source: automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-FLOW-CD-GLOBS#1
---
#>

Describe 'Get-ChangedGlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'widget' = @{ description = 'the widget surface'; layer = 'loose-fileset'; include = @('src/**') }
                    'gadget' = @{ description = 'the gadget unit'; layer = 'deployable-unit'; include = @('lib/**'); exclude = @('lib/gen/**') }
                    'report' = @{ description = 'the report scope'; layer = 'loose-fileset'; include = @('src/**', 'docs/**') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'returns the single declared set a changed path touches' {
        (Get-ChangedGlobSet -ChangedFile @('lib/main.cs', 'other/x.cs')).Name | Should -Be 'gadget'
    }

    It 'returns every set that matches, in registry order' {
        (Get-ChangedGlobSet -ChangedFile @('src/a.cs')).Name | Should -Be @('widget', 'report')
    }

    It 'respects the set exclude program (delegates to Matches)' {
        @(Get-ChangedGlobSet -ChangedFile @('lib/gen/x.cs')).Count | Should -Be 0
    }

    It 'returns nothing for an empty changed set' {
        @(Get-ChangedGlobSet -ChangedFile @()).Count | Should -Be 0
    }

    It 'resolves changed paths from a range via Get-ChangedFile' {
        Mock Get-ChangedFile { @('lib/service.cs') } -ModuleName Catzc.Base.Globs
        (Get-ChangedGlobSet -Range 'HEAD^1..HEAD').Name | Should -Be 'gadget'
        Should -Invoke Get-ChangedFile -ModuleName Catzc.Base.Globs -ParameterFilter { $Range -eq 'HEAD^1..HEAD' }
    }

    It 'also matches derived module sets under -IncludeModules' {
        Mock Get-ModuleGlobSet {
            [Catzc.Base.Globs.GlobSet]::new('catzc-widget', 'd', 'module', @('automation/Widget/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.Globs
        (Get-ChangedGlobSet -ChangedFile @('automation/Widget/Get-Foo.ps1') -IncludeModules).Name | Should -Be 'catzc-widget'
    }
}
