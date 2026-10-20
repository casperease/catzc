function Resolve-ListenSession {
    <#
    .SYNOPSIS
        Resolves a listen session's folder: the one named, or the newest under the output folder.

    .DESCRIPTION
        A session folder is named by its start stamp (yyyyMMdd-HHmmss), so the newest is the last by ordinal name. A session must hold
        its seen.json index; a folder without one is no session.

    .PARAMETER Session
        The session folder. Omitted: the newest session under listen.yml's output folder.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $Session
    )

    if (-not $Session) {
        $output = Join-Path (Get-RepositoryRoot) (Get-Config -Config listen).output
        Assert-PathExist $output -PathType Container -ErrorText "No listen session: '$output' does not exist; start one with Start-DocListener."
        $newest = @([System.IO.Directory]::GetDirectories($output) | Sort-Object { [System.IO.Path]::GetFileName($_) } -Culture ([cultureinfo]::InvariantCulture))
        Assert-True ($newest.Count -gt 0) -ErrorText "No listen session under '$output'; start one with Start-DocListener."
        $Session = $newest[-1]
    }

    $full = [System.IO.Path]::GetFullPath($Session)
    Assert-PathExist (Join-Path $full 'seen.json') -PathType Leaf -ErrorText "'$full' is no listen session: it holds no seen.json."
    $full
}
