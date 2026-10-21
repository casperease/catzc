<#
---
catzc:
  immutable:
    with_body_sha: "8ad081989f31"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestDurationKey.Tests.ps1
    docs: "[Get-TestDurationKey.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestDurationKey.ps1.md)"
---
#>

function Get-TestDurationKey {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $File,

        [string] $ShardFile,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # A one-file shard is keyed by the file it was given: a bridged test reports the shared bridge script as its file.
    $keyed = if ($ShardFile) {
        $ShardFile
    }
    else {
        $File
    }
    [System.IO.Path]::GetRelativePath($RepositoryRoot, $keyed) -replace '\\', '/'
}
