<#
.SYNOPSIS
    Runs a catzc module's Go tests and returns one result per Go test.
.DESCRIPTION
    In the module's Go test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
    the Go root is go.yml's `root`, by default go/ when the repository has one, else .go/), runs three go commands
    from inside that folder, so ./... expands below the module root whatever the root's name, through
    Invoke-Executable, each inside its time safeguard (the `go` entry of timeouts.yml). It runs the managed go by its path, located from its tools.yml entry by Resolve-ToolExecutable
    (Catzc.Base.Execution), and never a bare go off PATH; it throws with "Run Install-Go" when no go is found or the
    one found does not match the tools.yml pin:

      go mod download                fetches the declared dependencies and records go.sum;
      go vet ./...                   type-checks and vets the test packages;
      go test -json -count=1 ./...   runs every test, uncached, as a test2json event stream.

    The Go tests are black-box tests: they start the engine and assert on its output. The engine entry reaches
    them through the environment, set for these commands only and restored afterwards:

      CATZC_ENGINE_ENTRY     the script a test runs to load the engine: the repository's importer.ps1 for a source
                             run, or -EntryScript (the build's Import-Catzc.ps1) for a build run;
      CATZC_REPOSITORY_ROOT  the repository root.

    Returns one GoTestResult per top-level Go test (subtests fold into it), with its category from its name:
    TestIntegrity* is integrity, everything else is logic. A failing Go test is a result, not an error. The call
    throws, with the go output, when go vet fails, when the test package does not build, or when a package fails
    outside any test.

    The folder's go.mod and the root go.work are generated (New-GoWorkspace, written by Build-RootConfig on
    import); a missing go.mod throws with that remediation.
.PARAMETER Module
    The catzc module whose Go tests to run (e.g. Catzc.Base.Repository).
.PARAMETER EntryScript
    The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
    source run).
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

        [string] $EntryScript
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

    # The managed go, by its path (Resolve-ToolExecutable reads the tools.yml entry); never a bare go off PATH.
    $go = Resolve-ToolExecutable -Tool go
    if (-not $go.Found) {
        throw 'go is not installed (no managed go found). Run Install-Go.'
    }
    if (-not $go.VersionOk) {
        throw "go at $($go.Path) reports version '$($go.Version)', but tools.yml pins '$($go.Required)'. Run Install-Go."
    }
    $goCommand = "`"$($go.Path)`""

    $entry = if ($EntryScript) {
        Assert-PathExist $EntryScript -PathType Leaf
        (Resolve-Path -LiteralPath $EntryScript).ProviderPath
    }
    else {
        Join-Path $root 'importer.ps1'
    }

    # The engine entry is an external contract with the go test processes
    # ([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
    # commands only, then restored. GOTOOLCHAIN=local keeps go on the managed binary just checked: without it, go
    # reads go.work's go directive and silently downloads that toolchain instead (ADR-AUTO-GO#6).
    $environment = [ordered]@{
        CATZC_ENGINE_ENTRY    = $entry
        CATZC_REPOSITORY_ROOT = $root
        GOTOOLCHAIN           = 'local'
    }
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
