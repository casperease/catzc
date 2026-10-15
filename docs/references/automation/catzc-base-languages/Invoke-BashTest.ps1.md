---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md
    kind: comment-page
    body_sha: fc008ee63a4d
---

# automation/Catzc.Base.Languages/Invoke-BashTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
In the module's Bash test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
the Bash root is bash.yml's `root`, by default bash/ when the repository has one, else .bash/), runs the bats-core
runner vendored at <root>/.vendor/bats-core/ (the bash.yml pin) under the bash engine, from the Bash root, through
Invoke-Executable inside its time safeguard (the bash entry of timeouts.yml):

  bash .vendor/bats-core/bin/bats --recursive --report-formatter junit --output <temp> tests/<folder>

The Bash tests are black-box tests: they load the engine's entry and call catzc through the cats dispatcher,
as a Bash user does. How reaches them through the environment (Get-EngineContract for the bash engine), set for
this command only and restored afterwards: CATZC_ENGINE_ENTRY, the repository's importer.sh, which a test's setup
loads; CATZC_IMPORTER, the PowerShell entry cats loads — the repository's importer.ps1 for a source run, or
-EntryScript (the build's Import-Catzc.ps1) for a build run; and CATZC_REPOSITORY_ROOT. A Bash test runs only
under the bash engine: it is Bash.

Returns one BashTestResult per @test, with its category from its name: a name starting with "integrity:" is
integrity, everything else logic. A failing test is a result, not an error. The call throws, with the bats
output, when the vendored runner is missing, and when bats fails without a failing test (a syntax error in a
.bats file, or no tests).
```

## comment:2

Section `.PARAMETER EntryScript` of the comment-based help.

```text
The PowerShell entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
source run).
```

## comment:3

Section `.PARAMETER EngineExecutable` of the comment-based help.

```text
The bash to run, already located by the caller: a test run passes the bash its source session resolved, because a
build run's engine does not carry the tools.yml entry. Default: located here by Resolve-EngineExecutable.
```

## comment:4

Above `if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results |...`.

```text
bats exits 1 when a test failed; a non-zero exit with no failing test, or no test at all, means it failed around
the tests (a .bats file that does not parse, a failing setup_file).
```

## comment:5

Above `if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results |...`.

```text
bats exits 1 when a test failed; a non-zero exit with no failing test, or no test at all, means it failed around
the tests (a .bats file that does not parse, a failing setup_file).
```
