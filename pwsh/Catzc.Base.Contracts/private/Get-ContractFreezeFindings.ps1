<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractFreezeFindings.ps1.md"
  warning: "Generated Header"
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

    $fix = "a released version folder is immutable, so a change lands in the draft, $([System.IO.Path]::GetDirectoryName($Name) -replace '\\', '/')/0.0.0/ (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE)"
    $record = Join-Path $Folder '.frozen'
    if (-not [System.IO.File]::Exists($record)) {
        return "${Name}: holds no .frozen record, so nothing proves it unchanged; a release freezes the draft with Publish-ContractRelease, which writes it (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE)."
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
