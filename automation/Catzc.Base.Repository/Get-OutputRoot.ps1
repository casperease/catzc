<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-OutputRoot.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Repository
    visibility: public
    relatives:
      test: automation/Catzc.Base.Repository/tests/Get-OutputRoot.Tests.ps1
  config:
    synopsis: Returns the path to the output directory for the current execution context.
    description: |-
      In an Azure DevOps pipeline, returns $env:BUILD_ARTIFACTSTAGINGDIRECTORY.
      Locally on DevBox, returns {RepositoryRoot}/out.

      With -EnsureExists, creates the directory if it does not exist.
    parameters:
      EnsureExists: Create the output directory if it does not exist.
    examples:
      - '$outDir = Get-OutputRoot'
      - '$outDir = Get-OutputRoot -EnsureExists'
---
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
