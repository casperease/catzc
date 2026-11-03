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
        [string[]] $TrackedFile,

        [hashtable] $Digest
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
    $memberList = @($members)
    $digests = if ($PSBoundParameters.ContainsKey('Digest')) {
        # a given map serves its members; one it lacks is hashed from its bytes
        $given = $Digest
        $served = [object[]]::new($memberList.Count)
        for ($position = 0; $position -lt $memberList.Count; $position++) {
            $served[$position] = if ($given.ContainsKey($memberList[$position])) {
                $given[$memberList[$position]]
            }
            else {
                [Catzc.Base.Globs.DurableHash]::HashFile([System.IO.Path]::Combine($root, $memberList[$position]))
            }
        }
        , $served
    }
    else {
        Get-FileDigest -RepositoryRoot $root -Path $memberList
    }
    for ($position = 0; $position -lt $memberList.Count; $position++) {
        $path = $memberList[$position]
        $fileDigest = $digests[$position]
        if ($null -eq $fileDigest) {
            # a tracked member deleted on disk but not staged: a distinct marker, so the deletion re-keys
            $fileDigest = 'missing'
        }
        [void]$stringBuilder.Append($path).Append('|').Append($fileDigest).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
