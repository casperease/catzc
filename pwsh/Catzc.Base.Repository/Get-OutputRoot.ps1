<#
---
catzc:
  immutable:
    with_body_sha: "03852265f71f"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-OutputRoot.Tests.ps1
    docs: "[Get-OutputRoot.ps1.md](docs/references/pwsh/catzc-base-repository/Get-OutputRoot.ps1.md)"
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
