<#
.SYNOPSIS
    Quality gate: checks a GitHub workflow's trigger path filters against a globset's projection — the
    trigger-drift quality gate for GitHub Actions
    ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)).
.DESCRIPTION
    The GitHub sibling of Test-AdoPipelineTriggerGlob: recomputes the ordered, '!'-negation `paths` list a globset...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md#comment1)
.PARAMETER Name
    The globset the workflow should trigger on.
.PARAMETER WorkflowPath
    The workflow file, repo-relative (e.g. '.github/workflows/ci-automation.yml') or absolute.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-github-workflow-trigger-glob).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSet; Workflow } instead of throwing.
.OUTPUTS
    [pscustomobject] With -PassThru only.
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
        [string] $WorkflowPath,

        [string] $OutputFolder,

        [switch] $PassThru
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

    $issues = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $issues.Add("$($set.Name): workflow file not found: $WorkflowPath")
    }
    else {
        $actual = Get-PipelineTrigger -Path $path -Vendor GitHub
        $drift = [System.Collections.Generic.List[string]]::new()
        if (-not (Test-GlobListEqual -Reference $expected.GitHub -Difference $actual.PushPaths -Ordered)) {
            $drift.Add('on.push.paths')
        }
        if (-not (Test-GlobListEqual -Reference $expected.GitHub -Difference $actual.PrPaths -Ordered)) {
            $drift.Add('on.pull_request.paths')
        }
        if ($drift.Count -gt 0) {
            $issues.Add("$($set.Name): $WorkflowPath trigger drifted from the globset projection on $($drift -join ', ')")
        }
    }

    Write-QualityGateReport -Subject github-workflow-trigger-glob -Title Test-GitHubWorkflowTriggerGlob `
        -Issues $issues.ToArray() -Facts ([ordered]@{ GlobSet = $set.Name; Workflow = $WorkflowPath }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
