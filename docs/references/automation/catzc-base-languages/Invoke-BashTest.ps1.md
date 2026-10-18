# automation/Catzc.Base.Languages/Invoke-BashTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a catzc module's Bash tests and returns one result per Bash test.

### description

In the module's Bash test folder, `<root>/tests/<module-in-kebab>/` (Catzc.Base.Repository -> catzc-base-repository; the Bash root is
bash.yml's `root`, by default bash/ when the repository has one, else .bash/), runs the bats-core runner vendored at
`<root>/.vendor/bats-core/` (the bash.yml pin) under the bash engine, from the Bash root, through Invoke-Executable inside its time
safeguard (the bash entry of timeouts.yml):

```text
bash .vendor/bats-core/bin/bats --recursive --report-formatter junit --output <temp> tests/<folder>
```

The Bash tests are black-box tests: they load the engine's entry and call catzc through the cats dispatcher, as a Bash user does. How
reaches them through the environment (Get-EngineContract for the bash engine), set for this command only and restored afterwards:
CATZC_ENGINE_ENTRY, the repository's importer.sh, which a test's setup loads; CATZC_IMPORTER, the PowerShell entry cats loads — the
repository's importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a build run; and CATZC_REPOSITORY_ROOT. A
Bash test runs only under the bash engine: it is Bash.

Returns one BashTestResult per @test, with its category from its name: a name starting with "integrity:" is integrity, everything else
logic. A failing test is a result, not an error. The call throws, with the bats output, when the vendored runner is missing, and when bats
fails without a failing test (a syntax error in a .bats file, or no tests).

### parameter Module

The catzc module whose Bash tests to run (e.g. Catzc.Base.Repository).

### parameter EntryScript

The PowerShell entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the source run).

### parameter EngineExecutable

The bash to run, already located by the caller: a test run passes the bash its source session resolved, because a build run's engine does
not carry the tools.yml entry. Default: located here by Resolve-EngineExecutable.

### outputs

`[Catzc.Base.Languages.BashTestResult]` One record per Bash test.

### example 1

```powershell
Invoke-BashTest Catzc.Base.Repository
```

### example 2

```powershell
Invoke-BashTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
```

## comment:1

Above `if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results |...`, written with `#`.

```text
bats exits 1 when a test failed; a non-zero exit with no failing test, or no test at all, means it failed around
the tests (a .bats file that does not parse, a failing setup_file).
```
