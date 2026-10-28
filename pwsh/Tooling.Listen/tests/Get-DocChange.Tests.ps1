Describe 'Get-DocChange' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'reports nothing when the folder is as the session saw it' {
        @(Get-DocChange -Session $script:session).Count | Should -Be 0
    }

    It 'reports nothing for a save of the same bytes' {
        $path = Join-Path $script:root 'docs/drs/widget.md'
        [System.IO.File]::WriteAllText($path, [System.IO.File]::ReadAllText($path))
        [System.IO.File]::SetLastWriteTimeUtc($path, [DateTime]::UtcNow.AddMinutes(5))
        @(Get-DocChange -Session $script:session).Count | Should -Be 0
    }

    It 'reports a modified file with its kind, tier, cited rules and diff' {
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nThe widget rule, ADR-WIDGET-PARTS-SINGLE and ADR-WIDGET-PARTS-DOUBLE.`n"
        $change = @(Get-DocChange -Session $script:session)
        $change.Count | Should -Be 1
        $change[0].Path | Should -BeExactly 'docs/drs/widget.md'
        $change[0].Change | Should -BeExactly 'modified'
        $change[0].Kind | Should -BeExactly 'record'
        $change[0].Tier | Should -BeExactly 'rule'
        $change[0].Rules | Should -Be @('ADR-WIDGET-PARTS-DOUBLE', 'ADR-WIDGET-PARTS-SINGLE')
        $change[0].Diff | Should -BeLike '@@*'
        $change[0].Diff | Should -BeLike '*+The widget rule, ADR-WIDGET-PARTS-SINGLE and ADR-WIDGET-PARTS-DOUBLE.*'
    }

    It 'lists only the rules cited in the changed lines, not the ones the unchanged lines cite' {
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nThe widget rule, ADR-WIDGET-PARTS-SINGLE.`n`nThe gadget rule, ADR-GADGET-TURNS-ONCE.`n"
        $change = @(Get-DocChange -Session $script:session)
        $change[0].Rules | Should -Be @('ADR-GADGET-TURNS-ONCE')
    }

    It 'says who wrote each change: the editor''s exact save, an agent''s exact write, or nobody the ledgers know' {
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nSaved by the editor.`n"
        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nWritten by an agent.`n"
        Write-ListenFixtureFile 'docs/gizmo.md' "# Gizmo`n`nFrom a checkout.`n"
        $hashOf = { param($relative) [Catzc.Base.Globs.DurableHash]::HashFile((Join-Path $script:root $relative)) }
        $at = [DateTimeOffset]::Now.AddMinutes(-30).ToString('o')
        Write-ListenFixtureFile ([Catzc.Tooling.Listen.WriteLedger]::EditorLedger) ([Catzc.Tooling.Listen.WriteLedger]::Line($at, 'save', 'docs/drs/widget.md', (& $hashOf 'docs/drs/widget.md'), $null, $null) + "`n")
        Write-ListenFixtureFile ([Catzc.Tooling.Listen.WriteLedger]::AgentLedger) ([Catzc.Tooling.Listen.WriteLedger]::Line($at, 'write', 'docs/explanation/gadget.md', (& $hashOf 'docs/explanation/gadget.md'), 'gadget-session', 'call-1') + "`n")

        $changes = @(Get-DocChange -Session $script:session)
        @($changes.Path) | Should -Be @('docs/drs/widget.md', 'docs/explanation/gadget.md', 'docs/gizmo.md')
        @($changes.Source) | Should -Be @('editor', 'agent', 'unknown')
        $changes[1].Agent | Should -BeExactly 'gadget-session'
        $changes[0].Agent | Should -BeNullOrEmpty
    }

    It 'reports added and deleted files, in path order, and the rest tier for an unknown kind' {
        Write-ListenFixtureFile 'docs/gizmo.md' "# Gizmo`n"
        [System.IO.File]::Delete((Join-Path $script:root 'docs/explanation/gadget.md'))
        $changes = @(Get-DocChange -Session $script:session)
        @($changes.Path) | Should -Be @('docs/explanation/gadget.md', 'docs/gizmo.md')
        @($changes.Change) | Should -Be @('deleted', 'added')
        $changes[0].Diff | Should -BeLike '*-Why the gadget turns.*'
        $changes[1].Tier | Should -BeExactly 'code'
        $changes[1].Kind | Should -BeNullOrEmpty
    }

    It 'pairs a deleted and an added file with the same bytes as one rename' {
        $old = Join-Path $script:root 'docs/explanation/gadget.md'
        Write-ListenFixtureFile 'docs/explanation/gadget-turns.md' ([System.IO.File]::ReadAllText($old))
        [System.IO.File]::Delete($old)
        $change = @(Get-DocChange -Session $script:session)
        $change.Count | Should -Be 1
        $change[0].Change | Should -BeExactly 'renamed'
        $change[0].From | Should -BeExactly 'docs/explanation/gadget.md'
        $change[0].Path | Should -BeExactly 'docs/explanation/gadget-turns.md'
    }

    It 'keeps the whole arc against the baseline after seen has moved on, and filters by -Path' {
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nFirst edit.`n"
        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nAnother edit.`n"
        Update-DocSnapshot -Session $script:session -Path 'docs/drs/widget.md', 'docs/explanation/gadget.md'
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nSecond edit.`n"

        $seen = @(Get-DocChange -Session $script:session -Path 'docs/drs/widget.md')
        $seen[0].Diff | Should -BeLike '*-First edit.*+Second edit.*'
        $arc = @(Get-DocChange -Session $script:session -Against Baseline -Path 'docs/drs/widget.md')
        $arc.Count | Should -Be 1
        $arc[0].Diff | Should -BeLike '*-The widget rule*+Second edit.*'
        @(Get-DocChange -Session $script:session -Against Baseline).Count | Should -Be 2
    }
}
