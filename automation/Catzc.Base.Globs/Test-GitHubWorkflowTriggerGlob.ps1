<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
  config:
    synopsis: |-
      Quality gate: checks a GitHub workflow's trigger path filters against a globset's projection — the
      trigger-drift quality gate for GitHub Actions.
    description: |-
      The GitHub sibling of Test-AdoPipelineTriggerGlob: recomputes the ordered, '!'-negation `paths` list a
      globset projects to (Get-GlobSetTrigger) and compares it against what a workflow actually declares
      (Get-PipelineTrigger) — both on.push.paths and on.pull_request.paths. GitHub paths are ordered
      (last-match-wins), so the comparison is element-by-element, not a set. Unlike ADO, a GitHub workflow is
      not named in globs.yml, so the globset-to-workflow pairing is passed explicitly.

      A drifted workflow is one issue naming the filters that differ, and a missing workflow file is one issue.
      The gate ends with Write-QualityGateReport
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
      out/test-github-workflow-trigger-glob/, and the gate throws once listing every issue (or returns the result
      with -PassThru).
    parameters:
      Name: The globset the workflow should trigger on.
      WorkflowPath: The workflow file, repo-relative (e.g. '.github/workflows/ci-automation.yml') or absolute.
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-github-workflow-trigger-glob).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSet; Workflow } instead of throwing.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-GitHubWorkflowTriggerGlob -Name automation -WorkflowPath .github/workflows/ci-automation.yml
---
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
