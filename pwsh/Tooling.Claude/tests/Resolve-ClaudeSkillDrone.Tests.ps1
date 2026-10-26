Describe 'Resolve-ClaudeSkillDrone' -Tag 'L0', 'logic' {
    BeforeAll {
        function Write-SkillFixture {
            param([string] $Name, [string] $Floor)
            $folder = Join-Path $TestDrive ".claude/skills/$Name"
            [void] [System.IO.Directory]::CreateDirectory($folder)
            $config = $Floor ? "    config:`n      model_floor: $Floor`n" : "    config: {}`n"
            [System.IO.File]::WriteAllText((Join-Path $folder 'SKILL.md'),
                "---`nname: $Name`nmetadata:`n  catzc:`n$config---`n`n# $Name`n`n1. Spin the widget.`n")
        }
        function Resolve-Drone {
            param([string] $Skill)
            & (Get-Module Catzc.Tooling.Claude) { param($s, $r) Resolve-ClaudeSkillDrone -Skill $s -RepositoryRoot $r } $Skill $TestDrive
        }
    }

    It 'names the drone of the skill''s <Floor> floor' -ForEach @(
        @{ Floor = 'haiku' }, @{ Floor = 'sonnet' }, @{ Floor = 'opus' }, @{ Floor = 'fable' }
    ) {
        Write-SkillFixture "widget-$Floor" $Floor
        Resolve-Drone "widget-$Floor" | Should -BeExactly "drone-$Floor"
    }

    It 'throws for a skill that does not exist' {
        { Resolve-Drone 'gadget-missing' } | Should -Throw "*no skill 'gadget-missing'*"
    }

    It 'throws for a skill without a known model_floor' {
        Write-SkillFixture 'widget-bare' ''
        { Resolve-Drone 'widget-bare' } | Should -Throw '*no model_floor*'
        Write-SkillFixture 'widget-odd' 'gadget'
        { Resolve-Drone 'widget-odd' } | Should -Throw '*no model_floor*'
    }
}
