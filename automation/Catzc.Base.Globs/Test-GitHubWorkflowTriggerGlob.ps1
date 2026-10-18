<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
    name: test-git-hub-workflow-trigger-glob
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
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
