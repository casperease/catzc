<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/tests/Merge-ConfigFragment.Tests.ps1
    folder: tests
    name: merge-config-fragment-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Merge-ConfigFragment' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:merge = {
            param($Base, $Fragment)
            & (Get-Module Catzc.Base.Config) { param($b, $f) Merge-ConfigFragment -Base $b -Fragment $f } $Base $Fragment
        }
        $script:newBase = {
            [ordered]@{
                owner   = 'widget'
                limit   = 3
                tags    = @('alpha', 'beta')
                gadgets = [ordered]@{
                    lever  = [ordered]@{ size = 1; color = 'red' }
                    sprung = [ordered]@{ size = 2 }
                }
            }
        }
    }

    It 'keeps every key the fragment does not name' {
        $merged = & $merge (& $newBase) ([ordered]@{ limit = 5 })
        $merged.owner | Should -Be 'widget'
        $merged.limit | Should -Be 5
        @($merged.tags) | Should -Be @('alpha', 'beta')
        $merged.gadgets.lever.color | Should -Be 'red'
    }

    It 'merges maps key by key, recursively' {
        $merged = & $merge (& $newBase) ([ordered]@{ gadgets = [ordered]@{ lever = [ordered]@{ color = 'blue' }; gizmo = [ordered]@{ size = 9 } } })
        $merged.gadgets.lever.color | Should -Be 'blue'
        $merged.gadgets.lever.size | Should -Be 1
        $merged.gadgets.sprung.size | Should -Be 2
        $merged.gadgets.gizmo.size | Should -Be 9
    }

    It 'replaces a list rather than appending to it' {
        $merged = & $merge (& $newBase) ([ordered]@{ tags = @('gamma') })
        @($merged.tags) | Should -Be @('gamma')
    }

    It 'removes a key the fragment sets to null, so the type''s default applies' {
        $merged = & $merge (& $newBase) ([ordered]@{ limit = $null; gadgets = [ordered]@{ sprung = $null } })
        $merged.Contains('limit') | Should -BeFalse
        $merged.gadgets.Contains('sprung') | Should -BeFalse
        $merged.gadgets.Contains('lever') | Should -BeTrue
    }

    It 'replaces a scalar with a map and a map with a scalar' {
        $merged = & $merge (& $newBase) ([ordered]@{ owner = [ordered]@{ name = 'gadget' }; gadgets = 'none' })
        $merged.owner.name | Should -Be 'gadget'
        $merged.gadgets | Should -Be 'none'
    }

    It 'changes neither input' {
        $base = & $newBase
        $fragment = [ordered]@{ gadgets = [ordered]@{ lever = [ordered]@{ color = 'blue' } }; limit = $null }
        $null = & $merge $base $fragment
        $base.gadgets.lever.color | Should -Be 'red'
        $base.limit | Should -Be 3
        $fragment.Contains('limit') | Should -BeTrue
    }
}
