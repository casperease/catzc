<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md"
  header: "generated"
---
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
