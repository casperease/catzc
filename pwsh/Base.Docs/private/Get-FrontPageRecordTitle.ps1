function Get-FrontPageRecordTitle {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RecordPath
    )

    # A record's title is its sentence for a reader; the kind or code before the first ': ' is for the index, so it is dropped.
    $path = Resolve-RepoPath $RecordPath
    Assert-PathExist $path -PathType Leaf
    # The reader is disposed here, since a pipeline cut short by Select-Object -First leaves a ReadLines enumerator holding the file open.
    $heading = $null
    $reader = [System.IO.StreamReader]::new($path)
    try {
        $line = $reader.ReadLine()
        while ($null -ne $line) {
            if ($line -match '^# ') {
                $heading = $line
                break
            }
            $line = $reader.ReadLine()
        }
    }
    finally {
        $reader.Dispose()
    }
    Assert-NotNull $heading -ErrorText "Get-FrontPageRecordTitle: '$RecordPath' has no '# ' title."
    $title = $heading.Substring(2).Trim()
    $colon = $title.IndexOf(': ')
    if ($colon -ge 0) {
        $title = $title.Substring($colon + 2)
    }
    $title.Substring(0, 1).ToUpperInvariant() + $title.Substring(1)
}
