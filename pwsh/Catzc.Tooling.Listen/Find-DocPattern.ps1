function Find-DocPattern {
    <#
    .SYNOPSIS
        Searches the session's committed reference for a pattern, tier by tier: the one search the processor and its scouts use.

    .DESCRIPTION
        Reads only reference/, the repository at the pinned commit with committed files only (New-DocSnapshot), never the live tree, so
        every scout sees the same truth and every match is stated at one commit. A binary file (a NUL in its first 8000 bytes, git's test)
        is skipped. Each match carries its file's tier, so a caller searches the rules first and the rest after.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER Pattern
        The regular expression to find, case-sensitive.

    .PARAMETER Tier
        Only files in these tiers (listen.yml's tier names, or its rest tier).

    .PARAMETER Path
        Only under this repository-relative folder: a scout's slice.

    .OUTPUTS
        [pscustomobject] per matching line: Path (repository-relative), Line, Text, Kind, Tier.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Pattern,

        [string[]] $Tier,

        [string] $Path = ''
    )

    $Session = Resolve-ListenSession $Session
    $reference = Join-Path $Session 'reference'
    Assert-PathExist $reference -PathType Container -ErrorText "Find-DocPattern: the session '$Session' holds no reference."
    $slice = $Path.Replace('\', '/').Trim('/')
    $start = if ($slice) {
        Join-Path $reference $slice
    }
    else {
        $reference
    }
    if (-not [System.IO.Directory]::Exists($start)) {
        return
    }
    $regex = [regex]::new($Pattern, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)

    $files = [string[]] @(Get-ChildPath $start -File -Depth 64 -Exclude @('.git') -PruneVendor $false)
    [Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($reference, $file).Replace('\', '/')
        $place = Get-ListenTier $relative
        if ($Tier -and $place.Tier -cnotin $Tier) {
            continue
        }

        $bytes = [System.IO.File]::ReadAllBytes($file)
        if ([Array]::IndexOf($bytes, [byte] 0, 0, [Math]::Min($bytes.Length, 8000)) -ge 0) {
            continue
        }
        $lines = [System.Text.Encoding]::UTF8.GetString($bytes) -split '\r?\n'
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($regex.IsMatch($lines[$i])) {
                [pscustomobject]@{
                    Path = $relative
                    Line = $i + 1
                    Text = $lines[$i].Trim()
                    Kind = $place.Kind
                    Tier = $place.Tier
                }
            }
        }
    }
}
