function Remove-OrphanTestResult {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputRoot = (Get-OutputRoot)
    )

    # A result stands for a test file; once the file is gone, or was never a Pester test file, nothing can clear the result.
    $resultRoot = Join-Path $OutputRoot 'test-results'
    if (-not [System.IO.Directory]::Exists($resultRoot)) {
        return
    }
    $staleTemporary = [DateTime]::UtcNow.AddHours(-1)
    foreach ($path in [System.IO.Directory]::EnumerateFiles($resultRoot, '*', [System.IO.SearchOption]::AllDirectories)) {
        $relative = [System.IO.Path]::GetRelativePath($resultRoot, $path).Replace('\', '/')
        $orphan = if ($relative.EndsWith('.result.json')) {
            $test = $relative.Substring(0, $relative.Length - '.result.json'.Length)
            -not ($test.EndsWith('.Tests.ps1') -and [System.IO.File]::Exists((Join-Path $RepositoryRoot $test)))
        }
        elseif ($relative.EndsWith('.tmp')) {
            # A writer in flight owns its temporary file; only one a crash left behind is removed.
            [System.IO.File]::GetLastWriteTimeUtc($path) -lt $staleTemporary
        }
        else {
            $true
        }
        if ($orphan) {
            [System.IO.File]::Delete($path)
            $path
        }
    }
}
