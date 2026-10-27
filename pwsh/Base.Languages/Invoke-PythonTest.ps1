function Invoke-PythonTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $UvExecutable,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable,

        [string] $Folder
    )

    $root = Get-RepositoryRoot
    $python = Get-Config -Config python
    # The uv workspace root: python.yml's declared root, else python/ when present, else .python/.
    $pythonRelative = $python.ResolveRoot($root)
    $pythonRoot = Join-Path $root $pythonRelative
    # The folder named, else the module's own tests/ or the holder's, else its folder under the holder's tests/.
    $relative = if ($Folder) {
        [System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath($Folder, $root)).Replace('\',
            '/').TrimEnd('/')
    }
    elseif (Test-Path -LiteralPath (Join-Path $root "$pythonRelative/$Module/tests") -PathType Container) {
        # A kit module is named by its folder, never pascal-dotted.
        "$pythonRelative/$Module/tests"
    }
    else {
        # Named for the module's folder, which drops the modules track's namespace.
        $moduleFolder = (Get-Config -Config languages).TestFolderOf('python', (Get-Config -Config variants), $Module)
        $own = "$pythonRelative/$moduleFolder/tests"
        if (Test-Path -LiteralPath (Join-Path $root $own) -PathType Container) {
            $own
        }
        else {
            "$pythonRelative/tests/$moduleFolder"
        }
    }
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no Python tests: $relative/ does not exist."
    }
    # The uv commands run from the workspace root, so the folder is named relative to it.
    $inWorkspace = [System.IO.Path]::GetRelativePath($pythonRoot, $folder).Replace('\', '/')
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf)) {
        throw "$pythonRelative/pyproject.toml is missing — it is generated; regenerate with: Build-RootConfig"
    }
    # The workspace member is the test folder itself (the holder's) or the module above its own tests/ folder.
    $member = @("$relative/pyproject.toml",
        "$($relative.Substring(0, [Math]::Max(0, $relative.LastIndexOf('/'))))/pyproject.toml").Where({ Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf })
    if ($member.Count -eq 0) {
        throw "$relative/pyproject.toml is missing — it is generated; regenerate with: Build-RootConfig"
    }

    # The managed uv by its path, the caller's or located from tools.yml; never a bare uv off PATH.
    $uvPath = if ($UvExecutable) {
        Assert-PathExist $UvExecutable -PathType Leaf
        $UvExecutable
    }
    else {
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not $uv.Found) {
            throw 'uv is not installed (no managed uv found). Run Install-Uv.'
        }
        if (-not $uv.VersionOk) {
            throw "uv at $($uv.Path) reports version '$($uv.Version)', but tools.yml pins '$($uv.Required)'. Run Install-Uv."
        }
        $uv.Path
    }
    $uvCommand = "`"$uvPath`""

    # A test run never syncs, since a sync resolves and downloads; the environment comes from the explicit install command.
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot '.venv/pyvenv.cfg') -PathType Leaf)) {
        throw "$pythonRelative/.venv is not synced, and a test run never syncs it; sync it once with: Install-PythonWorkspace"
    }
    # A strict editable install links files one by one, so a new module has no link until its package is reinstalled.
    $memberRoot = Split-Path -Parent (Join-Path $root $member[0])
    $buildCopy = @(Get-Item -Path (Join-Path $memberRoot 'build/__editable__.*') -ErrorAction Ignore).Where({ $_.PSIsContainer }, 'First')
    if ($buildCopy) {
        $linked = [System.Collections.Generic.HashSet[string]]::new(
            [string[]]@(Get-ChildItem -LiteralPath $buildCopy[0].FullName -Filter '*.py' -Recurse -File).Name)
        $unlinked = @(Get-ChildItem -LiteralPath $memberRoot -Filter '*.py' -File).Where({ -not $linked.Contains($_.Name) })
        $package = [regex]::Match([System.IO.File]::ReadAllText((Join-Path $memberRoot 'pyproject.toml')),
            '(?m)^name\s*=\s*"([^"]+)"').Groups[1].Value
        if ($unlinked.Count -and $package) {
            throw ("$($unlinked[0].Name) in $relative/ has no link in the installed $package, and a test run never reinstalls it; " +
                "relink it with: Install-PythonWorkspace -ReinstallPackage $package")
        }
    }

    $report =Join-Path ([System.IO.Path]::GetTempPath()) "catzc-pytest-$([guid]::NewGuid().ToString('N')).xml"

    $cacheDir = Join-Path $root $python.pytest_cache

    # The engine contract is set for these commands only; UV_PYTHON_DOWNLOADS=never keeps uv on the pinned interpreter and
    # UV_OFFLINE=1 keeps every uv call off the network.
    $environment = Get-EngineContract -Engine $Engine -EngineExecutable $EngineExecutable -EntryScript $EntryScript
    $environment['UV_PYTHON_DOWNLOADS'] = 'never'
    $environment['UV_OFFLINE'] = '1'
    $environment['PYTHONPYCACHEPREFIX'] = Join-Path $root $python.pycache
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $lint = Invoke-Executable "$uvCommand run --no-sync --quiet ruff check `"$inWorkspace`"" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($lint.ExitCode -ne 0) {
            throw "ruff check failed in $relative/ (exit $($lint.ExitCode)):`n$($lint.Full)"
        }

        $run = Invoke-Executable ("$uvCommand run --no-sync --quiet pytest `"$inWorkspace`" --rootdir `"$inWorkspace`" " +
            "--import-mode=importlib -o cache_dir=`"$cacheDir`" --junitxml `"$report`"") -WorkingDirectory $pythonRoot -PassThru -NoAssert
        $reportText = if (Test-Path -LiteralPath $report -PathType Leaf) {
            [System.IO.File]::ReadAllText($report)
        }
        else {
            ''
        }
    }
    finally {
        foreach ($name in $environment.Keys) {
            if ($null -eq $saved[$name]) {
                Remove-Item -LiteralPath "Env:$name" -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable($name, $saved[$name])
            }
        }
        Remove-Item -LiteralPath $report -Force -ErrorAction Ignore
    }

    try {
        $results = @(ConvertFrom-PytestJunit -Text $reportText)
    }
    catch {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)): $($_.Exception.Message)`n$($run.Full)"
    }

    # pytest exits 1 for a failed test; any other exit, or 1 with none failed, failed around the tests.
    if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and
            @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
