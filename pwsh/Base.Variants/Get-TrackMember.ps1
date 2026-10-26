function Get-TrackMember {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.TrackMember])]
    param(
        [ArgumentCompleter({ Get-Track | ForEach-Object name })]
        [string[]] $Name,

        [string] $Path,

        [Nullable[bool]] $Generated,

        [Nullable[bool]] $Committed
    )

    $tracks = @(if ($Name) {
            Get-Track -Name $Name
        }
        else {
            Get-Track
        })

    # A path names the one member that contains it, in the track Get-Track -Path finds, so the two always agree.
    if ($PSBoundParameters.ContainsKey('Path')) {
        $normalized = @($Path.Replace('\', '/').Split('/') | Where-Object { $_ -and $_ -ne '.' }) -join '/'
        $owner = Get-Track -Path $Path
        $tracks = @($tracks | Where-Object { $owner -and $_.name -ceq $owner.name })
    }

    foreach ($track in $tracks) {
        $members = @(if ($PSBoundParameters.ContainsKey('Path')) {
                $track.MemberOf($normalized) | Where-Object { $_ }
            }
            else {
                $track.members
            })
        foreach ($member in $members) {
            if ($null -ne $Generated -and $member.generated -ne $Generated) {
                continue
            }
            if ($null -ne $Committed -and $member.committed -ne $Committed) {
                continue
            }
            [Catzc.Base.Variants.TrackMember]::new($track.name, $member)
        }
    }
}
