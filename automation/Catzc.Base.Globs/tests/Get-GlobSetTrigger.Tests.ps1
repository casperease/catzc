<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
    folder: tests
    name: get-glob-set-trigger-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
    cites:
      - ADR-FLOW-CD-GLOBS#1
---
#>

Describe 'Get-GlobSetTrigger' -Tag 'L0', 'logic' {
    It 'projects a simple single-include set to both dialects' {
        $t = & (Get-Module Catzc.Base.Globs) {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('automation/**'), @(), @(), @(), -1, $null)
            Get-GlobSetTrigger -GlobSet $set
        }
        $t.GitHub | Should -Be @('automation/**')
        $t.AdoInclude | Should -Be @('automation/**')
        $t.AdoExclude | Should -Be @()
    }

    It 'renders excludes as GitHub ! negations and ADO exclude entries, in program order' {
        $t = & (Get-Module Catzc.Base.Globs) {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @('src/gen/**'), @(), @(), -1, $null)
            Get-GlobSetTrigger -GlobSet $set
        }
        $t.GitHub | Should -Be @('src/**', '!src/gen/**')
        $t.AdoInclude | Should -Be @('src/**')
        $t.AdoExclude | Should -Be @('src/gen/**')
    }

    It 'nets a base exclude that a later include re-adds to an ADO include (the compose re-add case)' {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'base' = @{ description = 'b'; layer = 'deployable-unit'; include = @('lib/**'); exclude = @('lib/configuration/*/**') }
                    'unit' = @{ description = 'u'; layer = 'deployable-unit'; pipeline = 'cd-unit'; compose = @('base'); include = @('lib/configuration/widget/**') }
                }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        $t = Get-GlobSetTrigger -Name unit
        $t.GitHub | Should -Be @('lib/**', '!lib/configuration/*/**', 'lib/configuration/widget/**')
        $t.AdoInclude | Should -Be @('lib/**', 'lib/configuration/widget/**')
        $t.AdoExclude | Should -Be @('lib/configuration/*/**')
    }

    It 'collapses an exclude re-added at the SAME pattern to a net include (no contradictory ADO entry)' {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'base' = @{ description = 'b'; layer = 'deployable-unit'; include = @('lib/**'); exclude = @('lib/configuration/*.yml') }
                    'unit' = @{ description = 'u'; layer = 'deployable-unit'; pipeline = 'cd-unit'; compose = @('base'); include = @('lib/configuration/*.yml') }
                }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        $t = Get-GlobSetTrigger -Name unit
        $t.AdoInclude | Should -Contain 'lib/configuration/*.yml'
        $t.AdoExclude | Should -Not -Contain 'lib/configuration/*.yml'
    }
}
