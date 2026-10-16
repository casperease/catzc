<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/tests/types/GitIgnoreSection.Tests.ps1
    folder: tests/types
    name: git-ignore-section-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'GitIgnoreSection' -Tag 'L0', 'logic' {
    It 'constructs a static section with mixed bare and noted patterns' {
        $s = [Catzc.Base.Git.GitIgnoreSection]::new(@{
                id = 'output'; title = 'Output'; why = 'Generated artifacts.'
                patterns = @('out/*', @{ pattern = '!out/.gitkeep'; note = 'anchor' })
            })
        @($s.patterns).Count | Should -Be 2
        $s.patterns[1].note | Should -Be 'anchor'
        $s.inject | Should -BeNullOrEmpty
    }

    It 'constructs an inject section' {
        $s = [Catzc.Base.Git.GitIgnoreSection]::new(@{ id = 'rc'; title = 'Managed'; why = 'Injected.'; inject = 'provider-x' })
        $s.inject | Should -Be 'provider-x'
        @($s.patterns).Count | Should -Be 0
    }

    It 'throws when both or neither of patterns/inject are declared' {
        { [Catzc.Base.Git.GitIgnoreSection]::new(@{ id = 's'; title = 't'; why = 'w'; patterns = @('a'); inject = 'p' }) } |
            Should -Throw '*exactly one*'
        { [Catzc.Base.Git.GitIgnoreSection]::new(@{ id = 's'; title = 't'; why = 'w' }) } | Should -Throw '*exactly one*'
    }

    It 'throws when a required field is missing' {
        { [Catzc.Base.Git.GitIgnoreSection]::new(@{ title = 't'; why = 'w'; patterns = @('a') }) } | Should -Throw '*id is required*'
        { [Catzc.Base.Git.GitIgnoreSection]::new(@{ id = 's'; title = 't'; patterns = @('a') }) } | Should -Throw '*why is required*'
    }
}
