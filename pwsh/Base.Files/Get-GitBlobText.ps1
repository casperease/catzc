function Get-GitBlobText {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Blob
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitBlobTextCache')) {
        # Probed through GetValue, since reading an unset script variable throws under strict mode.
        $script:gitBlobTextCache = @{}
    }
    # A blob id names its content, so a cached text is never stale.
    $missing = [string[]] @($Blob | Where-Object { -not $script:gitBlobTextCache.ContainsKey($_) } | Sort-Object -Unique)
    if ($missing.Count -gt 0) {
        $marker = "catzc-blob-$([guid]::NewGuid().ToString('N'))"
        $read = Invoke-Executable "git cat-file `"--batch=$marker %(objectname)`"" -InputText ((@($missing) + $marker | ForEach-Object { "$_`n" }) -join '') -PassThru -Silent
        $records = ("`n" + $read.Output) -split [regex]::Escape("`n$marker ")
        $last = $records.Count - 1
        if ($records[$last] -ne 'missing') {
            throw 'Get-GitBlobText: the git object stream ends without its closing marker; it is truncated.'
        }
        # Read into a local first: a missing id's line joins the text before it, so nothing is cached until every id is found.
        $found = @{}
        for ($i = 1; $i -lt $last; $i++) {
            $newline = $records[$i].IndexOf("`n")
            $text = $records[$i].Substring($newline + 1)
            # The text reads as [System.IO.File]::ReadAllText would read the file: a byte-order mark is not part of it.
            if ($text.StartsWith([char] 0xFEFF)) {
                $text = $text.Substring(1)
            }
            $found[$records[$i].Substring(0, $newline)] = $text
        }
        foreach ($id in $missing) {
            if (-not $found.ContainsKey($id)) {
                throw "Get-GitBlobText: '$id' is not a blob of this repository."
            }
        }
        foreach ($id in $missing) {
            $script:gitBlobTextCache[$id] = $found[$id]
        }
    }
    $texts = @{}
    foreach ($id in $Blob) {
        $texts[$id] = $script:gitBlobTextCache[$id]
    }
    $texts
}
