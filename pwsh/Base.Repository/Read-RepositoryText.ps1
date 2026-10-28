function Read-RepositoryText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $root = Get-RepositoryRoot
    $full = [System.IO.Path]::GetFullPath($Path, $root)
    $relative = [System.IO.Path]::GetRelativePath($root, $full).Replace('\', '/')
    $source = Get-RepositoryTextSource
    # Outside the repository no commit holds the file, so the disk answers in either mode.
    if ($null -eq $source -or $relative -eq $full.Replace('\', '/') -or $relative.StartsWith('../') -or $relative -eq '..') {
        if ([System.IO.File]::Exists($full)) {
            return [System.IO.File]::ReadAllText($full)
        }
        return
    }
    if (-not $source.Listed.Contains($relative)) {
        return
    }
    Assert-True ($source.Text.Contains($relative)) -ErrorText "Read-RepositoryText: '$relative' is in source '$($source.Name)', but its text was not loaded into it."
    [string] $source.Text[$relative]
}
