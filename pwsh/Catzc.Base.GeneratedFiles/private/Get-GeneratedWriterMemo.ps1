<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/private/Get-GeneratedWriterMemo.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GeneratedWriterMemo {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $MemoPath
    )

    # The stamps stored after each writer's last run; a missing or unreadable memo reads as empty, so every writer is due.
    if (-not [System.IO.File]::Exists($MemoPath)) {
        return @{}
    }
    try {
        $memo = [System.IO.File]::ReadAllText($MemoPath) | ConvertFrom-Json -AsHashtable
    }
    catch {
        Write-Verbose "Ignoring the unreadable generated-writer memo '$MemoPath': $($_.Exception.Message)"
        return @{}
    }
    if ($memo -isnot [hashtable]) {
        return @{}
    }
    $memo
}
