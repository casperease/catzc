Describe 'Get-ChangeCheckPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($relative in 'a.wdg', 'b.wdg', 'c.gdg', 'd.txt', 'e.none') {
            [System.IO.File]::WriteAllText((Join-Path ([System.IO.Directory]::CreateDirectory($script:root).FullName) $relative), '')
        }
        $widget = [Catzc.Base.Languages.FileLanguage]::new('widget', @('.wdg'), $null, 'fixture', $null, $null,
            @('Test-WidgetLint', 'Test-Spelling'))
        $gadget = [Catzc.Base.Languages.FileLanguage]::new('gadget', @('.gdg'), $null, 'fixture', $null, $null,
            @('Test-Spelling'))
        $silent = [Catzc.Base.Languages.FileLanguage]::new('silent', @('.txt'), $null, 'fixture', $null, $null, @())
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.wdg' } { $widget }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.gdg' } { $gadget }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.txt' } { $silent }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.none' } { }
        $script:plan = {
            param([string[]] $Changed)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Changed; R = $script:root } {
                param($C, $R)
                Get-ChangeCheckPlan -Path $C -RepositoryRoot $R
            }
        }
    }

    It 'groups the changed files under each gate their language names, gates in first-appearance order' {
        $plan = @(& $script:plan @('a.wdg', 'c.gdg', 'b.wdg'))
        $plan.Check | Should -Be @('Test-WidgetLint', 'Test-Spelling')
        $plan[0].Path | Should -Be @('a.wdg', 'b.wdg')
        $plan[1].Path | Should -Be @('a.wdg', 'c.gdg', 'b.wdg')
    }

    It 'skips a deleted file, a file with no language, and a language that names no check' {
        @(& $script:plan @('gone.wdg', 'e.none', 'd.txt')) | Should -HaveCount 0
    }

    It 'gives a check with a scope only the changed files under the folder its config address names, and a check without one every file' {
        $null = [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'sprockets'))
        foreach ($relative in 'f.spr', 'sprockets/g.spr', 'sprockets-extra.spr') {
            [System.IO.File]::WriteAllText((Join-Path $script:root $relative), '')
        }
        $scopes = [System.Collections.Generic.Dictionary[string, string]]::new()
        $scopes['Test-SprocketLint'] = 'global.sprockets.folder'
        $sprocket = [Catzc.Base.Languages.FileLanguage]::new('sprocket', @('.spr'), $null, 'fixture', $null, $null,
            @('Test-SprocketLint', 'Test-Spelling'),
            $null, $null, $null, $false, $null, $scopes)
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.spr' } { $sprocket }
        Mock Get-ConfigValue -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Address -eq 'global.sprockets.folder' } { 'sprockets/' }

        $plan = @(& $script:plan @('f.spr', 'sprockets/g.spr', 'sprockets-extra.spr'))
        $plan.Check | Should -Be @('Test-Spelling',
            'Test-SprocketLint') -Because 'the first changed file is outside the folder, so the check with a scope appears later'
        $plan[0].Path | Should -Be @('f.spr', 'sprockets/g.spr', 'sprockets-extra.spr')
        $plan[1].Path |
            Should -Be @('sprockets/g.spr') -Because 'a sibling folder that merely starts with the same letters is outside the scope'
    }

    It 'plans no check for a file outside the scope when the check with a scope is the only one its language names' {
        $scopes = [System.Collections.Generic.Dictionary[string, string]]::new()
        $scopes['Test-LonelyLint'] = 'global.loners.folder'
        $lonely = [Catzc.Base.Languages.FileLanguage]::new('lonely', @('.lon'), $null, 'fixture', $null, $null,
            @('Test-LonelyLint'),
            $null, $null, $null, $false, $null, $scopes)
        [System.IO.File]::WriteAllText((Join-Path $script:root 'h.lon'), '')
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.lon' } { $lonely }
        Mock Get-ConfigValue -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Address -eq 'global.loners.folder' } { 'loners' }

        @(& $script:plan @('h.lon')) | Should -HaveCount 0
    }
}

Describe 'Get-ChangeCheckPlan — the shipped languages.yml and plans.yml' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:plan = {
            param([string[]] $Changed)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Changed; R = (Get-RepositoryRoot) } {
                param($C, $R)
                Get-ChangeCheckPlan -Path $C -RepositoryRoot $R
            }
        }
    }

    It 'hands Test-Plans a changed plan and not a changed docs article, while the other markdown gates take both' {
        $plan = @(& $script:plan @('.claude/plans/plan-master.md', 'docs/how-to/pwsh/manual-test-plan.md'))
        ($plan | Where-Object Check -EQ 'Test-Plans').Path | Should -Be @('.claude/plans/plan-master.md')
        ($plan | Where-Object Check -EQ 'Test-Spelling').Path | Should -Be @('.claude/plans/plan-master.md',
            'docs/how-to/pwsh/manual-test-plan.md')
    }

    It 'plans no Test-Plans run when only docs articles changed' {
        @(& $script:plan @('docs/how-to/pwsh/manual-test-plan.md')).Check | Should -Not -Contain 'Test-Plans'
    }

    It 'reaches Test-Change: its plan names Test-Plans for a changed plan and for no docs article' {
        (Test-Change -Path 'docs/how-to/pwsh/manual-test-plan.md' -DryRun).Checks.Check |
            Should -Not -Contain 'Test-Plans'
        (Test-Change -Path '.claude/plans/plan-master.md' -DryRun).Checks.Check | Should -Contain 'Test-Plans'
    }
}
