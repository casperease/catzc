<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Get-ContractPresenceFindings.ps1
    folder: private
    name: get-contract-presence-findings
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
---
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
