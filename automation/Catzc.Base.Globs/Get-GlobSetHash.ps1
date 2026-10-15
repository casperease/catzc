<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
    kind: public-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#5
      - ADR-FLOW-CD-GLOBS#9
---
#>

<#
.SYNOPSIS
    Computes a globset's durable SHA — the deployable unit's identity.
.DESCRIPTION
    CR bytes are stripped and the path is in the fold: CRLF or LF agree, while a rename or deletion re-keys the set.
.PARAMETER Name
    The declared globset (from globs.yml) whose identity to compute.
.PARAMETER GlobSet
    Derived module sets must come through here, since they are not in the declared registry that Name looks up.
.PARAMETER TrackedFile
    Passing it in saves one git index read per set when hashing many; omitted, it is fetched for this call.
.EXAMPLE
    Get-GlobSetHash -Name automation
.EXAMPLE
    Get-GlobSetHash -GlobSet (Get-ModuleGlobSet -Name Catzc.Base.Globs)
#>
function Get-GlobSetHash {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [Catzc.Base.Globs.GlobSet] $GlobSet,

        [AllowEmptyCollection()]
        [string[]] $TrackedFile
    )

    $root = Get-RepositoryRoot
    $set = if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        Get-GlobSet -Name $Name
    }
    else {
        $GlobSet
    }
    $members = if ($PSBoundParameters.ContainsKey('TrackedFile')) {
        Get-GlobSetMember -GlobSet $set -TrackedFile $TrackedFile
    }
    else {
        Get-GlobSetMember -GlobSet $set
    }

    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($path in $members) {
        $digest = [Catzc.Base.Globs.DurableHash]::HashFile([System.IO.Path]::Combine($root, $path))
        if ($null -eq $digest) {
            # a tracked member deleted on disk but not staged: a distinct marker, so the deletion re-keys
            $digest = 'missing'
        }
        [void]$stringBuilder.Append($path).Append('|').Append($digest).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
