<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-OutputRoot.ps1
    kind: public-function
    module: Catzc.Base.Repository
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the path to the output directory for the current execution context.
.DESCRIPTION
    The root is context-dependent: the pipeline staging directory outside the repo, or {RepositoryRoot}/out on a devbox.
.PARAMETER EnsureExists
    Create the output directory if it does not exist.
.EXAMPLE
    $outDir = Get-OutputRoot
.EXAMPLE
    $outDir = Get-OutputRoot -EnsureExists
#>
function Get-OutputRoot {
    [OutputType([string])]
    param(
        [switch] $EnsureExists
    )

    $outputPath = if ((Test-IsRunningInPipeline) -and $env:BUILD_ARTIFACTSTAGINGDIRECTORY) {
        Assert-PathExist $env:BUILD_ARTIFACTSTAGINGDIRECTORY -PathType Container
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY
    }
    else {
        Join-Path (Get-RepositoryRoot) 'out'
    }

    if ($EnsureExists -and -not (Test-Path $outputPath -PathType Container)) {
        New-Item -Path $outputPath -ItemType Directory | Out-Null
    }

    $outputPath
}
