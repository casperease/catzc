<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramProofFinding.ps1.md"
  warning: "Generated Header"
---
#>

function Get-DiagramProofFinding {
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
    $about = $declaration['about']
    # Action is a lens: a diagram selects it with about.lens, and every other diagram is a band diagram.
    if ($null -eq $content -or $null -eq $about -or -not $about.Contains('lens') -or $about['lens'] -cne 'action') {
        return
    }

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

    # The action and an executing effect are any contracted command, mutating included: each fits its contract, not the proof file.
    $action = $content['action']
    $acted = [System.Collections.Generic.List[object]]::new()
    if ($action -and $action.Contains('call')) {
        $acted.Add(@{ Where = 'action.call'; Raw = $action['call'] })
    }
    if ($action -and $action.Contains('calls')) {
        $index = 0
        foreach ($call in @($action['calls'])) {
            $index++
            $acted.Add(@{ Where = "action.calls[$index]"; Raw = $call })
        }
    }

    # An effect is a state change (proves, run by the proof file) or an execution (call, held to its contract), never both.
    $drawn = [System.Collections.Generic.List[object]]::new()
    foreach ($effect in @($content['effects'] | Where-Object { $_ })) {
        $hasProves = $effect.Contains('proves')
        $hasCall = $effect.Contains('call')
        if ($hasProves -eq $hasCall) {
            "${Stem}: effects[$($effect['id'])] carries $($hasProves ? 'both proves and call' : 'neither proves nor call'); a state change proves, an execution calls"
        }
        elseif ($hasCall) {
            $acted.Add(@{ Where = "effects[$($effect['id'])].call"; Raw = $effect['call'] })
        }
        else {
            $drawn.Add(@{ Where = "effects[$($effect['id'])].proves"; Raw = $effect['proves'] })
        }
    }

    foreach ($entry in $acted) {
        Test-AccostedCommand -Call (ConvertTo-Json -InputObject $entry.Raw -Compress -Depth 10) -Where "${Stem}: $($entry.Where)" -RepositoryRoot $RepositoryRoot
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
