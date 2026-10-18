function Test-GitHubWorkflowTriggerGlob {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
