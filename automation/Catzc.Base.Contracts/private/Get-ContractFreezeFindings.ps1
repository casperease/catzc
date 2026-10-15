<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractFreezeFindings.ps1
    kind: private-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#5
  config:
    synopsis: Checks that one released contract version folder still holds exactly what its release froze.
    description: |-
      A released version folder is immutable
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). Publish-ContractRelease
      freezes it with a .frozen record, one line per file, '<sha256>  <path>', after '#' comment lines; this compares the
      record with the folder's files as Get-ContractFileHashes hashes them now, and returns one finding per defect:
      a missing record, a malformed or repeated record line, and every file changed, added or removed since the freeze.
      No finding means the folder is intact. The draft, 0.0.0, is never frozen, so it is never given here.
    parameters:
      Folder: The released version folder's absolute path.
      Name: The folder in communication form, contracts/<unit>/<version>, used in every finding.
    outputs: '[string[]] The findings; none when the folder is intact.'
    examples:
      - Get-ContractFreezeFindings -Folder $versionFolder -Name contracts/widget/1.0.0
---
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
