<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/tests/types/GitIgnoreConfig.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Git
    relatives:
      source: automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
---
#>

Describe 'GitIgnoreConfig' -Tag 'L0', 'logic' {
    It 'constructs and exposes sections in registry order' {
        $c = [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                sections = @(
                    @{ id = 'a'; title = 'A'; why = 'w'; patterns = @('x') }
                    @{ id = 'b'; title = 'B'; why = 'w'; inject = 'p' }
                )
            })
        @($c.sections.id) | Should -Be @('a', 'b')
    }

    It 'throws when sections is missing or empty' {
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{}) } | Should -Throw "*'sections' must be a list*"
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{ sections = @() }) } | Should -Throw "*'sections' must be a list*"
    }

    It 'throws on a duplicate section id (case-insensitive)' {
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                    sections = @(
                        @{ id = 'a'; title = 'A'; why = 'w'; patterns = @('x') }
                        @{ id = 'A'; title = 'B'; why = 'w'; patterns = @('y') }
                    )
                }) } | Should -Throw '*duplicate section id*'
    }

    It 'collects every malformed section into one error' {
        $construct = {
            [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                    sections = @(
                        @{ title = 'no id'; why = 'w'; patterns = @('x') }
                        @{ id = 'both'; title = 't'; why = 'w'; patterns = @('a'); inject = 'p' }
                    )
                })
        }
        $construct | Should -Throw '*id is required*'
        $construct | Should -Throw '*exactly one*'
    }

    It 'rejects an unknown top-level key' {
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{ widget = 1 }) } | Should -Throw "*unknown top-level key 'widget'*"
    }
}
