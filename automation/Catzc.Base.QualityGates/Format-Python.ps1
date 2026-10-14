<#
.SYNOPSIS
    Formats the repository's Python files with ruff.
.DESCRIPTION
    Runs `ruff format` over every .py file the repository holds (Get-PythonCheckScope: the Python test folders, and the
    tracked .py files outside the Python root, such as the agent helpers under .claude/;
    [ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)): `ruff format --check` lists
    the files whose formatting differs, then `ruff format` rewrites exactly those, unless -DryRun. ruff is pinned in
    python.yml and runs from the Python test workspace's environment with the workspace's settings (the 140-column
    line, the pinned Python) for every file, wherever it lives (Invoke-PythonWorkspaceTool).

    Throws with "Run Install-Uv" when no uv at the pin is found, and with uv's message when the interpreter at the pin
    is missing. A repository without Python has nothing to format and needs no uv. A file ruff cannot parse throws with
    ruff's message.

    A source-tree tool: it rewrites the repository's Python files, so it throws in build mode (Assert-SourceTree).
.PARAMETER Path
    Folders or .py files to format. Defaults to every .py file the repository holds. Any other file throws: the
    pyproject.toml files are generated (New-PythonProject), not formatted.
.PARAMETER DryRun
    Report which files would change without writing them (the returned list is the same either way).
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, DryRun }) instead of the list of files.
.OUTPUTS
    [string[]] The full paths of the files that changed (or, under -DryRun, would change).
.EXAMPLE
    Format-Python
.EXAMPLE
    Format-Python -DryRun
#>
function Format-Python {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $targets = @(if ($Path) {
            foreach ($item in $Path) {
                $full = (Resolve-Path -LiteralPath $item).ProviderPath
                if ((Test-Path -LiteralPath $full -PathType Leaf) -and [System.IO.Path]::GetExtension($full) -ne '.py') {
                    throw "Format-Python formats .py files and folders of them; '$item' is not a .py file (the pyproject.toml files are generated — run Build-RootConfig)."
                }
                $full
            }
        }
        else {
            Get-PythonCheckScope
        })

    $changed = [System.Collections.Generic.List[string]]::new()
    if ($targets.Count -gt 0) {
        $pythonRoot = Join-Path (Get-RepositoryRoot) (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
        # --check exits 1 when a file would change and names each on a 'Would reformat: <path>' line.
        $check = Invoke-PythonWorkspaceTool -Tool 'ruff format --check' -File $targets
        if ($check.ExitCode -notin 0, 1) {
            throw "ruff could not format the Python files (exit $($check.ExitCode)):`n$($check.Full)"
        }
        foreach ($line in ($check.Full -split '\r?\n')) {
            if ($line -match '^Would reformat:\s*(.+)$') {
                $changed.Add([System.IO.Path]::GetFullPath($Matches[1].Trim(), $pythonRoot))
            }
        }
        if ($changed.Count -gt 0 -and -not $DryRun) {
            $write = Invoke-PythonWorkspaceTool -Tool 'ruff format' -File $changed.ToArray()
            if ($write.ExitCode -ne 0) {
                throw "ruff could not format the Python files (exit $($write.ExitCode)):`n$($write.Full)"
            }
        }
    }

    $verb = $DryRun ? 'would format' : 'formatted'
    Write-Message "$verb $($changed.Count) Python file(s) across $($targets.Count) path(s)"

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changed.Count
            ChangedFiles = $changed.ToArray()
            DryRun       = [bool]$DryRun
        }
    }
    $changed.ToArray()
}
