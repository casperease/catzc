Describe 'Get-AutoControlledGlobs' -Tag 'L0', 'logic' {
    BeforeEach {
        # A fixture registry: one gitignored managed target (belongs in the whitelist), one committed
        # managed target (importer.ps1-shaped — must NOT be whitelisted), one not opted in.
        Mock Get-Config {
            [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = '.editorconfig'; optIn = $true; committed = $false }
                    [pscustomobject]@{ target = 'importer.ps1'; optIn = $true; committed = $true }
                    [pscustomobject]@{ target = 'LICENSE'; optIn = $false; committed = $false }
                )
            }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Config -eq 'rootconfig' }
    }

    It 'includes the gitignored managed root-config targets, and only those' {
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        $globs | Should -Contain '.editorconfig'
        $globs | Should -Not -Contain 'importer.ps1'
        $globs | Should -Not -Contain 'LICENSE'
    }

    It 'includes the conventional generated-artifact classes' {
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        foreach ($expected in 'automation/*/*.psd1', '*/README.md', '.cspell/*', 'out/*', '.vscode/*', 'automation/.compiled/*.tmp') {
            $globs | Should -Contain $expected
        }
    }

    It 'matches the generated shapes and rejects plausible in-flight work' {
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        $isControlled = {
            param($candidate)
            foreach ($glob in $globs) {
                if ($candidate -like $glob) {
                    return $true
                }
            }
            $false
        }
        & $isControlled 'automation/Catzc.Base.Git/Catzc.Base.Git.psd1' | Should -BeTrue
        & $isControlled 'infrastructure/README.md' | Should -BeTrue
        & $isControlled 'out/plan-obj.md' | Should -BeTrue
        & $isControlled 'automation/Catzc.Base.Git/New-Draft.ps1' | Should -BeFalse
        & $isControlled 'automation/.compiled/Catzc.Types.abc123.dll' | Should -BeFalse
        # drawio autosave shadows are disposable clutter; the committed asset beside them is NOT
        & $isControlled 'docs/.assets/deployable-units/.$apex.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/modules/.$catzc-azure.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/deployable-units/apex.drawio.png' | Should -BeFalse
    }
}
