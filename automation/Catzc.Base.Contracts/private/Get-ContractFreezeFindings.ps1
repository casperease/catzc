<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractFreezeFindings.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
---
#>

<#
.SYNOPSIS
    Checks that one released contract version folder still holds exactly what its release froze.
.DESCRIPTION
    The draft 0.0.0 is never frozen, so it is never given here; no finding means the folder is intact.
    [ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractFreezeFindings.ps1.md#comment1)
.PARAMETER Folder
    The released version folder's absolute path.
.PARAMETER Name
    The folder in communication form, contracts/<unit>/<version>, used in every finding.
.OUTPUTS
    [string[]] The findings; none when the folder is intact.
.EXAMPLE
    Get-ContractFreezeFindings -Folder $versionFolder -Name contracts/widget/1.0.0
#>
function Get-ContractFreezeFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $fix = "a released version folder is immutable, so a change lands in the draft, $([System.IO.Path]::GetDirectoryName($Name) -replace '\\', '/')/0.0.0/ (ADR-REPO-CONTRACT#5)"
    $record = Join-Path $Folder '.frozen'
    if (-not [System.IO.File]::Exists($record)) {
        return "${Name}: holds no .frozen record, so nothing proves it unchanged; a release freezes the draft with Publish-ContractRelease, which writes it (ADR-REPO-CONTRACT#5)."
    }

    $frozen = [System.Collections.Specialized.OrderedDictionary]::new([System.StringComparer]::Ordinal)
    $lineNumber = 0
    foreach ($line in [System.IO.File]::ReadAllLines($record)) {
        $lineNumber++
        if ($line.Trim().Length -eq 0 -or $line.StartsWith('#')) {
            continue
        }
        if ($line -cmatch '^([0-9a-f]{64})  (.+)$') {
            if ($frozen.Contains($Matches[2])) {
                "${Name}/.frozen: line $lineNumber records '$($Matches[2])' a second time."
                continue
            }
            $frozen[$Matches[2]] = $Matches[1]
        }
        else {
            "${Name}/.frozen: line $lineNumber is not '<sha256>  <path>'."
        }
    }

    $current = Get-ContractFileHashes -Folder $Folder
    foreach ($path in $frozen.Keys) {
        if (-not $current.Contains($path)) {
            "$Name/${path}: removed since the release froze it; $fix."
        }
        elseif ($current[$path] -cne $frozen[$path]) {
            "$Name/${path}: changed since the release froze it; $fix."
        }
    }
    foreach ($path in $current.Keys) {
        if (-not $frozen.Contains($path)) {
            "$Name/${path}: added since the release froze it; $fix."
        }
    }
}
