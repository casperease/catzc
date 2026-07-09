<#
.SYNOPSIS
    Checks a GitHub workflow's trigger path filters against a globset's projection — the trigger-drift gate
    for GitHub Actions (ADR-FLOW-CD-GLOBS:1).
.DESCRIPTION
    The GitHub sibling of Test-AdoPipelineTriggerGlob: recomputes the ordered, '!'-negation `paths` list a
    globset projects to (Get-GlobSetTrigger) and compares it against what a workflow actually declares
    (Get-PipelineTrigger) — both on.push.paths and on.pull_request.paths. GitHub paths are ordered
    (last-match-wins), so the comparison is element-by-element, not a set. Unlike ADO, a GitHub workflow is
    not named in globs.yml, so the globset-to-workflow pairing is passed explicitly. Returns one status
    object — Match, Drift (Detail names the filter), or Missing (no workflow file).
.PARAMETER Name
    The globset the workflow should trigger on.
.PARAMETER WorkflowPath
    The workflow file, repo-relative (e.g. '.github/workflows/ci-automation.yml') or absolute.
.EXAMPLE
    Test-GitHubWorkflowTriggerGlob -Name automation -WorkflowPath .github/workflows/ci-automation.yml
#>
function Test-GitHubWorkflowTriggerGlob {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $WorkflowPath
    )

    $root = Get-RepositoryRoot
    $set = Get-GlobSet -Name $Name
    $expected = Get-GlobSetTrigger -GlobSet $set
    $path = if ([System.IO.Path]::IsPathRooted($WorkflowPath)) {
        $WorkflowPath
    }
    else {
        [System.IO.Path]::Combine($root, $WorkflowPath)
    }

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return [pscustomobject]@{
            GlobSet  = $set.Name
            Workflow = $WorkflowPath
            Vendor   = 'GitHub'
            Status   = 'Missing'
            Detail   = "workflow file not found: $WorkflowPath"
            Expected = $expected
            Actual   = $null
        }
    }

    $actual = Get-PipelineTrigger -Path $path -Vendor GitHub
    $issues = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-GlobListEqual -Reference $expected.GitHub -Difference $actual.PushPaths -Ordered)) {
        $issues.Add('on.push.paths')
    }
    if (-not (Test-GlobListEqual -Reference $expected.GitHub -Difference $actual.PrPaths -Ordered)) {
        $issues.Add('on.pull_request.paths')
    }

    [pscustomobject]@{
        GlobSet  = $set.Name
        Workflow = $WorkflowPath
        Vendor   = 'GitHub'
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
