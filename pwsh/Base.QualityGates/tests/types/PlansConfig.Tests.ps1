Describe 'Catzc.Base.QualityGates.PlansConfig' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.QualityGates.PlansConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the PlansConfig constructor to throw'
        }
    }

    It 'declares every default once: an empty mapping gives the folder, the sets, the roof and the name patterns' {
        $config = [Catzc.Base.QualityGates.PlansConfig]::new(@{})
        $config.folder | Should -Be '.claude/plans'
        $config.statuses | Should -Be @('active', 'blocked')
        $config.ranks[0] | Should -Be 'highest'
        $config.head_required | Should -Be @('status', 'value', 'reviewed', 'targets')
        $config.sections_required | Should -Be @('Open steps')
        $config.master_file | Should -Be 'plan-master.md'
        $config.tasks_max | Should -Be 50
        $config.names.Count | Should -Be 6
    }

    It 'honours a declared folder, roof, set and pattern' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        $config = [Catzc.Base.QualityGates.PlansConfig]::new([ordered]@{
                folder   = 'widgets/plans/'
                statuses = @('active')
                tasks    = @{ max = 9 }
                names    = @('^widget-.*\.md$')
            })
        $config.folder | Should -Be 'widgets/plans'
        $config.statuses | Should -Be @('active')
        $config.tasks_max | Should -Be 9
        $config.Accepts('widget-one.md') | Should -BeTrue
        $config.Accepts('plan-one.md') | Should -BeFalse
    }

    It 'accepts the shipped name forms and refuses a name that carries an order' -Tag 'ADR-REPO-PLANS-MASTERANDTASKS' -ForEach @(
        @{ Name = 'plan-widget-gadget.md'; Accepted = $true }
        @{ Name = 'prompt-widget-continue.md'; Accepted = $true }
        @{ Name = 'prompt-widget-2-implement.md'; Accepted = $true }
        @{ Name = 'task-spin-widget.md'; Accepted = $true }
        @{ Name = 'task007.md'; Accepted = $false }
        @{ Name = 'value-of-plan.md'; Accepted = $true }
        @{ Name = 'decisions-2026-10-16.md'; Accepted = $true }
        @{ Name = 'questionnaire-fundamental-2-2026-10-16.md'; Accepted = $true }
        @{ Name = '01-plan-widget.md'; Accepted = $false }
        @{ Name = 'plan-Widget.md'; Accepted = $false }
        @{ Name = 'notes.md'; Accepted = $false }
    ) {
        [Catzc.Base.QualityGates.PlansConfig]::new(@{}).Accepts($Name) | Should -Be $Accepted
    }

    It 'rejects an unknown key, an empty set, a bad roof and a pattern that is no regular expression' {
        Get-ViolationMessage ([ordered]@{ widgets = 1 }) | Should -BeLike "*unknown top-level key 'widgets'*"
        Get-ViolationMessage ([ordered]@{ statuses = @() }) | Should -BeLike '*statuses must be a non-empty list*'
        Get-ViolationMessage ([ordered]@{ tasks = @{ max = 0 } }) |
            Should -BeLike '*tasks.max must be a positive integer*'
        Get-ViolationMessage ([ordered]@{ head = @{ widgets = @('a') } }) |
            Should -BeLike "*head: unknown key 'widgets'*"
        Get-ViolationMessage ([ordered]@{ names = @('[') }) | Should -BeLike '*is not a regular expression*'
    }

    It 'lists the plan files of a folder in ordinal order, the master and every other name left out, and nothing below it' {
        $folder = Join-Path $TestDrive 'plans'
        $null = New-Item -ItemType Directory -Path (Join-Path $folder 'nested') -Force
        foreach ($name in 'plan-widget.md', 'plan-gadget.md', 'plan-master.md', 'task-widget.md',
            'nested/plan-sprocket.md') {
            Set-Content -LiteralPath (Join-Path $folder $name) -Value 'x'
        }
        $files = [Catzc.Base.QualityGates.PlansConfig]::new(@{}).PlanFiles($folder)
        @($files | ForEach-Object { [System.IO.Path]::GetFileName($_) }) | Should -Be @('plan-gadget.md',
            'plan-widget.md')
        @([Catzc.Base.QualityGates.PlansConfig]::new(@{}).PlanFiles((Join-Path $TestDrive 'missing'))).Count |
            Should -Be 0
    }
}
