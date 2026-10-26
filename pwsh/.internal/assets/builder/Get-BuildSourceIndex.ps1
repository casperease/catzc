function Get-BuildSourceIndex {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, bool]])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $listing = Invoke-Executable 'git -c core.quotepath=off ls-files --eol' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($listing.ExitCode -ne 0) {
        throw "Invoke-ModuleBuild: a bundle is built from the files git tracks, but git cannot list them under '$SourceRoot' ($($listing.Errors))."
    }
    $index = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::Ordinal)
    foreach ($line in ([string] $listing.Output).Split("`n")) {
        $tab = $line.IndexOf("`t")
        if ($tab -lt 0) {
            continue
        }
        $index[$line.Substring($tab + 1).TrimEnd("`r")] = $line.StartsWith('i/lf ', [System.StringComparison]::Ordinal)
    }
    $untracked = Invoke-Executable 'git -c core.quotepath=off ls-files --others --exclude-standard' -WorkingDirectory $SourceRoot -PassThru -Silent
    foreach ($line in ([string] $untracked.Output).Split("`n")) {
        $path = $line.TrimEnd("`r")
        if ($path) {
            $index[$path] = $false   # no stored form to restore: a byte copy
        }
    }
    , $index
}
