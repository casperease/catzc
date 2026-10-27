function Resolve-AdoRunCommit {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RunId,

        [Parameter(Mandatory)]
        [scriptblock] $GetRun
    )

    $run = & $GetRun $RunId
    $parameters = if ($run.PSObject.Properties['templateParameters']) {
        $run.templateParameters
    }
    $source = if ($parameters -and $parameters.PSObject.Properties['CiRunId'] -and "$($parameters.CiRunId)") {
        & $GetRun "$($parameters.CiRunId)"
    }
    else {
        $run
    }
    "$($source.sourceVersion)"
}
