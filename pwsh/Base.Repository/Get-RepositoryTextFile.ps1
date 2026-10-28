function Get-RepositoryTextFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Folder,

        [ValidateNotNullOrEmpty()]
        [string] $Filter = '*'
    )

    $root = Get-RepositoryRoot
    $full = [System.IO.Path]::GetFullPath($Folder, $root)
    $relative = [System.IO.Path]::GetRelativePath($root, $full).Replace('\', '/')
    $source = Get-RepositoryTextSource
    # Outside the repository no commit holds the folder, so the disk answers in either mode.
    $files = [string[]] @(if ($null -eq $source -or $relative -eq $full.Replace('\', '/') -or $relative.StartsWith('../') -or
            $relative -eq '..') {
            if ([System.IO.Directory]::Exists($full)) {
                [System.IO.Directory]::GetFiles($full, $Filter)
            }
        }
        else {
            # The folder's own files only, as Directory.GetFiles lists them: a path one segment below the folder.
            $prefix = if ($relative -eq '.') {
                ''
            }
            else {
                "$relative/"
            }
            $pattern = [WildcardPattern]::new($Filter, [System.Management.Automation.WildcardOptions]::IgnoreCase)
            foreach ($candidate in $source.Path) {
                if ($candidate.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
                    $name = $candidate.Substring($prefix.Length)
                    if (-not $name.Contains('/') -and $pattern.IsMatch($name)) {
                        [System.IO.Path]::GetFullPath($candidate, $root)
                    }
                }
            }
        })
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    $files
}
