function Wait-PesterRunner {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.PesterRunner])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PesterRunner] $Runner,

        [ValidateRange(10, 5000)]
        [int] $PollMilliseconds = 200
    )

    try {
        while (-not $Runner.Wait($PollMilliseconds)) {
        }
    }
    finally {
        # A finished pool stops nothing; a stopped call kills every worker tree here, before the caller's own finally frees the location.
        $null = $Runner.Stop()
    }
    $Runner
}
