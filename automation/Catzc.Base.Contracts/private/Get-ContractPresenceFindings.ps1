<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractPresenceFindings.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
---
#>

<#
.SYNOPSIS
    Checks that a contract asset's target file exists with the exact case of its path, and returns the findings.
.DESCRIPTION
    The path is walked one segment at a time, because a case-insensitive file system finds a wrong-case file.
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractPresenceFindings.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the path is relative to.
.PARAMETER Path
    The target, repository-relative and '/'-separated.
.OUTPUTS
    [string[]] The findings; none when the file is present.
.EXAMPLE
    Get-ContractPresenceFindings -RepositoryRoot $root -Path '.widget/flows/build.yml'
#>
function Get-ContractPresenceFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $segments = $Path.Split('/')
    $folder = $RepositoryRoot
    for ($i = 0; $i -lt $segments.Count; $i++) {
        $segment = $segments[$i]
        $parent = if ($i -eq 0) {
            'the repository root'
        }
        else {
            "'$($segments[0..($i - 1)] -join '/')'"
        }
        $names = @([System.IO.Directory]::GetFileSystemEntries($folder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
        if (@($names | Where-Object { $_ -ceq $segment }).Count -eq 0) {
            $cased = @($names | Where-Object { $_ -ieq $segment })
            if ($cased.Count -gt 0) {
                return "the target '$Path' is missing in that case: $parent holds '$($cased[0])', not '$segment'; a contract names its target with the exact case of its path."
            }
            return "the target '$Path' does not exist: $parent holds no '$segment'."
        }

        $entry = Join-Path $folder $segment
        $isFolder = [System.IO.Directory]::Exists($entry)
        if ($i -eq $segments.Count - 1 -and $isFolder) {
            return "the target '$Path' is a folder, not a file."
        }
        if ($i -lt $segments.Count - 1 -and -not $isFolder) {
            return "the target '$Path' does not exist: '$(($segments[0..$i]) -join '/')' is a file, not a folder."
        }
        $folder = $entry
    }
}
