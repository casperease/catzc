function Invoke-RuffFormat {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    $pythonRoot = Join-Path (Get-RepositoryRoot) (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))

    $changed = [System.Collections.Generic.List[string]]::new()
    $add = {
        param([string] $Path)
        $full = [System.IO.Path]::GetFullPath($Path.Trim(), $pythonRoot)
        if (-not $changed.Contains($full)) {
            $changed.Add($full)
        }
    }
    foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
        # --check exits 1 when a file would change and names each on a 'Would reformat: <path>' line.
        $check = Invoke-PythonWorkspaceTool -Tool 'ruff format --check' -File $batch
        if ($check.ExitCode -notin 0, 1) {
            throw "ruff could not format the Python files (exit $($check.ExitCode)):`n$($check.Full)"
        }
        foreach ($line in ($check.Full -split '\r?\n')) {
            if ($line -match '^Would reformat:\s*(.+)$') {
                & $add $Matches[1]
            }
        }
        # Format leaves an unsorted import block as it is, so the import-sort rule is asked too; each finding names its file.
        $sort = Invoke-PythonWorkspaceTool -Tool 'ruff check --select I --output-format concise' -File $batch
        if ($sort.ExitCode -notin 0, 1) {
            throw "ruff could not check the Python imports (exit $($sort.ExitCode)):`n$($sort.Full)"
        }
        foreach ($line in ($sort.Full -split '\r?\n')) {
            if ($line -match '^(.+?):\d+:\d+: I\d{3}') {
                & $add $Matches[1]
            }
        }
    }
    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            # Imports first, so the block they leave is formatted with the rest.
            $fix = Invoke-PythonWorkspaceTool -Tool 'ruff check --select I --fix' -File $batch
            if ($fix.ExitCode -ne 0) {
                throw "ruff could not sort the Python imports (exit $($fix.ExitCode)):`n$($fix.Full)"
            }
            $write = Invoke-PythonWorkspaceTool -Tool 'ruff format' -File $batch
            if ($write.ExitCode -ne 0) {
                throw "ruff could not format the Python files (exit $($write.ExitCode)):`n$($write.Full)"
            }
        }
    }

    , [string[]] $changed.ToArray()
}
