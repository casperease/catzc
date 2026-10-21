<#
---
catzc:
  immutable:
    with_body_sha: "8278ebdb2ecd"
  edges:
    docs: "[Get-AutoControlledGlobs.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-git/tests/Get-AutoControlledGlobs.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
    cites:
      - ADR-REPO-OUTDIR-PLANNOTES
---
#>

Describe 'Get-AutoControlledGlobs' -Tag 'L0', 'logic' {
    BeforeEach {
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
        $modules = Get-CatzcModulesFolder
        foreach ($expected in "$modules/*/*.psd1", '*/README.md', '.cspell/*', 'out/*', '.vscode/*', "$modules/.compiled/*.tmp") {
            $globs | Should -Contain $expected
        }
    }

    It 'matches the generated shapes and rejects plausible in-flight work' {
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        # Reset-GitCleanFxd's classification: any inclusion matches and no '!' exclusion does.
        $isControlled = {
            param($candidate)
            foreach ($glob in $globs) {
                if ($glob.StartsWith('!') -and $candidate -like $glob.Substring(1)) {
                    return $false
                }
            }
            foreach ($glob in $globs) {
                if (-not $glob.StartsWith('!') -and $candidate -like $glob) {
                    return $true
                }
            }
            $false
        }
        $modules = Get-CatzcModulesFolder
        & $isControlled "$modules/Catzc.Base.Git/Catzc.Base.Git.psd1" | Should -BeTrue
        & $isControlled 'infrastructure/README.md' | Should -BeTrue
        # the generated ADR pages are committed, so a clean never deletes them
        & $isControlled 'docs/drs/index.md' | Should -BeFalse
        & $isControlled 'docs/drs/glossary.md' | Should -BeFalse
        & $isControlled 'docs/drs/repository/new-draft.md' | Should -BeFalse
        & $isControlled 'out/report-widget.md' | Should -BeTrue
        & $isControlled 'out/plan-widget.md' | Should -BeFalse
        & $isControlled "$modules/Catzc.Base.Git/New-Draft.ps1" | Should -BeFalse
        & $isControlled "$modules/.compiled/Catzc.Types.abc123.dll" | Should -BeFalse
        # drawio autosave shadows are disposable clutter; the committed asset beside them is NOT
        & $isControlled 'docs/.assets/deployable-units/.$apex.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/modules/.$catzc-azure.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/deployable-units/apex.drawio.png' | Should -BeFalse
    }
}
