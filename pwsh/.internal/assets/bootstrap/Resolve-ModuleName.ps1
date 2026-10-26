function Resolve-ModuleName {
    # Folder name to full name and back under a track's namespace; pure, twin of VariantTrack.FullNameOf and FolderNameOf.
    [CmdletBinding(DefaultParameterSetName = 'Folder')]
    [OutputType([string])]
    param(
        # The module's folder name, resolved to its full name.
        [Parameter(Mandatory, ParameterSetName = 'Folder')]
        [string] $Folder,

        # The module's full name, resolved to its folder name.
        [Parameter(Mandatory, ParameterSetName = 'FullName')]
        [string] $FullName,

        # The track's namespace; empty when it declares none, so the folder name is the full name.
        [AllowEmptyString()]
        [string] $Namespace = ''
    )

    $prefix = "$Namespace."
    if ($PSCmdlet.ParameterSetName -eq 'Folder') {
        # A folder that already spells its full name is its own full name.
        if (-not $Namespace -or $Folder.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            return $Folder
        }
        return "$prefix$Folder"
    }
    if ($Namespace -and $FullName.StartsWith($prefix, [System.StringComparison]::Ordinal) -and $FullName.Length -gt $prefix.Length) {
        return $FullName.Substring($prefix.Length)
    }
    $FullName
}
