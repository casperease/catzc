<#
.SYNOPSIS
    Computes a globset's durable SHA — the deployable unit's identity
    ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)).
.DESCRIPTION
    The recipe: per member file, SHA-256 over the on-disk bytes with every CR (0x0D) stripped (a CRLF vs LF working...
    [ADR-FLOW-CD-GLOBS#9](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)
    [comment:1](/docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md#comment1)
.PARAMETER Name
    The declared globset (from globs.yml) whose identity to compute.
.PARAMETER GlobSet
    A [Catzc.Base.Globs.GlobSet] instance to compute the identity for instead — the path a DERIVED set...
    [comment:2](/docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md#comment2)
.PARAMETER TrackedFile
    The tracked-file universe (Get-TrackedFile), fetched once by a caller hashing many sets and passed in.
    [comment:3](/docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md#comment3)
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
