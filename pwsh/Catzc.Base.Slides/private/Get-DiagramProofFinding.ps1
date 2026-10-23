function Get-DiagramProofFinding {
    <#
    .SYNOPSIS
        Checks that an action diagram's about.proves file exists and holds the diagram's action and every effect's proves, verbatim.
    .DESCRIPTION
        An action diagram draws accosted commands, and the accosted file named by about.proves runs them, so the picture never says what the
        proof does not run. The file is read by Get-AccostedFile, the one reader, and each command the diagram draws (the action's call or
        calls, and every effects[].proves) is read by the reader's own command type and must equal a command of the file in name and
        arguments. A diagram without content.style: action is a band diagram, and the check is inert for it.
    .PARAMETER Stem
        The diagram's stem, repository-relative, for the finding text.
    .PARAMETER Text
        The diagram's declaration (the yml text).
    .PARAMETER RepositoryRoot
        The root about.proves resolves against.
    .OUTPUTS
        [string[]] One finding per fault; nothing when the diagram is a band diagram or proven.
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Stem,

        [Parameter(Mandatory)]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $declaration = ConvertFrom-Yaml -Yaml $Text -Ordered
    $content = $declaration['content']
    if ($null -eq $content -or $content['style'] -cne 'action') {
        return
    }

    $about = $declaration['about']
    $proves = if ($about -and $about.Contains('proves')) {
        "$($about['proves'])"
    }
    if ([string]::IsNullOrWhiteSpace($proves)) {
        return "${Stem}: an action diagram names the accosted file that proves it in about.proves"
    }
    if (-not [System.IO.File]::Exists((Join-Path $RepositoryRoot $proves))) {
        return "${Stem}: about.proves names '$proves', which does not exist"
    }

    # The one reader: a file it refuses stops the gate with its own message.
    $file = Get-AccostedFile -Path $proves -RepositoryRoot $RepositoryRoot
    $held = @(foreach ($run in $file.runs) {
            $run.commands
        })

    $drawn = [System.Collections.Generic.List[object]]::new()
    $action = $content['action']
    if ($action -and $action.Contains('call')) {
        $drawn.Add(@{ Where = 'action.call'; Raw = $action['call'] })
    }
    if ($action -and $action.Contains('calls')) {
        $index = 0
        foreach ($call in @($action['calls'])) {
            $index++
            $drawn.Add(@{ Where = "action.calls[$index]"; Raw = $call })
        }
    }
    foreach ($effect in @($content['effects'] | Where-Object { $_ })) {
        if ($effect.Contains('proves')) {
            $drawn.Add(@{ Where = "effects[$($effect['id'])].proves"; Raw = $effect['proves'] })
        }
    }

    foreach ($entry in $drawn) {
        $command = [Catzc.Base.Contracts.AccostedCommand]::new($entry.Raw, "${Stem}: $($entry.Where)")
        $same = @($held | Where-Object {
                $candidate = $_
                $candidate.name -ceq $command.name -and
                $candidate.arguments.Count -eq $command.arguments.Count -and
                @($command.arguments.Keys | Where-Object {
                        $candidate.arguments.ContainsKey($_) -and
                        ($candidate.arguments[$_] | ConvertTo-Json -Compress) -ceq ($command.arguments[$_] | ConvertTo-Json -Compress)
                    }).Count -eq $command.arguments.Count
            })
        if ($same.Count -eq 0) {
            "${Stem}: $($entry.Where) '$($command.name)' with these arguments is not a command of $proves"
        }
    }
}
