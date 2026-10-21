Describe 'New-Plan' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:config = [Catzc.Base.QualityGates.PlansConfig]::new(@{})
        function Invoke-NewPlan {
            param([string] $Topic = 'spin-widget', [string] $Value = 'medium', [string[]] $Target = @('widgets'))
            New-Plan -Topic $Topic -Value $Value -Class feature -Target $Target -Config $script:config -RepositoryRoot $script:root
        }
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        if (Test-Path -LiteralPath $script:root) {
            Remove-Item -LiteralPath $script:root -Recurse -Force
        }
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widgets'))
    }

    It 'writes the head and the open steps section, and returns the file' {
        $file = Invoke-NewPlan
        $file | Should -BeExactly (Join-Path (Join-Path $script:root '.claude/plans') 'plan-spin-widget.md')
        $text = [System.IO.File]::ReadAllText($file)
        $head = "---`nplan:`n  status: active`n  value: medium`n  reviewed: $([DateTime]::Today.ToString('yyyy-MM-dd'))`n  class: feature`n  targets: [widgets]`n---`n"
        $text.StartsWith($head, [System.StringComparison]::Ordinal) | Should -BeTrue -Because $text
        $text | Should -BeLike "*`n# Spin widget`n`n## Open steps`n"
    }

    It 'writes a plan Test-Plans passes' {
        $file = Invoke-NewPlan
        $result = Test-Plans -Path ([System.IO.Path]::GetDirectoryName($file)) -Config $script:config -RepositoryRoot $script:root -OutputFolder (Join-Path $TestDrive 'out') -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'refuses a topic whose plan exists, and leaves it as it was' {
        $file = Invoke-NewPlan
        [System.IO.File]::WriteAllText($file, "kept`n")
        { Invoke-NewPlan } | Should -Throw '*exists; a topic has one plan*'
        [System.IO.File]::ReadAllText($file) | Should -BeExactly "kept`n"
    }

    It 'refuses <case>' -ForEach @(
        @{ case = 'a name the folder does not accept'; Topic = 'Spin_Widget'; Value = 'medium'; Target = @('widgets'); expect = '*not a plan name*' }
        @{ case = 'the master plan''s name'; Topic = 'master'; Value = 'medium'; Target = @('widgets'); expect = '*not a plan name*' }
        @{ case = 'a value outside the ranks'; Topic = 'spin-widget'; Value = 'urgent'; Target = @('widgets'); expect = '*not one of the ranks*' }
        @{ case = 'a target that does not exist'; Topic = 'spin-widget'; Value = 'medium'; Target = @('gadgets'); expect = '*target ''gadgets'' does not exist*' }
    ) {
        { Invoke-NewPlan -Topic $Topic -Value $Value -Target $Target } | Should -Throw $expect
    }
}
