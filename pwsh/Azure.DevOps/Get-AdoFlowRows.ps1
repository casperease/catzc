function Get-AdoFlowRows {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Point,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # A template's kind is the folder it lives in under the pipelines folder.
    $kinds = @{ extends = 'extends'; stages = 'stage'; jobs = 'job'; steps = 'step'; variables = 'variables' }
    $rungs = @(Get-Rung)

    $lanes = [System.Collections.Generic.List[object]]::new()
    foreach ($relative in @($Point -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
        $file = Join-Path $RepositoryRoot $relative
        Assert-PathExist $file -PathType Leaf
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $kind = Get-PipelineType $name
        $type, $unit = $kind.Type, $kind.Unit
        $text = [System.IO.File]::ReadAllText($file)
        # The triggers a top-level key declares; `none` declares none, and a lane with none at all is run by hand.
        $triggers = [System.Collections.Generic.List[string]]::new()
        if ($text -match '(?m)^trigger:' -and $text -notmatch '(?m)^trigger:\s*none\s*$') {
            $triggers.Add('push')
        }
        if ($text -match '(?m)^pr:' -and $text -notmatch '(?m)^pr:\s*none\s*$') {
            $triggers.Add('pull request')
        }
        if ($text -match '(?m)^schedules:') {
            $triggers.Add('schedule')
        }
        if ($triggers.Count -eq 0) {
            $triggers.Add('manual')
        }
        $templates = @(foreach ($reference in @(Get-PipelineTemplateReference -Path $file)) {
                $folder = (Split-Path (Split-Path $reference -Parent) -Leaf)
                [ordered]@{ name = $reference.TrimStart('/'); kind = $kinds.ContainsKey($folder) ? $kinds[$folder] : 'template' }
            })
        # The rungs come from the rungs registry, never the YAML: a deploy stage names its environment through a template expression.
        $laneRungs = switch ($type) {
            'CD' {
                @($rungs | Where-Object gate -EQ 'none')
            }
            'DEPLOY' {
                @($rungs | Where-Object gate -NE 'none')
            }
            default {
                @()
            }
        }
        $environments = @(foreach ($rung in $laneRungs) {
                [ordered]@{ id = "$unit-$($rung.name)"; rung = $rung.name; gate = $rung.gate; approve = $rung.gate -ne 'none' }
            })
        $lanes.Add([ordered]@{
                id = $name; type = $type; unit = $unit; engine = 'ado'; triggers = @($triggers); review = $triggers.Contains('pull request')
                templates = $templates; environments = $environments
            })
    }

    # A deploy pipeline is pinned to its certifying cd run, joined by the shared unit name: nothing in its trigger points back.
    $edges = @(foreach ($deploy in @($lanes | Where-Object { $_.type -eq 'DEPLOY' })) {
            foreach ($cd in @($lanes | Where-Object { $_.type -eq 'CD' -and $_.unit -eq $deploy.unit })) {
                [ordered]@{ from = $deploy.id; to = $cd.id; label = 'pins' }
            }
        })

    [ordered]@{ point = $Point; lens = 'flow'; lanes = @($lanes); edges = $edges }
}
