# pwsh/Base.Languages/Invoke-GoTest.ps1

`Invoke-GoTest` runs a module's Go tests with the managed go and returns one `GoTestResult` per top-level Go test. The Go root comes from
`go.yml`, and the tests start the engine through the contract `Get-EngineContract` builds.

## help

### synopsis

Runs a catzc module's Go tests and returns one result per Go test.

### description

In the module's Go test folder, `<root>/tests/<module-in-kebab>/` (Catzc.Base.Repository -> catzc-base-repository; the Go root is go.yml's
`root`, by default go/ when the repository has one, else .go/), runs three go commands from inside that folder, so ./... expands below the
module root whatever the root's name, through Invoke-Executable, each inside its time safeguard (the `go` entry of timeouts.yml). It runs
the managed go by its path, located from its tools.yml entry by Resolve-ToolExecutable (Catzc.Base.Execution), and never a bare go off PATH;
it throws with "Run Install-Go" when no go is found or the one found does not match the tools.yml pin:

```text
go mod download                resolves the declared dependencies from the module cache and records go.sum;
go vet ./...                   type-checks and vets the test packages;
go test -json -count=1 ./...   runs every test, uncached, as a test2json event stream.
```

Every go command runs offline: the module proxy is off and `-mod=mod` is set, which keeps it on the module cache, writing go.sum from it,
and GOTOOLCHAIN=local keeps it on the managed toolchain. GOWORK=off runs each command in its own module rather than the root go.work, which
is the editors' layout and whose workspace mode refuses `-mod=mod`. A module missing from the cache fails the run with the explicit fetch that fills
it, `Invoke-Go '-C <folder> mod download'`.

The Go tests are black-box tests: they start the engine and assert on its output. How to start it reaches them through the environment
(Get-EngineContract), set for these commands only and restored afterwards:

```text
CATZC_ENGINE_EXECUTABLE  the engine's executable;
CATZC_ENGINE_START       the arguments after it, as a JSON array that loads the entry — the repository's
                         importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a
                         build run — and ends in the command text, with {command} where the test's command goes;
CATZC_REPOSITORY_ROOT    the repository root.
```

Returns one GoTestResult per top-level Go test (subtests fold into it), with its category from its name: `TestIntegrity*` is integrity,
everything else is logic. A failing Go test is a result, not an error. The call throws, with the go output, when go vet fails, when the test
package does not build, or when a package fails outside any test.

The folder's go.mod and the root go.work are generated (New-GoWorkspace, written by Build-RootConfig on import); a missing go.mod throws
with that remediation.

### parameter `Module`

The catzc module whose Go tests to run (e.g. Catzc.Base.Repository).

### parameter `EntryScript`

The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the source run).

### parameter `GoExecutable`

The go to run, already located and checked against the pin by the caller: a test run passes the go its source session resolved, because a
build run's engine does not carry the tools.yml entry. Default: located here by Resolve-ToolExecutable.

### parameter `Engine`

The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats dispatcher
([ADR-AUTO-ENGINE](../../../drs/automation/execution-engines.md)). The tests are the same; only the contract they read changes.

### parameter `EngineExecutable`

The engine's executable, already located by the caller. Default: located here by Resolve-EngineExecutable.

### parameter `Folder`

The test folder to run, repository-relative or absolute: the holder's `<root>/tests/<kebab>` or a module's own `tests/` folder, whose
generated `go.mod` sits at the module root. Default: the holder's folder of the module.

### outputs

`[Catzc.Base.Languages.GoTestResult]` One record per Go test.

### example 1

```powershell
Invoke-GoTest Catzc.Base.Repository
```

### example 2

```powershell
Invoke-GoTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
```

## The managed go

The go is the managed one, by its path: the caller's, already located and checked, or located from its `tools.yml` entry by
`Resolve-ToolExecutable`. A bare go off PATH is never run.

## The environment

How the tests start the engine (`Get-EngineContract`) is an external contract with the go test processes
([ADR-AUTO-ENVVAR-SETONLYFORTOOLS](../../../drs/automation/environment-variables.md#rule-adr-auto-envvar-setonlyfortools)): set for these
commands only, then restored. `GOTOOLCHAIN=local` keeps go on the managed binary just checked. Without it, go reads the `go` directive of
`go.work` and silently downloads that toolchain instead
([ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain)).

## The test folder

The folder is the one named, a module's own `tests/` or the holder's, else the holder's `tests/<kebab>` of the module under the Go root from
`go.yml` (`GoConfig.ResolveRoot`: the declared root, else `go/` when present, else `.go/`), in go's folder case.
