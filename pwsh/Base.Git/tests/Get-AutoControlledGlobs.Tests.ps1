Describe 'Get-AutoControlledGlobs' -Tag 'L0', 'logic' {
    BeforeEach {
        # One gitignored managed target (whitelisted), one committed one (never whitelisted), one not opted in.
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

    It 'takes the gitignored members a generator writes from the track model, a folder glob as its folder and contents' -Tag 'DDR-TRACK-ISPLACEDCLUSTER' {
        Mock Get-TrackMember -ModuleName Catzc.Base.Git {
            foreach ($path in 'widget/*/*.wdg', 'widget/build/**', 'widget/notes.txt') {
                [Catzc.Base.Variants.TrackMember]::new('widget', [Catzc.Base.Variants.VariantMember]::new($path, $false, $false))
            }
            [Catzc.Base.Variants.TrackMember]::new('widget', [Catzc.Base.Variants.VariantMember]::new('widget/cache', $true, $false))
        }
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.Git {
            [pscustomobject]@{ path = 'widget/*/*.wdg'; generator = 'Build-Widget' }
            [pscustomobject]@{ path = 'widget/build/**'; generator = 'dotnet build' }
        }
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        foreach ($expected in 'widget/*/*.wdg', 'widget/build', 'widget/build/*', 'widget/cache') {
            $globs | Should -Contain $expected
        }
        $globs | Should -Not -Contain 'widget/notes.txt' -Because 'a gitignored member no generator writes is in-flight work, never cleaned'
    }

    It 'takes a generated folder member on disk, such as the out track''s out, as the folder and its contents' -Tag 'DDR-TRACK-ISPLACEDCLUSTER' {
        $root = Join-Path $TestDrive "root-$([guid]::NewGuid().ToString('N'))"
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'widget-out')) | Out-Null
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Git { $root }
        Mock Get-TrackMember -ModuleName Catzc.Base.Git {
            [Catzc.Base.Variants.TrackMember]::new('widget_out', [Catzc.Base.Variants.VariantMember]::new('widget-out', $true, $false))
        }
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.Git { }
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        $globs | Should -Contain 'widget-out'
        $globs | Should -Contain 'widget-out/*'
    }

    It 'includes the conventional generated-artifact classes' {
        $globs = InModuleScope Catzc.Base.Git { Get-AutoControlledGlobs }
        $modules = Get-CatzcModulesFolder
        foreach ($expected in "$modules/*/*.psd1", '*/README.md', '.cspell/*', 'out/*', '.vscode/*',
            "$modules/.compiled/*.dll", "$modules/.compiled/*.tmp") {
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
        # Authored plan files are working notes, not output.
        & $isControlled 'out/plan-widget.md' | Should -BeFalse
        & $isControlled "$modules/Catzc.Base.Git/New-Draft.ps1" | Should -BeFalse
        & $isControlled "$modules/.compiled/Catzc.Types.abc123.dll" | Should -BeTrue
        & $isControlled "$modules/.compiled/Catzc.Types.abc123.json" | Should -BeFalse
        # drawio autosave shadows are disposable clutter; the committed asset beside them is NOT
        & $isControlled 'docs/.assets/deployable-units/.$apex.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/modules/.$catzc-azure.drawio.png.bkp' | Should -BeTrue
        & $isControlled 'docs/.assets/deployable-units/apex.drawio.png' | Should -BeFalse
    }
}
