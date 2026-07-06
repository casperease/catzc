Describe 'New-GitIgnore' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam (ADR-TEST:2): a small fixture registry with one static zone (a
        # noted and a bare pattern) and one injected zone.
        Mock Get-Config -ModuleName Catzc.Base.Git {
            [pscustomobject]@{
                zones = @(
                    [Catzc.Base.Git.GitIgnoreZone]::new(@{
                            id = 'output'; title = 'Output directory'
                            why      = 'All generated artifacts land in the output folder and never enter git.'
                            patterns = @('out/*', @{ pattern = '!out/.gitkeep'; note = 'keep the folder' })
                        })
                    [Catzc.Base.Git.GitIgnoreZone]::new(@{
                            id = 'root-config'; title = 'Managed copies'
                            why    = 'Injected from the root-config registry.'
                            inject = 'rootconfig-committed-false'
                        })
                )
            }
        }
    }

    It 'renders the header, the zones in order, and the injected patterns' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/.editorconfig', '/cspell.yml') }
        $text | Should -Match '^# GENERATED FILE'
        $text | Should -Match ([regex]::Escape('configs/gitignore.yml'))
        $text.IndexOf('Output directory') | Should -BeLessThan $text.IndexOf('Managed copies')
        $text | Should -Match ([regex]::Escape("/.editorconfig`n/cspell.yml"))
    }

    It 'renders patterns verbatim with the note as an aligned trailing comment' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $lines = $text -split "`n"
        $lines | Should -Contain 'out/*'
        @($lines | Where-Object { $_ -match '^!out/\.gitkeep\s+# keep the folder$' }) | Should -HaveCount 1
    }

    It 'wraps the why into comment lines under the zone rule' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @() }
        $text | Should -Match '# All generated artifacts land in the output folder and never enter git\.'
    }

    It 'renders an empty injected list as a titled, empty zone' {
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
    It 'renders the shipped registry with the root-config provider (every zone resolves)' {
        $text = New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/PSScriptAnalyzerSettings.psd1') }
        $text | Should -Match ([regex]::Escape('automation/**/*.psd1'))
        $text | Should -Match ([regex]::Escape('**/README.md'))
        $text | Should -Match ([regex]::Escape('/PSScriptAnalyzerSettings.psd1'))
    }
}
