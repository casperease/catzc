<#
.SYNOPSIS
    Checks each ADO pipeline's trigger path filters against its globset's projection — the trigger-drift gate
    (ADR-FLOW-CD-GLOBS:1).
.DESCRIPTION
    The integrity query behind "do the ADO pipelines have the proper glob trigger setup?": for every
    pipeline-bound globset, it recomputes the vendor-native trigger the set projects to (Get-GlobSetTrigger)
    and compares it against what the bound pipeline file actually declares (Get-PipelineTrigger). Both the
    `trigger:` and the `pr:` path filters must match, on include AND exclude, compared as sets (ADO path
    filters are order-independent). One status object per pipeline — Match (both agree), Drift (a filter
    differs — Detail names which), or Missing (no pipeline file). A repo is clean exactly when every status
    is Match; anything else means "regenerate the pipeline trigger from globs.yml". The pipeline is resolved
    from the globset's `pipeline:` binding: pipelines/<pipeline>.yaml.
.PARAMETER Name
    The globset(s) to check — a declared, pipeline-bound name. Omit for every pipeline-bound globset.
.EXAMPLE
    Test-AdoPipelineTriggerGlob
.EXAMPLE
    (Test-AdoPipelineTriggerGlob | Where-Object Status -NE 'Match').Count -eq 0
#>
function Test-AdoPipelineTriggerGlob {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name
    )

    $root = Get-RepositoryRoot
    $sets = if ($PSBoundParameters.ContainsKey('Name')) {
        Get-GlobSet -Name $Name
    }
    else {
        @(Get-GlobSet) | Where-Object { $_.Pipeline }
    }

    foreach ($set in $sets) {
        if (-not $set.Pipeline) {
            continue
        }

        $expected = Get-GlobSetTrigger -GlobSet $set
        $relative = "pipelines/$($set.Pipeline).yaml"
        $path = [System.IO.Path]::Combine($root, 'pipelines', "$($set.Pipeline).yaml")

        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            [pscustomobject]@{
                GlobSet  = $set.Name
                Pipeline = $set.Pipeline
                Vendor   = 'Ado'
                Status   = 'Missing'
                Detail   = "pipeline file not found: $relative"
                Expected = $expected
                Actual   = $null
            }
            continue
        }

        $actual = Get-PipelineTrigger -Path $path -Vendor Ado
        $issues = [System.Collections.Generic.List[string]]::new()
        if (-not (Test-GlobListEqual -Reference $expected.AdoInclude -Difference $actual.TriggerInclude)) {
            $issues.Add('trigger.paths.include')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoExclude -Difference $actual.TriggerExclude)) {
            $issues.Add('trigger.paths.exclude')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoInclude -Difference $actual.PrInclude)) {
            $issues.Add('pr.paths.include')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoExclude -Difference $actual.PrExclude)) {
            $issues.Add('pr.paths.exclude')
        }

        [pscustomobject]@{
            GlobSet  = $set.Name
            Pipeline = $set.Pipeline
            Vendor   = 'Ado'
            Status   = if ($issues.Count -eq 0) {
                'Match'
            }
            else {
                'Drift'
            }
            Detail   = $issues -join ', '
            Expected = $expected
            Actual   = $actual
        }
    }
}
