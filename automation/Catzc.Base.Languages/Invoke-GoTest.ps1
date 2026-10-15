<#
.SYNOPSIS
    Runs a catzc module's Go tests and returns one result per Go test.
.DESCRIPTION
    In the module's Go test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;...
    [comment:1](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment1)
.PARAMETER Module
    The catzc module whose Go tests to run (e.g. Catzc.Base.Repository).
.PARAMETER EntryScript
    The engine entry for a build run: the build's Import-Catzc.ps1.
    [comment:2](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment2)
.PARAMETER GoExecutable
    The go to run, already located and checked against the pin by the caller: a test run passes the go its source...
    [comment:3](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment3)
.PARAMETER Engine
    The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats...
    [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)
    [comment:4](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment4)
.PARAMETER EngineExecutable
    The engine's executable, already located by the caller. Default: located here by Resolve-EngineExecutable.
.OUTPUTS
    [Catzc.Base.Languages.GoTestResult] One record per Go test.
.EXAMPLE
    Invoke-GoTest Catzc.Base.Repository
.EXAMPLE
    Invoke-GoTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
#>
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

        [string] $EngineExecutable
    )

    $root = Get-RepositoryRoot
    $folderName = $Module.ToLowerInvariant().Replace('.', '-')
    # The Go root from go.yml (GoConfig.ResolveRoot: the declared root, else go/ when present, else .go/).
    $relative = "$((Get-Config -Config go).ResolveRoot($root))/tests/$folderName"
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no Go tests: $relative/ does not exist."
    }
    if (-not (Test-Path -LiteralPath (Join-Path $folder 'go.mod') -PathType Leaf)) {
        throw "$relative/go.mod is missing — it is generated; regenerate with: Build-RootConfig"
    }

    # The managed go, by its path: the caller's, already located and checked, or located here from its tools.yml...
    # [comment:5](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment5)
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

    # How the tests start the engine (Get-EngineContract) is an external contract with the go test processes: set for...
    # [ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1),
    # [ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)
    # [comment:6](/docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md#comment6)
    $environment = Get-EngineContract -Engine $Engine -EngineExecutable $EngineExecutable -EntryScript $EntryScript
    $environment['GOTOOLCHAIN'] = 'local'
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $download = Invoke-Executable "$goCommand mod download" -WorkingDirectory $folder -PassThru -NoAssert
        if ($download.ExitCode -ne 0) {
            throw "go mod download failed in $relative/ (exit $($download.ExitCode)):`n$($download.Full)"
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
