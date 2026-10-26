function Start-ClaudeDrone {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Skill,

        [string] $Model,

        [Parameter(Position = 0)]
        [string] $Prompt,

        [ValidateRange(1, 20)]
        [int] $Count = 1,

        [ValidateSet('windows-terminal', 'pwsh')]
        [string] $Launcher = (Get-Config -Config claude-drone).launcher,

        [switch] $PassThru,

        [switch] $DryRun
    )

    $root = Get-RepositoryRoot
    $agent = Resolve-ClaudeSkillDrone -Skill $Skill -RepositoryRoot $root
    # The brief names its skill first, as every drone's first step reads it; one line, since the launcher quotes it into a command line.
    $brief = "skill: $Skill"
    if ($Prompt) {
        $brief = "$brief. $Prompt"
    }
    for ($index = 1; $index -le $Count; $index++) {
        $launch = Get-ClaudeDroneLaunch -Agent $agent -Model $Model -Prompt $brief -Launcher $Launcher -WorkingDirectory $root -Index $index
        if ($DryRun) {
            $launch.CommandLine
            continue
        }
        Start-Process -FilePath $launch.FilePath -ArgumentList $launch.ArgumentList -WorkingDirectory $root
        if ($PassThru) {
            $launch.CommandLine
        }
    }
}
