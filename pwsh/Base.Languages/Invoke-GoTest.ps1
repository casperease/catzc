function Invoke-GoTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.GoTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $GoExecutable,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable,

        [string] $Folder
    )

    $root = Get-RepositoryRoot
    # The folder named, else the module's own tests/ or the holder's, else its folder under the Go root's tests/.
    $relative = if ($Folder) {
        [System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath($Folder, $root)).Replace('\',
            '/').TrimEnd('/')
    }
    else {
        "$((Get-Config -Config go).ResolveRoot($root))/tests/$((Get-Config -Config languages).TestFolderOf('go', (Get-Config -Config variants), $Module))"
    }
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no Go tests: $relative/ does not exist."
    }
    # The generated go.mod sits in the test folder (the holder's) or at the module root above its own tests/ folder.
    $modules = @("$relative/go.mod",
        "$($relative.Substring(0, [Math]::Max(0, $relative.LastIndexOf('/'))))/go.mod").Where({ Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf })
    if ($modules.Count -eq 0) {
        throw "$relative/go.mod is missing — it is generated; regenerate with: Build-RootConfig"
    }

    # The managed go by its path, the caller's or located from tools.yml; never a bare go off PATH.
    $goPath = if ($GoExecutable) {
        Assert-PathExist $GoExecutable -PathType Leaf
        $GoExecutable
    }
    else {
        $go = Resolve-ToolExecutable -Tool go
        if (-not $go.Found) {
            throw 'go is not installed (no managed go found). Run Install-Go.'
        }
        if (-not $go.VersionOk) {
            throw "go at $($go.Path) reports version '$($go.Version)', but tools.yml pins '$($go.Required)'. Run Install-Go."
        }
        $go.Path
    }
    $goCommand = "`"$goPath`""

    # The engine contract is set for these commands only; GOTOOLCHAIN=local stops go downloading go.work's toolchain, and
    # GOPROXY=off with GOFLAGS=-mod=mod keeps every go command on the module cache, writing go.sum from it; GOWORK=off runs each
    # command in its own module, since workspace mode refuses -mod=mod and go.work is the editors' layout.
    $environment = Get-EngineContract -Engine $Engine -EngineExecutable $EngineExecutable -EntryScript $EntryScript
    $environment['GOTOOLCHAIN'] = 'local'
    $environment['GOPROXY'] = 'off'
    $environment['GOFLAGS'] = '-mod=mod'
    $environment['GOWORK'] = 'off'
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $download = Invoke-Executable "$goCommand mod download" -WorkingDirectory $folder -PassThru -NoAssert
        if ($download.ExitCode -ne 0) {
            throw ("go could not resolve its modules offline in $relative/ (exit $($download.ExitCode)); a test run keeps GOPROXY=off and " +
                "never fetches, so fill the module cache once with: Invoke-Go '-C $relative mod download'`n$($download.Full)")
        }

        $vet = Invoke-Executable "$goCommand vet ./..." -WorkingDirectory $folder -PassThru -NoAssert
        if ($vet.ExitCode -ne 0) {
            throw "go vet failed in $relative/ (exit $($vet.ExitCode)):`n$($vet.Full)"
        }

        $run = Invoke-Executable "$goCommand test -json -count=1 ./..." -WorkingDirectory $folder -PassThru -NoAssert
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
    }

    try {
        $results = @(ConvertFrom-GoTestJson -Text $run.Output)
    }
    catch {
        throw "go test failed in $relative/ (exit $($run.ExitCode)): $($_.Exception.Message)`n$($run.Errors)"
    }

    # A non-zero exit means a failing test; with none, go failed before or around the tests.
    if ($run.ExitCode -ne 0 -and -not @($results | Where-Object { $_.Outcome -eq 'fail' }).Count) {
        throw "go test failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
