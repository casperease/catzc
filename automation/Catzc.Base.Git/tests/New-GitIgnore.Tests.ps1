<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1
    folder: tests
    name: new-git-ignore-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-git/tests/New-GitIgnore.Tests.ps1.md
    cites:
      - ADR-PWSH-PESTER#2
---
#>

Describe 'New-GitIgnore' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.Git {
            [pscustomobject]@{
                sections = @(
                    [Catzc.Base.Git.GitIgnoreSection]::new(@{
                            id = 'output'; title = 'Output directory'
                            why      = 'All generated artifacts land in the output folder and never enter git.'
                            patterns = @('out/*', @{ pattern = '!out/.gitkeep'; note = 'keep the folder' })
                        })
                    [Catzc.Base.Git.GitIgnoreSection]::new(@{
                            id = 'root-config'; title = 'Managed copies'
                            why    = 'Injected from the root-config registry.'
                            inject = 'rootconfig-committed-false'
                        })
                )
            }
        }
    }

    It 'renders the sections in order and the injected patterns, with no head of its own' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/.editorconfig', '/cspell.yml') }
        $text | Should -Not -Match 'GENERATED FILE'
        $text | Should -Match '^# ──'
        $text.IndexOf('Output directory') | Should -BeLessThan $text.IndexOf('Managed copies')
        $text | Should -Match ([regex]::Escape("/.editorconfig`n/cspell.yml"))
    }

    It 'renders patterns verbatim, each note on its own comment line above its pattern (git has no trailing comments)' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $lines = $text -split "`n"
        $lines | Should -Contain 'out/*'
        $at = [array]::IndexOf($lines, '!out/.gitkeep')
        $at | Should -BeGreaterThan 0
        $lines[$at - 1] | Should -BeExactly '# keep the folder'
        @($lines | Where-Object { $_ -notmatch '^#' -and $_ -match '#' }) | Should -BeNullOrEmpty
    }

    It 'wraps the why into comment lines under the section rule' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $text | Should -Match '# All generated artifacts land in the output folder and never enter git\.'
    }

    It 'renders an empty injected list as a titled, empty section' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $text | Should -Match ([regex]::Escape('Managed copies'))
    }

    It 'throws on an inject provider the caller did not supply' {
        { New-GitIgnore } | Should -Throw '*inject provider*did not supply*'
    }

    It 'ends with exactly one trailing newline' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $text.EndsWith("`n") | Should -BeTrue
        $text.EndsWith("`n`n") | Should -BeFalse
    }
}

Describe 'New-GitIgnore — real gitignore.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the root-config provider (every section resolves)' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/PSScriptAnalyzerSettings.psd1') }
        $text | Should -Match ([regex]::Escape('automation/**/*.psd1'))
        $text | Should -Match ([regex]::Escape('**/README.md'))
        $text | Should -Match ([regex]::Escape('/PSScriptAnalyzerSettings.psd1'))
    }
}
