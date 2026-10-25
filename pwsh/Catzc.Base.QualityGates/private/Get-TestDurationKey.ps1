<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestDurationKey.ps1.md"
  header: "generated"
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
