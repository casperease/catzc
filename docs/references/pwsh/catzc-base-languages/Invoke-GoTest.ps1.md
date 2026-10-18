# pwsh/Catzc.Base.Languages/Invoke-GoTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
go mod download                fetches the declared dependencies and records go.sum;
go vet ./...                   type-checks and vets the test packages;
go test -json -count=1 ./...   runs every test, uncached, as a test2json event stream.
```

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
([ADR-AUTO-ENGINE](../../../adr/automation/execution-engines.md)). The tests are the same; only the contract they read changes.

### parameter `EngineExecutable`

The engine's executable, already located by the caller. Default: located here by Resolve-EngineExecutable.

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

## comment:1

Above `$goPath = if ($GoExecutable) {`, written with `#`.

```text
The managed go, by its path: the caller's, already located and checked, or located here from its tools.yml entry
(Resolve-ToolExecutable); never a bare go off PATH.
```

## comment:2

Above `$environment = Get-EngineContract -Engine $Engine -EngineExecutable...`, written with `#`.

```text
How the tests start the engine (Get-EngineContract) is an external contract with the go test processes
([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
commands only, then restored. GOTOOLCHAIN=local keeps go on the managed binary just checked: without it, go
reads go.work's go directive and silently downloads that toolchain instead
([ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)).
```
