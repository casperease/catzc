# Get-ChangedGlobSet: the computed area-of-control of a diff (ADR-FLOW-CD-GLOBS:1) — the declared sets whose scan
# program selects a changed path, reflected from git at real refs instead of from a committed marker hash.
Describe 'Get-ChangedGlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        # Neutral fixture globset names (widget/gadget/report), not the shipped set names, so this logic test
        # owns its inputs (ADR-AUTO-TEST:3). 'report' overlaps 'widget' on src/** (both loose-filesets, the
        # independence-exempt layer) to prove multi-set matches come back in registry order.
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
