# automation/Catzc.Base.QualityGates/private/ConvertTo-PesterRunTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Splits a run's paths into the Pester run paths and the language bridge containers.

### description

A test run's paths are tests/ folders and `*.Tests.ps1` files, which Pester runs by path, and the test folders of
the test languages beside PowerShell (Get-LanguageTestFolders: Go, Python), which have no Pester file of their
own: each runs through the one shared language bridge, automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1,
as a Pester container whose data names the language (Language), the folder (TestFolder), the engine entry the
tests start (EntryScript), the tool that runs them (Executable, that language's entry of -LanguageExecutable), and
the executables of the other execution engines the tests also run under (EngineExecutable: one entry per engine
other than pwsh, by its name, empty for an engine the source session did not find).
Get-TestRunFile reads the folder back from a test's container, so the folder stays the run file of its tests.

The bridge is read from the repository, not the code root: tests never ship, and the build run runs the
repository's tests against the build.

### parameter Path

The run's paths, in run order.

### parameter EntryScript

The engine entry of a build run (the build's Import-Catzc.ps1), handed to the bridge; empty for the source run.

### parameter LanguageExecutable

The managed tool per language the run's source session located (Get-LanguageTestExecutable:
@{ go = `<path>`; python = `<uv path>`; `<engine>` = `<path>` per engine other than pwsh }), handed to the bridge; a
missing or empty entry means there is none.

### outputs

`[pscustomobject]` { Path (`string[]`, the paths Pester runs as files and folders, in order); Container (`object[]`,
one bridge container per language test folder, in order) }.

### example 1

```powershell
$target = ConvertTo-PesterRunTarget -Path $testPaths
```
