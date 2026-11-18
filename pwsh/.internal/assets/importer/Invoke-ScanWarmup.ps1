function Invoke-ScanWarmup {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $MarkerPath,

        [Parameter(Mandatory)]
        [string] $Signature
    )

    # The folders never read: git objects, the output folder, environments and build products, which a test run does not read either.
    $excludedFolders = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] @('.git', 'out', '.venv', 'node_modules', '__pycache__', '.pytest_cache', 'bin', 'obj'), [System.StringComparer]::OrdinalIgnoreCase)
    # The whole tree on purpose, so the walk is bounded by a time roof and a depth no repository folder reaches, and enters no link.
    $roofSeconds = 300
    $depthRoof = 32

    $clock = [System.Diagnostics.Stopwatch]::StartNew()
    $started = [datetime]::UtcNow
    $buffer = [byte[]]::new(1MB)
    $files = 0
    $stoppedAtRoof = $false
    $pending = [System.Collections.Generic.Stack[System.Tuple[string, int]]]::new()
    $pending.Push([System.Tuple]::Create($RepositoryRoot, 0))
    while ($pending.Count -gt 0 -and -not $stoppedAtRoof) {
        $entry = $pending.Pop()
        try {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($entry.Item1)) {
                if ($clock.Elapsed.TotalSeconds -ge $roofSeconds) {
                    $stoppedAtRoof = $true
                    break
                }
                try {
                    $stream = [System.IO.File]::OpenRead($file)
                    try {
                        do {
                            $read = $stream.Read($buffer, 0, $buffer.Length)
                        } while ($read -gt 0)
                    }
                    finally {
                        $stream.Dispose()
                    }
                    $files++
                }
                catch {
                    # A file gone or locked since the listing is skipped.
                    $null = $_
                }
            }
            if ($entry.Item2 -lt $depthRoof) {
                foreach ($child in [System.IO.Directory]::EnumerateDirectories($entry.Item1)) {
                    $info = [System.IO.DirectoryInfo]::new($child)
                    if ($excludedFolders.Contains($info.Name) -or $info.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                        continue
                    }
                    $pending.Push([System.Tuple]::Create($child, $entry.Item2 + 1))
                }
            }
        }
        catch {
            # A folder gone or denied since the listing is skipped.
            $null = $_
        }
    }

    $record = [ordered]@{
        signature = $Signature; started = $started.ToString('o'); finished = [datetime]::UtcNow.ToString('o')
        seconds = [math]::Round($clock.Elapsed.TotalSeconds, 1); files = $files; stoppedAtRoof = $stoppedAtRoof
    } | ConvertTo-Json -Compress
    [System.IO.File]::WriteAllText($MarkerPath, $record, [System.Text.UTF8Encoding]::new($false))
}
