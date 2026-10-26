function Resolve-ClaudeSkillDrone {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Skill,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $path = Join-Path $RepositoryRoot ".claude/skills/$Skill/SKILL.md"
    Assert-PathExist $path -PathType Leaf -ErrorText "Resolve-ClaudeSkillDrone: no skill '$Skill' at .claude/skills/$Skill/SKILL.md."
    $text = [System.IO.File]::ReadAllText($path)
    $match = [regex]::Match($text, '\A---\r?\n(?<head>.*?)\r?\n---', 'Singleline')
    Assert-True $match.Success -ErrorText "Resolve-ClaudeSkillDrone: '$Skill' has no front matter."
    $config = ConvertFrom-Yaml $match.Groups['head'].Value
    foreach ($segment in 'metadata', 'catzc', 'config') {
        $config = ($config -is [System.Collections.IDictionary] -and $config.Contains($segment)) ? $config[$segment] : $null
    }
    $floor = ($config -is [System.Collections.IDictionary] -and $config.Contains('model_floor')) ? [string] $config['model_floor'] : ''
    # The skill's floor names its drone: each model has one drone, so the minimal model is the one the floor says.
    Assert-True ($floor -cin 'haiku', 'sonnet', 'opus', 'fable') -ErrorText "Resolve-ClaudeSkillDrone: '$Skill' has no model_floor of haiku, sonnet, opus or fable."
    "drone-$floor"
}
