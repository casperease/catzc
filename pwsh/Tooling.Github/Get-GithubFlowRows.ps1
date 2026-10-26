function Get-GithubFlowRows {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Point,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The workflow events a flow lane names, each as the trigger chip it draws.
    $events = [ordered]@{ push = 'push'; pull_request = 'pull request'; schedule = 'schedule'; workflow_dispatch = 'manual' }

    $lanes = [System.Collections.Generic.List[object]]::new()
    foreach ($relative in @($Point -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
        $file = Join-Path $RepositoryRoot $relative
        Assert-PathExist $file -PathType Leaf
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $kind = Get-PipelineType $name
        $workflow = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($file)) -Ordered
        # A YAML 1.1 reader may read the `on` key as true, so either spelling names the events.
        $on = if ($workflow.Contains('on')) {
            $workflow['on']
        }
        elseif ($workflow.Contains('True')) {
            $workflow['True']
        }
        $declared = @(if ($on -is [System.Collections.IDictionary]) {
                $on.Keys
            }
            elseif ($on) {
                @($on)
            })
        $triggers = @(foreach ($event in $events.Keys) {
                if ("$event" -in $declared) {
                    $events[$event]
                }
            })
        $contents = [System.Collections.Generic.List[object]]::new()
        $environments = [System.Collections.Generic.List[object]]::new()
        $jobs = if ($workflow.Contains('jobs') -and $workflow['jobs'] -is [System.Collections.IDictionary]) {
            $workflow['jobs']
        }
        else {
            @{}
        }
        foreach ($job in $jobs.Keys) {
            $definition = $jobs[$job]
            $contents.Add([ordered]@{ name = "$job"; kind = 'job' })
            $steps = if ($definition -is [System.Collections.IDictionary] -and $definition.Contains('steps')) {
                @($definition['steps'])
            }
            else {
                @()
            }
            foreach ($step in $steps) {
                $label = if ($step.Contains('name')) {
                    "$($step['name'])"
                }
                elseif ($step.Contains('uses')) {
                    "$($step['uses'])"
                }
                else {
                    'run'
                }
                $contents.Add([ordered]@{ name = $label; kind = 'step' })
            }
            if ($definition -is [System.Collections.IDictionary] -and $definition.Contains('environment')) {
                $environment = $definition['environment']
                $environmentName = if ($environment -is [System.Collections.IDictionary]) {
                    "$($environment['name'])"
                }
                else {
                    "$environment"
                }
                $environments.Add([ordered]@{ id = $environmentName; rung = $environmentName; gate = 'none'; approve = $false })
            }
        }
        $lanes.Add([ordered]@{
                id = $name; type = $kind.Type; unit = $kind.Unit; engine = 'github'; triggers = $triggers
                review = $triggers -contains 'pull request'; templates = @($contents); environments = @($environments)
            })
    }

    [ordered]@{ point = $Point; lens = 'flow'; lanes = @($lanes); edges = @() }
}
