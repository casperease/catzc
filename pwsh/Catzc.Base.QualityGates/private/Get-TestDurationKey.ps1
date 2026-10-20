<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestDurationKey.ps1
    folder: private
    name: get-test-duration-key
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
