<#
---
catzc:
  immutable:
    with_body_sha: de72a561ac24
  edges:
    docs: "[Test-GlobSetAffected.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-PROTGLOB-FAILOPEN
---
#>

Describe 'Test-GlobSetAffected' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'widget' = @{ description = 'the widget surface'; layer = 'loose-fileset'; include = @('src/**') }
                    'gadget' = @{ description = 'the gadget unit'; layer = 'deployable-unit'; include = @('lib/**') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-GlobSetChangeRange { 'HEAD^1..HEAD' } -ModuleName Catzc.Base.Globs
    }

    It 'is true when the change touches the named set' {
        Mock Get-ChangedGlobSet { Get-GlobSet -Name gadget, widget } -ModuleName Catzc.Base.Globs
        Test-GlobSetAffected -Name gadget | Should -BeTrue
    }

    It 'is false when the change does not touch the named set' {
        Mock Get-ChangedGlobSet { Get-GlobSet -Name widget } -ModuleName Catzc.Base.Globs
        Test-GlobSetAffected -Name gadget | Should -BeFalse
    }

    It 'fails open (true) when the reference commit cannot be resolved' {
        Mock Get-GlobSetChangeRange { $null } -ModuleName Catzc.Base.Globs
        Mock Get-ChangedGlobSet { throw 'must not be called when the range is null' } -ModuleName Catzc.Base.Globs
        Test-GlobSetAffected -Name gadget | Should -BeTrue
    }

    It 'fails open (true) when the diff cannot be computed (e.g. a shallow clone)' {
        Mock Get-ChangedGlobSet { throw 'fatal: bad revision HEAD^1' } -ModuleName Catzc.Base.Globs
        Test-GlobSetAffected -Name gadget | Should -BeTrue
    }

    It 'throws on an undeclared globset name (a typo must not silently skip)' {
        { Test-GlobSetAffected -Name nope } | Should -Throw '*not a declared globset*'
    }
}
