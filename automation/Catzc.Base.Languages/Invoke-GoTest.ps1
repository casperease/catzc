<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Invoke-GoTest.ps1
    kind: automation-function
    module: Catzc.Base.Languages
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
      test: automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE
      - ADR-AUTO-ENVVAR#1
      - ADR-AUTO-GO#6
  config:
    synopsis: Runs a catzc module's Go tests and returns one result per Go test.
    description: |-
      In the module's Go test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
      the Go root is go.yml's `root`, by default go/ when the repository has one, else .go/), runs three go commands
      from inside that folder, so ./... expands below the module root whatever the root's name, through
      Invoke-Executable, each inside its time safeguard (the `go` entry of timeouts.yml). It runs the managed go by
      its path, located from its tools.yml entry by Resolve-ToolExecutable (Catzc.Base.Execution), and never a bare go
      off PATH; it throws with "Run Install-Go" when no go is found or the one found does not match the tools.yml
      pin:

        go mod download                fetches the declared dependencies and records go.sum;
        go vet ./...                   type-checks and vets the test packages;
        go test -json -count=1 ./...   runs every test, uncached, as a test2json event stream.

      The Go tests are black-box tests: they start the engine and assert on its output. How to start it reaches them
      through the environment (Get-EngineContract), set for these commands only and restored afterwards:

        CATZC_ENGINE_EXECUTABLE  the engine's executable;
        CATZC_ENGINE_START       the arguments after it, as a JSON array that loads the entry — the repository's
                                 importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a
                                 build run — and ends in the command text, with {command} where the test's command goes;
        CATZC_REPOSITORY_ROOT    the repository root.

      Returns one GoTestResult per top-level Go test (subtests fold into it), with its category from its name:
      TestIntegrity* is integrity, everything else is logic. A failing Go test is a result, not an error. The call
      throws, with the go output, when go vet fails, when the test package does not build, or when a package fails
      outside any test.

      The folder's go.mod and the root go.work are generated (New-GoWorkspace, written by Build-RootConfig on
      import); a missing go.mod throws with that remediation.
    parameters:
      Module: The catzc module whose Go tests to run (e.g. Catzc.Base.Repository).
      EntryScript: |-
        The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
        source run).
      GoExecutable: |-
        The go to run, already located and checked against the pin by the caller: a test run passes the go its source
        session resolved, because a build run's engine does not carry the tools.yml entry. Default: located here by
        Resolve-ToolExecutable.
      Engine: |-
        The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats
        dispatcher ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). The tests are the same; only the contract
        they read changes.
      EngineExecutable: 'The engine''s executable, already located by the caller. Default: located here by Resolve-EngineExecutable.'
    outputs: '[Catzc.Base.Languages.GoTestResult] One record per Go test.'
    examples:
      - Invoke-GoTest Catzc.Base.Repository
      - Invoke-GoTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
---
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
