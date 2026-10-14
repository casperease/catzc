<#
.SYNOPSIS
    Formats the repository's Python test files with ruff.
.DESCRIPTION
    Runs `ruff format` over every Python test folder (Get-LanguageTestFolders, language python: python/tests/<module>/,
    [ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)) in the generated Python
    test project: `ruff format --check` lists the files whose formatting differs, then `ruff format` rewrites exactly
    those, unless -DryRun. ruff is pinned in python.yml and runs from the project's environment through the managed uv
    (`uv run`), so every machine formats with the same version and the project's ruff settings (the 140-column line).

    uv is the managed uv (Resolve-ToolExecutable, the tools.yml `uv` entry), run with UV_PYTHON_DOWNLOADS=never: it
    throws with "Run Install-Uv" when no uv at the pin is found, and uv fails with its message when the interpreter
    at the pin is missing. A repository without Python test folders has nothing to format and needs no uv. A file ruff
    cannot parse throws with ruff's message.

    A source-tree tool: it rewrites the repository's Python files, so it throws in build mode (Assert-SourceTree).
.PARAMETER Path
    Folders or .py files to format. Defaults to every Python test folder. Any other file throws: the project file
    python/pyproject.toml is generated (New-PythonProject), not formatted.
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
                    throw "Format-Python formats .py files and folders of them; '$item' is not a .py file (python/pyproject.toml is generated — run Build-RootConfig)."
                }
                $full
            }
        }
        else {
            foreach ($testFolder in @(Get-LanguageTestFolders)) {
                if ($testFolder.Language -eq 'python') {
                    $testFolder.Folder
                }
            }
        })

    $changed = [System.Collections.Generic.List[string]]::new()
    if ($targets.Count -gt 0) {
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not ($uv.Found -and $uv.VersionOk)) {
            throw "Format-Python needs the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
        }
        $pythonRoot = Join-Path (Get-RepositoryRoot) ([Catzc.Base.Languages.PythonConfig]::Root)
        $quoted = ($targets | ForEach-Object { "`"$_`"" }) -join ' '

        $saved = [System.Environment]::GetEnvironmentVariable('UV_PYTHON_DOWNLOADS')
        [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', 'never')
        try {
            # --check exits 1 when a file would change and names each on a 'Would reformat: <path>' line.
            $check = Invoke-Executable "`"$($uv.Path)`" run --quiet ruff format --check $quoted" -WorkingDirectory $pythonRoot -PassThru -NoAssert -Silent
            if ($check.ExitCode -notin 0, 1) {
                throw "ruff could not format the Python files (exit $($check.ExitCode)):`n$($check.Full)"
            }
            foreach ($line in ($check.Full -split '\r?\n')) {
                if ($line -match '^Would reformat:\s*(.+)$') {
                    $changed.Add([System.IO.Path]::GetFullPath($Matches[1].Trim(), $pythonRoot))
                }
            }
            if ($changed.Count -gt 0 -and -not $DryRun) {
                $files = ($changed | ForEach-Object { "`"$_`"" }) -join ' '
                Invoke-Executable "`"$($uv.Path)`" run --quiet ruff format $files" -WorkingDirectory $pythonRoot -Silent
            }
        }
        finally {
            if ($null -eq $saved) {
                Remove-Item -LiteralPath Env:UV_PYTHON_DOWNLOADS -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', $saved)
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
