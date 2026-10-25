# pwsh/Catzc.Base.QualityGates/Test-CatzcBuild.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a build run: the same tests as Test-Automation, against a fresh build of the selected modules.

### description

The second of the two test runs over one body of tests
([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns),
[DDR-RUNMODE-SAMETESTSBOTHMODES](../../../drs/design/run-modes.md#rule-ddr-runmode-sametestsbothmodes)). It builds the selected modules with
Build-Modules (vendor policy 'full', so Pester and PSScriptAnalyzer ship with the build) into a fresh temporary destination, then runs the
Test-Automation harness unchanged in shape — discovery, the tier/category tag checks, sharding, rows, reports — with one seam swapped: each
shard worker dot-sources the build's Import-Catzc.ps1 -RepositoryRoot `<repo>` instead of the repository importer, so every test runs
against the merged, built modules while out/ and the test fixtures keep resolving in the repository.

Test files come from the source tree, limited to the tests/ folders of the modules the selection resolves to (the dependency closure
Build-Modules computes). Tests tagged 'source-only'
([ADR-AUTO-TEST-SOURCEONLYTAG](../../../drs/automation/test-automation.md#rule-adr-auto-test-sourceonlytag)) are excluded and counted and
listed — on the console and in excluded-tests.csv in the run directory — never silently. Reports go to `<out>/test-catzc-build/`, so the two
test runs' reports never overwrite each other. The build is deleted when the run ends.

The harness's own module is always built too (each worker reaches its configuration builder and row reducer through that module's scope),
but its tests run only when the selection includes it.

Test-CatzcBuild operates on the source tree — it builds from it and reads its tests — so it runs in source mode only (Assert-SourceTree).

### parameter `Module`

Modules to build and test (combinable with -ModuleProfile; closure-expanded by Build-Modules). Neither -> the default bundle's profile
(exporter.yml default_bundle).

### parameter `ModuleProfile`

A module profile (profiles.yml) to build and test.

### parameter `MinLevel`

Minimum test tier. Defaults to 0.

### parameter `MaxLevel`

Maximum test tier (alias: -Level). Defaults to 3, as in Test-Automation: L0-L3 when the run owns the working folder, L0-L2 in a snapshot,
which skips L3 and says so
([ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../drs/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)). 4 adds the opt-in
L4 tier.

### parameter `Category`

Logic, Integrity, or Both (the default) — as in Test-Automation.

### parameter `Workers`

Worker pool size; 0 (the default) sizes it automatically — as in Test-Automation.

### parameter `Output`

Pester output verbosity inside each worker. Defaults to 'Detailed'.

### parameter `PassThru`

Returns the run summary object (as Test-Automation's, plus ExcludedTests — the 'source-only' rows — and Build — the Build-Modules result).

### example 1

```powershell
Test-CatzcBuild
```

### example 2

```powershell
Test-CatzcBuild -Module Catzc.Base.Config -Level 1
```

### example 3

```powershell
Test-CatzcBuild -ModuleProfile base -Category Logic -PassThru
```

## comment:1

Above `$harnessModule = $MyInvocation.MyCommand.Module.Name`, written with `#`.

```text
The harness's own module rides in every build: workers reach its configuration builder and row reducer
through its module scope. Its tests still run only when the selection includes it.
The build names the resolved modules explicitly (closure-expanded again, so the harness's dependencies
come along).
```
