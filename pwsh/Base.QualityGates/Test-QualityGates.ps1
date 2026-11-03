function Test-QualityGates {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $gates = @(Get-QualityGateCheckSet)
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($gate in $gates) {
        $command = Get-Command $gate -CommandType Function -ErrorAction Ignore
        if (-not $command) {
            $issues.Add("${gate}: no such command — languages.yml names it as a check")
            continue
        }
        Write-Message "Running $gate..."
        try {
            $result = & $command -PassThru 6> $null
        }
        catch {
            $issues.Add("${gate}: $($_.Exception.Message)")
            continue
        }
        foreach ($issue in @($result.Issues)) {
            $issues.Add("${gate}: $issue")
        }
    }

    Write-QualityGateReport -Subject quality-gates -Title Test-QualityGates -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Gates = $gates.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
